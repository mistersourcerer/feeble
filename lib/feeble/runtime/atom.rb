module Feeble::Runtime
  class Atom
    def initialize(id)
      @symbol = Symbol.new(id)
    end

    def value
      @symbol
    end

    def ==(other)
      return false if self.class != other.class
      value == other.value
    end

    def eql?(other)
      self == other
    end

    def hash
      value.hash + :atom.hash
    end
  end
end
