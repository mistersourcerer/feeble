module Feeble::Reader
  class Read
    include Feeble::Runtime
    include Invokable

    def initialize
      arity(Symbol.new(:code)) { |env| read env.lookup(Symbol.new(:code)) }
    end

    private

    def read(string)
    end
  end
end
