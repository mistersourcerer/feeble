module Feeble::Reader
  class Code
    include Feeble::Runtime
    include Feeble::Language
    include Feeble::Evaler


    DIGITS = /\A[0-9_]/
    STRING_DELIMITER = /\A\"/
    SEPARATOR = /\A[\s,]/
    ARRAY = /\A\[/

    def read(code, env: Fbl.new, evaler: Lispey.new, fn_wrapper: nil)
      reader = Char.new code
      component = ""
      values = []

      while reader.next
        # ignore separators
        if SEPARATOR.match(reader.current)
          while SEPARATOR.match(reader.next) && !reader.eof?
            reader.next
          end
        end

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

      if !fn_wrapper.nil?
        return List.create(Symbol.new(fn_wrapper), *values)
      end

      if values.length > 1
        List.create(Symbol.new("eval"), *values)
      else
        values.first
      end
    end

    private

    def consume_value(reader, env)
      return read_number(reader) if DIGITS.match(reader.current)
      return read_string(reader) if STRING_DELIMITER.match(reader.current)
      return read_symbol(reader) if SEPARATOR.match(reader.current)
      return read_array(reader, env) if ARRAY.match(reader.current)
    end

    def build_invokation(fn, reader, evaler)
      if fn.is?(:special) && fn.is?(:operator)
        fn.invoke(reader, evaler)
      else
        #TODO: build normal function invokation (if it is invokation)
      end
    end

    def read_number(reader)
      number = read_until(reader) { DIGITS.match(reader.current) == nil }

      is_float = reader.current == "."
      if is_float
        number << read_until(reader) { DIGITS.match(reader.current) == nil }
        Float(number)
      else
        Integer(number)
      end
    end

    def read_string(reader)
      reader.next# consume "
      reader.read_until("Syntax Error: expecting \" but none found.") { |char|
        STRING_DELIMITER.match(char)
      }
    end

    def read_symbol(reader)
      # TODO: replace it with some sort of reader.until
      id = read_until(reader) { SEPARATOR.match reader.current }
      Symbol.new id
    end

    def read_array(reader, env)
      reader.next # consume "["
      array_elements_string = reader.until_next "]"
      return List.create(Symbol.new("%arr")) if array_elements_string.nil?

      read(array_elements_string, env: env, fn_wrapper: "%arr")
    end

    def read_until(reader, cond = nil, condition: nil, fail_with: nil, &block)
      finished = false
      break_when = condition || cond || block

      acc = accumulate_until(reader, reader.current) {
        break_when.call ? finished = true : false
      }

      should_fail = fail_with && !finished
      should_fail ? fail_with.call : acc
    end

    def accumulate_until(reader, acc_start)
      acc = acc_start

      while reader.next
        if yield
          break
        else
          acc << reader.current
        end
      end

      acc
    end
  end
end
