module Feeble::Reader
  class Code
    include Feeble::Runtime
    include Feeble::Language
    include Feeble::Evaler

    DIGITS = /\A[0-9_]/
    STRING_DELIMITER = /\A"/
    SEPARATOR = /\A[\s,]/

    def read(code, env: Fbl.new, evaler: Lispey.new)
      reader = Char.new code
      component = ""
      values = []

      while reader.next
        if DIGITS.match(reader.current)
          values << read_number(reader)
          next
        end

        if STRING_DELIMITER.match(reader.current)
          values << read_string(reader)
          next
        end

        if SEPARATOR.match(reader.current)
          values << read_symbol(reader)
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

      values
    end

    private

    def build_invokation(fn, reader, evaler)
      if fn.is?(:special) && fn.is?(:operator)
        fn.invoke(reader, evaler)
      else
        # build normal function invokation (if it is invokation)
      end
    end

    def read_number(reader)
      number = reader.current
      while DIGITS.match reader.next
        number << reader.current
      end

      if reader.current == "."
        number << "."

        while DIGITS.match reader.next
          number << reader.current
        end

        return Float(number)
      end

      Integer(number)
    end

    def read_string(reader)
      if STRING_DELIMITER.match reader.next
        reader.next # consume delimiter
        return ""
      end

      finished = false
      string = reader.current

      while reader.next
        if STRING_DELIMITER.match reader.current
          finished = true
          reader.next
          break
        end

        string << reader.current
      end

      raise "Expected a \" but none was found." unless finished

      string
    end

    def read_symbol(reader)
      id = reader.current

      while reader.next
        if SEPARATOR.match reader.current
          reader.next # consume separator
          break
        end

        id << reader.current
      end

      Symbol.new id
    end
  end
end
