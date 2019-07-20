require "singleton"

module Feeble::Runtime
  class EnvNull
    include Singleton

    def lookup(_)
      # TODO: raise symbol not registered?
      nil
    end
  end
end
