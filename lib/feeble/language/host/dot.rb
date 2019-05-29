module Feeble::Language::Host
  class Dot
    include Feeble::Runtime
    include Feeble::Runtime::Invokable

    def initialize
      add_var_args(Symbol.new(:path)) { |env|
        target, method, params = invokation_from env.invoke(Symbol.new(:path))
        raise "#{target} is not defined by %host." unless defined? target

        target.send(method, *params)
      }
    end

    private

    def invokation_from(path)
      [
        path.shift,
        path.shift.id,
        path
      ]
    end
  end
end
