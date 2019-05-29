module Feeble::Language
  class HostEnv < Env
    include Feeble::Runtime
    include Feeble::Language::Host

    def initialize(*_)
      super

      register Symbol.new("."), Dot.new
    end
  end
end
