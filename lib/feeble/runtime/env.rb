module Feeble::Runtime
  class Env
    include Invokable

    def initialize(registry = Map.new)
      @registry = registry
      @verify = Verifier.new
      @envs = []

      register_lookup_invokation
      register_storing_invokation
    end

    def lookup(id)
      @registry.get id
    end

    def register(id, value = nil)
      @registry.put id, value
    end

    def wrap(env)
      return self if !env
      raise "Expected #{env} to be an Env" unless @verify.env? env

      self.class.new env.registry.merge(@registry)
    end

    protected

    def registry
      @registry
    end

    private

    def register_lookup_invokation
      add_arity(Symbol.new(:lookup)) { |env|
        name = env.lookup Symbol.new(:lookup)
        @verify.symbol?(name) ? self.lookup(name) : nil
      }
    end

    def register_storing_invokation
      add_arity(Symbol.new(:name), Symbol.new(:value)) { |env|
        name = env.lookup Symbol.new(:name)
        if !@verify.symbol?(name)
          raise "Only Symbols can be associated with values, not #{name}"
        end

        self.register name, env.lookup(Symbols.new(:value))
      }
    end
  end
end
