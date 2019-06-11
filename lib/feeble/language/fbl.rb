module Feeble::Language
  include Feeble::Runtime

  class Fbl < Env
    include Feeble::Runtime
    include Feeble::Reader
    include Feeble::Evaler

    HOST = Symbol.new("%host")

    def initialize(*_)
      super

      register HOST, HostEnv.new
      register Symbol.new("::"), Interop.new
      register Symbol.new("eval"), Evaler.new
      register Symbol.new("%arr"), Arr.new
      # register Symbol.new("read", Reader.new)
      register Symbol.new("+"), Math::Plus.new
    end

    def eval(code, reader: Code.new, evaler: Lispey.new)
      evaler.eval reader.read(code)
    end
  end
end
