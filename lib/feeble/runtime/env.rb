module Feeble::Runtime
  class Env
    def initialize(fallback = EnvNull.instance)
      @registry = {}
      @verify = Verifier.new
      @fallback = fallback
      @funcs = Tree.new
    end

    def lookup(id)
      @registry.fetch(id) { fallback.lookup id }
    end

    def register(name, value = nil)
      check_name_type name
      if @verify.fn? value
        @funcs.add name.to_s, value
      end
      @registry[name] = value
    end

    def fn(name)
      @funcs.search name.to_s
    end

    protected

    attr_accessor :fallback

    private

    def check_name_type(name)
      return if @verify.symbol?(name)

      raise "Only Symbols can be associated with values, not <#{name.inspect}>"
    end
  end
end
