module Feeble::Language::Ruby
  class Print
    include Feeble::Runtime
    include Invokable

    def initialize
      arity(Symbol.new(:expression)) do |env|
        print env.lookup(Symbol.new(:expression))
      end
    end

    private

    def print(expression)
      $stdout.print expression
    end
  end
end
