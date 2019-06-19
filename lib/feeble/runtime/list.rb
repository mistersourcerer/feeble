module Feeble::Runtime
  class List
    include ListProperties

    def self.create(*args)
      return ListEmpty.instance if args.length == 0

      new args[0], create(*args[1..args.length]), count: args.length
    end

    def initialize(obj, rest = ListEmpty.instance, count: 1)
      @count = count
      @first = obj
      @rest = rest
      @fn = ListFunctions.new
    end

    def cons(obj)
      self.class.new obj, self, count: count + 1
    end

    def conj(*args)
      args.reduce(self) { |list, obj|
        self.class.new obj, list, count: list.count + 1
      }
    end

    def apnd(*args)
      args.reduce(self) { |list, obj|
        self.class.new list.first, list.rest.apnd(obj), count: list.count + 1
      }
    end

    def ==(other)
      return false if self.class != other.class
      same? self, other
    end

    def to_a
      [first] + rest.to_a
    end

    def printable(&printable_for)
      and_more = count > 5 ? " ..." : ""
      elements = Array(@fn.take(5, self))
      "(#{elements.map{ |el| printable_for.call(el) }.join(" ")}#{and_more})"
    end
  end
end
