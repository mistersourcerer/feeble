module Feeble::Evaler
  class Lispey
    def initialize
      @verify = Feeble::Runtime::Verifier.new
    end

    def eval(form, env: Feeble::Language::Fbl.new)
      if form.is_a? Array
        return form.reduce(nil) { |_, form| self.eval(form, env: env) }
      end

      case
      when env_lookup?(env, form)
        do_lookup(env, form)
      when fn_invokation?(env, form)
        do_invoke(env, form)
      else
        raise "Unrecognized form #{form}"
      end
    end

    private

    def env_lookup?(env, form)
      new_env = env.invoke form.first
      @verify.env?(new_env) && form.rest.count > 0
    end

    def do_lookup(env, form)
      new_env = env.invoke(form.first).wrap(env)
      new_form = form.rest

      self.eval new_form, env: new_env
    end

    def fn_invokation?(env, form)
      @verify.fn? env.invoke(form.first)
    end

    def do_invoke(env, form)
      fn = env.invoke(form.first)
      result = invoke_fn fn, form.rest.to_a, env

      @verify.list?(result) ? self.eval(result, env: env) : result
    end

    def invoke_fn(fn, params, env)
      return fn.invoke(params, scope: env) if fn.is? :special

      fn.invoke(*params, scope: env)
    end
  end
end
