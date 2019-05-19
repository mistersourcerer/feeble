module Feeble::Runtime
  class Env
    # Could be replace for a decent map implementation somewhen
    class Map
      def initialize
        @store = {}
      end

      def put(symbol, value)
        @store[symbol] = value
      end

      def get(symbol)
        @store[symbol]
      end
    end

    def initialize
      @registry = Map.new
    end

    def lookup(id)
      @registry.get id
    end

    def register(id, value = nil)
      @registry.put id, value
    end
  end
end
