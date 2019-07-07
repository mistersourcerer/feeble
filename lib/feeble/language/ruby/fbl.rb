module Feeble::Language::Ruby
  class Fbl < Feeble::Runtime::Env
    include Feeble::Runtime

    def initialize
      super

      register Symbol.new(:define), Define.new
      register Symbol.new(:quote), Quote.new
      register Symbol.new(:lambda), Feeble::Language::Ruby::Lambda.new
    end
  end
end
