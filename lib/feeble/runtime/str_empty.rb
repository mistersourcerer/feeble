require "singleton"

module Feeble::Runtime
  class StrEmpty
    include Singleton
    include ListProperties

    def cons(char)
      Str.create char
    end

    def conj(char)
      cons char
    end

    def apnd(char)
      cons char
    end

    def ==(other)
      other.is_a? self.class
    end

    def to_a
      []
    end

    def to_s
      ""
    end

    def nill
      StrEmpty.instance
    end
  end
end
