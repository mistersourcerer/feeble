module Feeble::Evaler
  class Lispey
    def initialize
      @verify = Feeble::Runtime::Verifier.new
    end

    def eval(form, env: nil)
      if @verify.list? form
        eval_list env, form
      end
    end

    private

    def eval_list(env, list)
      raise "Can't invoke <#{list.first}>, not a function"
    end
  end
end
