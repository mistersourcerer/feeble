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
      if fn = env.lookup(list.first) # && @verify.fn? fn
        return fn.invoke(*Array(list.rest))
      end

      raise "Can't invoke <#{list.first}>, not a function"
    end

    def eval_expression(expression, env)
      expression
    end
  end
end
