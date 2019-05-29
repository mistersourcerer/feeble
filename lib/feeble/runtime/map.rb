module Feeble::Runtime
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
end
