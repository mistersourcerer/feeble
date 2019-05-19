module Feeble::Runtime
  class Symbol
    attr_reader :id

    def initialize(id)
      @id = String(id).to_sym
    end

    def ==(other)
      return false if self.class != other.class
      id == other.id
    end

    def eql?(other)
      self == other
    end

    def hash
      id.hash + :symbol.hash
    end

    def to_s
      id.to_s
    end
  end
end
