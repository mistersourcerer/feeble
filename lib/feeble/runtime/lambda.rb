module Feeble::Runtime
  class Lambda
    include Invokable

    def initialize(params = [], body = [nil], evaler: Feeble::Evaler::Lispey.new)
      @evaler = evaler
      # create a arity for the params "arity(*params) {}
      # for the block: create an env for the function,
      #   wrap it around the caller env
      #   evaluate the body in the context of this new env
      arity(*params) do |env|
        fn_env = Env.new(env)
        body.reduce(nil) { |result, form|
          result = @evaler.eval(form, env: fn_env)
        }
      end
    end
  end
end
