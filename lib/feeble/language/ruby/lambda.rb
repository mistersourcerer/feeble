module Feeble::Language::Ruby
  class Lambda
    include Feeble::Runtime
    include Invokable

    def initialize
      arity Symbol.new(:body) do |env|
        create_lambda_with [], env.lookup(Symbol.new(:body))
      end

      arity Symbol.new(:params), Symbol.new(:body) do |env|
        params = env.lookup(Symbol.new(:params))
        body = env.lookup(Symbol.new(:body))

        create_lambda_with params, body
      end
    end

    private

    def create_lambda_with(params, body)
      Feeble::Runtime::Lambda.new(params, body)
    end
  end
end
