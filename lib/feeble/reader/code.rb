module Feeble::Reader
  class Code
    include Feeble::Runtime

    def read(code, env: nil)
      reader = Char.new code.strip
      component = ""
      values = []

      while reader.next
        if QUOTE.match? reader.current
          values << read_quote(reader, env)
          next
        end

        component << reader.current
      end

      # treat last component not recognized
      values << Symbol.new(component) if component.length > 0

      values
    end

    private

    QUOTE = /\A\'/
    LIST = /\A\(/
    LIST_CLOSE = /\A\)/

    def read_quote(reader, env)
      reader.next

      read_quoted_list(reader, env) if LIST.match? reader.current
    end

    def read_quoted_list(reader, env)
      reader.next

      List.create(Symbol.new("quote"), read_list(reader, env))
    end

    def read_list(reader, env)
      list_content = reader.until_next(LIST_CLOSE)

      List.create(*read(list_content, env: env))
    end
  end
end
