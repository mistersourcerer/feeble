require "singleton"

module Feeble::Runtime
  class ListEmpty
    include Singleton
    include ListProperties

    def cons(obj)
      List.create obj
    end

    def conj(obj)
      cons obj
    end

    def apnd(obj)
      cons obj
    end

    def ==(other)
      other.is_a? self.class
    end
  end
end