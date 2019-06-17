module Feeble::Reader
  class Code
    include Feeble::Runtime
    include Feeble::Language
    include Feeble::Evaler

    def read(code, env: Fbl.new, evaler: Lispey.new, fn_wrapper: nil)
      reader = Char.new code
      component = ""
      values = []

      while reader.next
        ignore_separators(reader)

        if value = consume_value(reader, env)
          values << value
          next
        end

        component << reader.current
        fn = env.fn_lookup Symbol.new(component)
        if fn
          component = ""
          values << build_invokation(fn, reader, evaler)
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

    CONSUMERS = {
      DIGITS => :read_number,
      STRING_DELIMITER => :read_string,
      SEPARATOR => :read_symbol,
      ARRAY => :read_array
    }

    def ignore_separators(reader)
      if SEPARATOR.match?(reader.current)
        while SEPARATOR.match?(reader.next) && !reader.eof?
          reader.next
        end
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

    def build_invokation(fn, reader, evaler)
      if fn.is?(:special) && fn.is?(:operator)
        fn.invoke(reader, evaler)
      else
        #TODO: build normal function invokation (if it is invokation)
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
  end
end
