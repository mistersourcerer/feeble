module Feeble::Runtime
  class Env
    def initialize(fallback = EnvNull.instance)
      @registry = {}
      @verify = Verifier.new
      @fallback = fallback
    end

    def lookup(id)
      @registry.fetch(id) { fallback.lookup id }
    end

    def register(name, value = nil)
      check_name_type name
      @registry[name] = value
    end

    protected

    attr_accessor :fallback

    private

    def check_name_type(name)
      return if @verify.symbol?(name)

      raise "Only Symbols can be associated with values, not <#{name.inspect}>"
    end
  end

  require "singleton"

  class EnvNull
    include Singleton

    def lookup(_)
      # TODO: raise symbol not registered?
      nil
    end
  end
end
