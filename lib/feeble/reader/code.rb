module Feeble::Reader
  class Code
    include Feeble::Runtime
    include Feeble::Language
    include Feeble::Evaler

    def read(code, env: Fbl.new, evaler: Lispey.new, fn_wrapper: nil)
      reader = Char.new code.strip
      component = ""
      values = []

      while reader.next
        # Went a whole string until a separator
        # without match it with function or value.
        # So it only can be a Symbol.
        if SEPARATOR.match? reader.current
          if component.length > 0
            values << Symbol.new(component)
            component = ""
          end

          ignore_separators(reader)
        end

        if value = consume_value(reader, env)
          values << value
          next
        end

        if LIST.match? reader.current
          values << consume_list_invokation(reader, env)
          component = ""
          next
        end

        component << reader.current

        # Last check: is it a special form?
        # If so, use it to interpret the code.
        fn = env.fn_lookup Symbol.new(component)
        if fn
          component = ""
          if fn.is?(:special)
            values << fn.invoke(reader, evaler)
          end
        end
      end

      values << Symbol.new(component) if component.length > 0

      wrap_return_values values, fn_wrapper
    end

    private

    DIGITS = /\A[0-9_]/
    STRING_DELIMITER = /\A\"/
    SEPARATOR = /\A[\s,]/
    ARRAY = /\A\[/
    ARRAY_CLOSE = /\A\]/
    LIST = /\A\(/
    LIST_CLOSE = /\A\)/
    INVOKATION_MARKER = Regexp.union SEPARATOR, LIST_CLOSE

    CONSUMERS = {
      DIGITS => :read_number,
      STRING_DELIMITER => :read_string,
      SEPARATOR => :read_symbol,
      ARRAY => :read_array
    }

    def ignore_separators(reader)
      while SEPARATOR.match?(reader.current) && !reader.eof?
        reader.next
      end
    end

    def wrap_return_values(values, fn_wrapper)
      return List.create(Symbol.new(fn_wrapper), *values) if !fn_wrapper.nil?

      if values.length > 1
        List.create(Symbol.new("eval"), *values)
      else
        values.first
      end
    end

    def consume_value(reader, env)
      consumer = CONSUMERS.keys.find(->{ nil }) { |matcher| matcher.match? reader.current }
      send(CONSUMERS[consumer], reader, env) if !consumer.nil?
    end

    def consume_list_invokation(reader, env)
      reader.next

      ignore_separators(reader)
      fn = reader.until_next(INVOKATION_MARKER)
      ignore_separators(reader)

      without_params = LIST_CLOSE.match?(reader.current)
      if without_params
        List.create Symbol.new(fn)
      else
        params = reader.until_next(LIST_CLOSE)
        read(params, env: env, fn_wrapper: fn)
      end
    end
      end
    end

    def read_number(reader, _)
      number = reader.read_until { |char| !DIGITS.match?(char) }

      is_float = reader.current == "."
      if is_float
        reader.next # consume "."

        number <<  "."
        number << reader.read_until { |char| !DIGITS.match?(char) }

        Float(number)
      else
        Integer(number)
      end
    end

    def read_string(reader, _)
      reader.next# consume "
      reader.until_next(STRING_DELIMITER)
    end

    def read_symbol(reader, _)
      # TODO: replace it with some sort of reader.until
      id = reader.until_next(SEPARATOR)
      Symbol.new id
    end

    def read_array(reader, env)
      reader.next # consume "["
      array_elements_string = reader.until_next(ARRAY_CLOSE)
      return List.create(Symbol.new("%arr")) if array_elements_string.nil?

      read(array_elements_string, env: env, fn_wrapper: "%arr")
    end

    def build_invokation(fn, reader, evaler)
      if fn.is?(:special) && fn.is?(:operator)
        fn.invoke(reader, evaler)
      else
        #TODO: build normal function invokation (if it is invokation)
      end
    end
  end
end
