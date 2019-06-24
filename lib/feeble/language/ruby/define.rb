module Feeble::Language::Ruby
  class Define
    def initialize
      # A special invokable:
      #   - will have all arguments quoted (during read phase)
      #   - have a %xenv reference to the external environment

      # prop :special, true

      # arity(:symbol, :expression) { |env|
      #   name = env.lookup Symbol.new(:symbol)
      #   value = env.lookup Symbol.new(:expression)

      #   xenv = env.lookup Symbol.new(:"%xenv")
      #   xenv.register name, value
      # }
      @evaler = Feeble::Evaler::Lispey.new
    end

    def invoke(env, params)
      # fn_env = Env.new
      # fn_env.register "%xenv", env
      # xenv = env

      symbol, expression = params[0], params[1]

      #xenv.register symbol, expression
      env.register symbol, @evaler.eval(expression, env: env)
      symbol
    end
  end
end
