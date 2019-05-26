module Feeble::Runtime
  class Env
    # Could be replace for a decent map implementation somewhen
    class Map
      def initialize(store = {})
        @store = store
      end

      def put(symbol, value)
        @store[symbol] = value
      end

      def get(symbol)
        @store[symbol]
      end

      def merge(map)
        self.class.new map.store.merge(@store)
      end

      protected

      def store
        @store
      end
    end

    def initialize(registry = Map.new)
      @registry = registry
      @verify = Verifier.new
      @envs = []
    end

    def lookup(id)
      @registry.get id
    end

    def register(id, value = nil)
      @registry.put id, value
    end

    def wrap(env)
      raise "Expected #{env} to be an Env" unless @verify.env? env

      self.class.new env.registry.merge(@registry)
    end

    def invoke(*params)
      apply_1 params.first if params.length == 1
    end

    protected

    def registry
      @registry
    end

    private

    def apply_1(param)
      return lookup param if @verify.symbol? param
    end
  end
end
