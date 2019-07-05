module Feeble::Language::Ruby
  class Quote
    include Feeble::Runtime
    include Invokable

    def initialize
      prop :special

      arity(Symbol.new("expression")) { |env|
        env.lookup(Symbol.new("expression"))
      }
    end
  end
end
