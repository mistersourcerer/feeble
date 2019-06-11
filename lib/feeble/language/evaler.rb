module Feeble::Language
  class Evaler
    include Feeble::Runtime
    include Invokable

    def initialize(eval_strategy = Feeble::Evaler::Lispey.new)
      @eval_strategy = eval_strategy

      add_arity(Symbol.new(:lists)) { |env|
        self.eval env.invoke(Symbol.new(:lists))
      }
    end

    def eval(lists, env: Fbl.new)
      # TODO: Blog post on the difference of Array() on an enumerable
      # and on a non-enumerable is a good idea. I guess.
      (lists.is_a?(Array) ? lists : [lists]).reduce(nil) do |_, form|
        @eval_strategy.eval(form, env: env)
      end
    end
  end
end
