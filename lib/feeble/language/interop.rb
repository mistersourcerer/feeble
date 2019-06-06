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
  end
end
