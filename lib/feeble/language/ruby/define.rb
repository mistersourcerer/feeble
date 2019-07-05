module Feeble::Language::Ruby
  class Define
    include Feeble::Runtime
    include Invokable

    def initialize
      # A special invokable:
      #   - will have all arguments quoted (during read phase)
      #   - have a %xenv reference to the external environment

      @evaler = Feeble::Evaler::Lispey.new

      prop :special

      arity(Symbol.new(:symbol), Symbol.new(:expression)) { |env|
        name = env.lookup Symbol.new(:symbol)
        expression = env.lookup Symbol.new(:expression)
        value = @evaler.eval(expression, env: env)

        xenv = env.lookup Symbol.new(:"%xenv")
        xenv.register name, value
      }
    end
  end
end
