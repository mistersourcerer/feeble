module Feeble::Runtime
  class Keyword
    include Feeble::Printer::Printable

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
      value.hash + :keyword.hash
    end

    def to_s
      @symbol.id
    end
  end
end
