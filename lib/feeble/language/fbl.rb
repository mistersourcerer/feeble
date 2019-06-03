module Feeble::Language
  include Feeble::Runtime

  class Fbl < Env
    include Feeble::Runtime

    HOST = Symbol.new("%host")

    def initialize(*_)
      super

      register Symbol.new("::"), Interop.new
      register HOST, HostEnv.new
      register Symbol.new("+"), Math::Plus.new
    end
  end
end
