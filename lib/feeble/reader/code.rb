module Feeble::Reader
  class Code
    include Feeble::Runtime

    def initialize
      @syntax = Tree.new

      @syntax.add LAMBDA, :read_lambda
    end

    def read(code, env: nil)
      reader = code.is_a?(Char) ? code : Char.new(code.strip)
      component = ""
      values = []

      while reader.next
        if SEPARATOR.match?(reader.current) &&
            (component.length > 0 || (reader.prev == "{" || reader.prev == "("))
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

        if reader.current == "\""
          values << read_string(reader, env)

          component = ""
          next
        end

        if reader.current == "("
          if component.length > 0
            values << read_invokation(component, reader, env)
          else
            values << read_list(reader, env)
          end

          component = ""
          next
        end

        if reader.current == ")"
          values << make_expression(component) if component.length > 0

          component = ""
          break
        end

        if reader.current == "{"
          values << read_map(reader, env)

          component = ""
          next
        end

        if reader.current == "}"
          values << make_expression(component) if component.length > 0

          component = ""
          break
        end

        component << reader.current if reader.current
      end

      values << make_expression(component) if component.length > 0
      values
    end

    private

    LAMBDA = "->"
    SEPARATOR = /\A[\s,]/
    NUMBER = /\A[\d-]([\d\_\.]*\z)/

    def make_expression(component)
      return Keyword.new(component) if component.end_with? ":"

      value = value_of(component)
      if value.nil?
        Symbol.new(component)
      else
        value
      end
    end

    def value_of(component)
      case
      when component == "true" || component == "false"
        component == "true"
      when NUMBER.match?(component)
        /\./.match?(component) ? Float(component) : Integer(component)
      else
        nil
      end
    end

    def read_quote(reader, env)
      reader.next

      args =
        if reader.current == "("
          List.create(read_list(reader, env))
        else
          expression_content = reader.until_next(SEPARATOR, or_eof: true)
          read(expression_content, env: env)
        end

      List.create(Symbol.new("quote"), *args)
    end

    def read_string(reader, env)
      reader.next

      reader.until_next("\"")
    end

    def read_lambda(reader, env)
      ignore_separators reader
      params = nil

      map_or_body =
        if reader.current == "{" # map or body
          read_list(reader, env).to_a
        else
          params_content = reader.until_next "{"
          params = read(params_content, env: env)
          read_list(reader, env).to_a
        end
      reader.next # consume }
      ignore_separators reader

      map, body =
        if reader.current == "{"
          ignore_separators(reader)
          body = read_list(reader, env).to_a
          ignore_separators(reader)
          reader.next

          [Hash[*map_or_body], body]
        else
          [nil, map_or_body]
        end

      lambda_declaration = []
      lambda_declaration << params if !params.nil?
      lambda_declaration << body
      lambda_declaration << map if !map.nil?

      List.create(*lambda_declaration).cons Symbol.new("lambda")
    end

    def read_map(reader, env)
      Hash[*read(reader, env: env)].tap { reader.next }
    end

    def ignore_separators(reader)
      while SEPARATOR.match?(reader.current) && !reader.eof?
        reader.next
      end
    end

    def read_list(reader, env)
      list_content = read(reader, env: env) { ignore_separators(reader) }
      reader.next

      List.create(*list_content)
    end

    def read_invokation(fn_name, reader, env)
      params = read_list(reader, env)

      List.create(Symbol.new(fn_name), *params)
    end
  end
end
