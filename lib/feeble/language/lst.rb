module Feeble::Language
  class Lst
    include Feeble::Runtime
    include Invokable

    def initialize
      add_var_args(Symbol.new(:items)) do |env|
        List.create(*env.invoke(Symbol.new(:items)))
      end
    end
  end
end
