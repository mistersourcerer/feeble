module Feeble::Runtime
  class Env
    def initialize
      @registry = {}
      @verify = Verifier.new
    end

    def lookup(id)
      @registry[id]
    end

    def register(name, value = nil)
      check_name_type name
      @registry[name] = value
    end

    private

    def check_name_type(name)
      return if @verify.symbol?(name)

      raise "Only Symbols can be associated with values, not <#{name.inspect}>"
    end
  end
end
