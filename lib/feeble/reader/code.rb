module Feeble::Reader
  class Code
    include Feeble::Runtime

    def initialize
      @syntax = Tree.new

      @syntax.add LAMBDA, :read_lambda
    end

    def read(code, env: nil)
      reader = Char.new code.strip
      component = ""
      values = []

      while reader.next
        if SEPARATOR.match?(reader.current) && component.length > 0
          ignore_separators(reader)

          if component.length > 0
            if known_syntax = @syntax.search(component)
              values << send(known_syntax, reader, env)
            else
              values << make_expression(component)
            end

            ignore_separators(reader)
            component = ""
          end
        end

        if reader.current == "'"
          values << read_quote(reader, env)
          component = ""
          next
        end

        if reader.current == "{"
          values << read_map(reader, env)
          component = ""
          next
        end

        component << reader.current if reader.current
      end

      values << make_expression(component) if component.length > 0
      values
    end

    private

    LAMBDA = "->"

    SEPARATOR = /\A[\s,]/

    def make_expression(component)
      return Atom.new(component) if component.end_with? ":"

      value = value_of(component)
      if value.nil?
        Symbol.new(component)
      else
        value
      end
    end

    def value_of(component)
      if component == "true" || component == "false"
        component == "true"
      else
        nil
      end
    end

    def read_lambda(reader, env)
      ignore_separators reader
      params = nil

      map_or_body =
        if reader.current == "{" # map or body
          reader.next
          reader.until_next "}"
        else
          params_content = reader.until_next "{"
          reader.next
          params = read(params_content, env: env)
          reader.until_next "}"
        end
      reader.next # consume }
      ignore_separators reader

      map, body =
        if reader.current == "{"
          reader.next # consume {
          body_content = reader.until_next("}")
          reader.next # consume }
          ignore_separators(reader)

          [consume_map_content(map_or_body, env), read(body_content, env: env)]
        else
          [nil, read(map_or_body, env: env)]
        end

      lambda_declaration = []
      lambda_declaration << params if !params.nil?
      lambda_declaration << body
      lambda_declaration << map if !map.nil?

      List.create(*lambda_declaration).cons Symbol.new("lambda")
    end

    def read_map(reader, env)
      reader.next # consume {
      map_content = reader.until_next("}")
      reader.next # consume }

      consume_map_content(map_content, env)
    end

    def consume_map_content(map_content, env)
      Hash[*read(map_content, env: env)]
    end

    def ignore_separators(reader)
      while SEPARATOR.match?(reader.current) && !reader.eof?
        reader.next
      end
    end

    def read_quote(reader, env)
      reader.next

      read_quoted_list(reader, env) if reader.current == "("
    end

    def read_quoted_list(reader, env)
      reader.next

      List.create(Symbol.new("quote"), read_list(reader, env))
    end

    def read_list(reader, env)
      list_content = reader.until_next(")")

      List.create(*read(list_content, env: env))
    end
  end
end
