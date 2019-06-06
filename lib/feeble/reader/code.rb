module Feeble::Reader
  class Code
    include Feeble::Runtime
    include Feeble::Language
    include Feeble::Evaler

    DIGITS = /\A[0-9_]/

    def read(code, env: Fbl.new, evaler: Lispey.new)
      reader = Char.new code
      component = ""
      values = []

      while reader.next
        component << reader.current
        fn = env.fn_lookup Symbol.new(component)
        if fn && fn.is?(:special)
          values << invoke_special(fn, reader, evaler)
        else # TODO: should be the last try in the reading...
          values << read_number(reader) if DIGITS.match(reader.current)
        end
      end

      values
    end

    private

    def invoke_special(fn, reader, evaler)
      if fn.is? :operator
        fn.invoke reader, evaler
      else
        # Check if it is an invokation,
        # could be that the fn is been passed as parameter.
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
  end
end
