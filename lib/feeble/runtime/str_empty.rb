require "singleton"

module Feeble::Runtime
  class StrEmpty
    include Singleton
    include ListProperties

    def cons(char)
      Str.create char
    end

    # def conj(obj)
    #   cons obj
    # end

    # def apnd(obj)
    #   cons obj
    # end

    def ==(other)
      other.is_a? self.class
    end

    def to_a
      []
    end

    def nill
      StrEmpty.instance
    end
  end
end
