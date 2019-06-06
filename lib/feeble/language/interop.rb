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
        path = env.invoke(Symbol.new(:path)).dup
        transform_path_into_dot_invokation path
      }

      add_arity(Symbol.new(:reader), Symbol.new(:evaler)) { |env|
        read env.invoke(Symbol.new(:reader)), env.invoke(Symbol.new(:evaler))
      }
    end

    private

    def transform_path_into_dot_invokation(path)
      target, invokation_path = target_and_path_from path

      List.create(Fbl::HOST, Symbol.new("."), target, *invokation_path)
    end

    def target_and_path_from(path)
      if dot_invokation? path
        [path.shift, method_name_from(path)]
      else
        [Symbol.new("Kernel"), path]
      end
    end

    def dot_invokation?(path)
      [Symbol.new(".")] == path[1..1]
    end

    def method_name_from(path)
      Symbol.new(path.last.id.to_s.gsub("()", ""))
    end

    def read(reader, _)
      component_reader = Feeble::Reader::Code.new
      component = ""
      components = []

      while reader.next
        if reader.current == "("
          components << component_reader.read(component).last
          component = ""
          components += read_parameters(reader)
          break if reader.eof?
        end

        if reader.current == "."
          components << component_reader.read(component).last
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

      Feeble::Reader::Code.new.read params_string
    end
  end
end
