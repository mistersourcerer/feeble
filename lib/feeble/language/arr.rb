module Feeble::Language
  class Arr
    include Feeble::Runtime
    include Invokable

    def initialize
      add_var_args(Symbol.new(:elements)) do |env|
        Array(env.invoke(Symbol.new(:elements)))
      end

      add_arity { [] }
    end
  end
end
