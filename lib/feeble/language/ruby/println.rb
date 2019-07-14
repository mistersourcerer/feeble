module Feeble::Language::Ruby
  class Println
    include Feeble::Runtime
    include Invokable

    def initialize
      arity(Symbol.new(:expression)) do |env|
        print env.lookup(Symbol.new(:expression))
      end
    end

    private

    def print(expression)
      $stdout.print expression + "\n"
    end
  end
end
