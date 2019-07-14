module Feeble::Evaler
  class Lispey
    def initialize
      @verify = Feeble::Runtime::Verifier.new
    end

    def eval(form, env: Feeble::Language::Ruby::Fbl.new)
      if @verify.list? form
        eval_list form, env
      else
        eval_expression form, env
      end
    end

    private

    def eval_list(list, env)
      first_form = fn = env.lookup(list.first)
      # return eval_list(first_form, env) if @verify.list? first_form

      if @verify.fn? fn
        if fn.prop?(:special)
          env.register Feeble::Runtime::Symbol.new("%xenv"), env
          return fn.invoke(*Array(list.rest), scope: env)
        else
          evaled = Array(list.rest).map { |expression|
            eval_expression(expression, env)
          }
          return fn.invoke(*evaled, scope: env)
        end
      end

      raise "Can't invoke <#{list.first}>, not a function"
    end

    def eval_expression(expression, env)
      if @verify.symbol? expression
        # TODO: maybe raise if not registered (instead of returning undefined)
        #   "unable to resolve" is actually pretty sweet
        env.lookup expression
      else
        expression
      end
    end
  end
end
