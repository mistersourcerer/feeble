module Feeble::Language
  class Interop
    class UnknownInvokationType < StandardError
      def initialize(invokation_type)
        super "Interop failed. Unknown [#{invokation_type}] invokation type."
      end
    end

    include Feeble::Runtime
    include Feeble::Runtime::Invokable

    RUBY_STRING_DELIMITER = /\A[\"|\']/

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
        if fn_invokation?(reader)
          components << component_reader.read(component)
          component = ""

          components << array_with_params(reader)

          break if reader.eof?
          next
        end

        if string?(reader)
          reader.next # consume "
          components << reader.until_next(RUBY_STRING_DELIMITER)

          component = ""

          break if reader.eof?
          next
        end

        if reader.current == "."
          components << component_reader.read(component) if component.length > 0
          components << Symbol.new(".")
          component = reader.next
        else
          component << reader.current
        end
      end

      invoke components
    end

    def fn_invokation?(reader)
      reader.current == "("
    end

    def string?(reader)
      RUBY_STRING_DELIMITER.match? reader.current
    end

    def array_with_params(reader)
      reader.next
      error_message = "Syntax Error: Expecting ) but none was found"
      params_string = reader.read_until(error_message) { |char| char == ")" }
      col_params_string = "[" + params_string + "]"
      Feeble::Reader::Code.new.read col_params_string
    end
  end
end
