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
  end
end
