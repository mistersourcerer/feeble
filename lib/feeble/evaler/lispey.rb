module Feeble::Evaler
  class Lispey
    def initialize
      @verify = Feeble::Runtime::Verifier.new
    end

    def eval(form, env: Feeble::Language::Fbl.new)
      if @verify.list? form
        eval_list env, form
      else
        eval_form env, form
      end
    end

    private

    def eval_list(env, list)
      if env_lookup?(env, list)
        lookup(env, list)
      else
        invoke(env, list)
      end
    end

    def eval_form(env, form)
      if @verify.symbol? form
        env.invoke form
      else
        # TODO: check if it is a "returnable" form
        # (Int, Float, String, Array)
        form
        #raise "Unrecognized form #{form}"
      end
    end

    def env_lookup?(env, list)
      new_env = env.invoke list.first

      @verify.env?(new_env) && list.rest.count > 0
    end

    def lookup(env, list)
      new_env = env.invoke(list.first).wrap(env)
      new_form = list.rest

      self.eval new_form, env: new_env
    end

    def invoke(env, list)
      fn = env.invoke(list.first)
      if !@verify.fn?(fn)
        raise "Can't invoke <#{list.first}>, nor recognize it as a form"
      end

      result = invoke_fn fn, list.rest.to_a, env

      @verify.list?(result) ? self.eval(result, env: env) : result
    end

    def invoke_fn(fn, params, env)
      return fn.invoke(params, scope: env) if fn.is? :special

      fn.invoke(*params, scope: env)
    end
  end
end
