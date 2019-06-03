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
      add_arity(Symbol.new(:path)) { |env|
        path = env.invoke(Symbol.new(:path)).dup
        target, invokation_path =
          if dot_invokation? path
            [path.shift, Symbol.new(path.last.id.to_s.gsub("()", ""))]
          else
            [Symbol.new("Kernel"), path]
          end

        List.create(Fbl::HOST, Symbol.new("."), target, *invokation_path)
      }
    end

    private

    def dot_invokation?(path)
      [Symbol.new(".")] == path[1..1]
    end
  end
end
