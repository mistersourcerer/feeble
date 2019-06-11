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

    def read(reader, _)
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
          components << component_reader.read(component)
          components << Symbol.new(".")
          component = reader.next
        else
          component << reader.current
        end
      end

      invoke components
    end

    def read_parameters(reader)
      finished = false
      params_string = ""

      while reader.next
        if reader.current == ")"
          finished = true
          reader.next
          break
        end

        params_string << reader.current
      end

      raise "Expected to find a ), but nothing was found" unless finished

      if params_string.length == 0
        nil
      else
        # Parameters will always be an Array(ish).
        # So we should force this to be evaluated as a list.
        # Is almost like fn(a b) was a sugar syntax for
        # fn.invoke [ List.create("eval", "a"), List.create("eval", "b") ]
        col_params_string = "[" + params_string + "]"
        Feeble::Reader::Code.new.read col_params_string
      end
    end
  end
end
