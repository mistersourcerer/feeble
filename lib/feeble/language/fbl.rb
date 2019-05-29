module Feeble::Language
  include Feeble::Runtime

  class Fbl < Env
    include Feeble::Runtime

    def initialize(*_)
      super

      register Symbol.new("%host"), HostEnv.new
      register Symbol.new("+"), Math::Plus.new
    end
  end
end
