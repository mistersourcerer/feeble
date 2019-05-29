module Feeble::Evaler
  class Lispey
    def initialize
      @verify = Feeble::Runtime::Verifier.new
    end

    def eval(form, env: Feeble::Language::Fbl.new)
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
      result = env.invoke(form.first).invoke(*form.rest.to_a, scope: env)

      @verify.list?(result) ? self.eval(result, env: env) : result
    end
  end
end
