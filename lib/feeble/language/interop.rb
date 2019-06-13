module Feeble::Language
  class Interop
    class UnknownInvokationType < StandardError
      def initialize(invokation_type)
        super "Interop failed. Unknown [#{invokation_type}] invokation type."
      end
    end

    include Feeble::Runtime
    include Feeble::Runtime::Invokable

    def initialize
      put Symbol.new(:special)
      put Symbol.new(:operator)

      add_arity(Symbol.new(:path)) { |env|
        path = env.invoke(Symbol.new(:path))
        target =
          if dot_invokation? path
            path.first.tap { path = path[2..] }
          else
            Symbol.new("Kernel")
          end

        # TODO: UGLY AS HELL, let's make it better
        # Means that we have parameters, we need to evaluate them
        if @verify.list? path.last
          evaler = Feeble::Evaler::Lispey.new
          params = evaler.eval(path.last)
          path = path[0...-1] + Array(params)
        end

        List.create Fbl::HOST, Symbol.new("."), target, *path
      }

      add_arity(Symbol.new(:reader), Symbol.new(:evaler)) { |env|
        read env.invoke(Symbol.new(:reader)), env.invoke(Symbol.new(:evaler))
      }
    end

    private

    def dot_invokation?(path)
      Symbol.new(".") == path[1..1].first
    end

    def method_name_from(path)
      Symbol.new(path.to_a.last.id.to_s.gsub("()", ""))
    end

    def read(reader, evaler)
      component_reader = Feeble::Reader::Code.new
      component = ""
      components = []

      while reader.next
        if reader.current == "("
          components << component_reader.read(component)
          component = ""
          if params = read_parameters(reader)
            components << params
          end
          break if reader.eof?
        end

        if reader.current == "."
          components << component_reader.read(component) if component.length > 0
          components << Symbol.new(".")
          component = reader.next
        else
          component << reader.current
        end

        if reader.current == "\""
          components << reader.until_next('"')
          component = ""
          break if reader.eof?
        end
      end

      invoke components
    end

    def read_parameters(reader)
      params_string = reader.until_next(")")
      col_params_string = "[" + params_string + "]"
      Feeble::Reader::Code.new.read col_params_string
    end
  end
end
