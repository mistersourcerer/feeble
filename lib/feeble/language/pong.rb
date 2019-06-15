module Feeble::Language
  class Pong
    include Feeble::Runtime
    include Feeble::Runtime::Invokable

    def initialize
      with = Symbol.new(:with)
      add_arity(with) { |env| "pong with: #{env.invoke(with)}" }
    end
  end
end
