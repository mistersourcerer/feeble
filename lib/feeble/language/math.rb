module Feeble::Language::Math
  class Plus
    include Feeble::Runtime
    include Feeble::Runtime::Invokable

    def initialize
      add_arity(Symbol.new(:lhs_addend), Symbol.new(:rhs_addend)) { |env|
        invoke [
          env.invoke(Symbol.new(:lhs_addend)),
          env.invoke(Symbol.new(:rhs_addend))
        ]
      }

      add_var_args(Symbol.new(:addends)) { |env|
        env.invoke(Symbol.new(:addends)).reduce(0) { |sum, current|
          sum + current
        }
      }
    end
  end
end
