module Feeble::Evaler
  class Lispey
    def initialize
      @verify = Feeble::Runtime::Verifier.new
    end

    def eval(form, env: Feeble::Language::Ruby::Fbl.new)
      if @verify.list? form
        eval_list form, env
      end
    end

    private

    def eval_list(list, env)
      if fn = env.lookup(list.first) # && @verify.fn? fn
        return fn.invoke list.rest
      end

      raise "Can't invoke <#{list.first}>, not a function"
    end
  end
end
