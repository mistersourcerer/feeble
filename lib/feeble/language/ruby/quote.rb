module Feeble::Language::Ruby
  class Quote
    include Feeble::Runtime
    include Invokable

    def initialize
      prop :special

      arity(Symbol.new("value")) { |env| env.lookup(Symbol.new("value")) }
    end
  end
end
