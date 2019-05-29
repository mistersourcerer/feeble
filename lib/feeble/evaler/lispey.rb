module Feeble::Evaler
  class Lispey
    def initialize
      @verify = Feeble::Runtime::Verifier.new
    end

    def eval(form, env: Feeble::Language::Fbl.new)
      value = env.invoke form.first


      is_env_lookup = @verify.env?(value) && form.rest.count > 0
      if is_env_lookup
        new_env = value.wrap(env)
        new_form = form.rest
        return self.eval(new_form, env: new_env)
      end

      if @verify.fn? value
        result = value.invoke(*form.rest.to_a, scope: env)
        if @verify.list? result
          return self.eval(result, env: env)
        else
          return result
        end
      end

      if @verify.list? value
        self.eval(value, env: env)
      else
        value
      end
      # evaluate value, form.rest
    end

    private

    def apply_fn(fn, params, env)
      fn.invoke(params, env: env)
    end

    def evaluate(result, list)
      # First we solve the values inside a context.
      # If a previous evaluation results on an Env,
      # we know that we are (probably) trying to
      # find stuff that is inside there.
      return self.eval list, env: result if @verify.env? result
      # Then we evaluate lists until they result a non-list value.
      #
      #
      # ACTUALLY: the result should always be:
      #   - list (form)
      #   - or value
      #   If the first element is a environment,
      #   then it resturns:
      #     A curryied function with the "second" list element
      #     The rest of the elements to be passed as parameters.
      return self.eval result, env: env if @verify.list? result
      # If 
      return result.invoke(form.rest.to_a, env: env) if @verify.fn? result
      result
    end
  end
end
