module Feeble::Runtime
  class List
    include Feeble::Printer::Printable
    include ListProperties

    def self.create(*args)
      return ListEmpty.instance if args.length == 0

      new args[0], create(*args[1..args.length]), count: args.length
    end

    def self.fn
      @fn ||= ListFunctions.new
    end

    def initialize(obj, rest = ListEmpty.instance, count: 1)
      @count = count
      @first = obj
      @rest = rest
      @fn = self.class.fn
    end

    def nill
      ListEmpty.instance
    end

    def cons(obj)
      self.class.new obj, self, count: count + 1
    end

    def to_a
      [first] + rest.to_a
    end

    def to_print(&printable_for)
      and_more = count > 5 ? " ..." : ""
      elements = Array(@fn.take(5, self))
      "(#{elements.map{ |el| printable_for.call(el) }.join(" ")}#{and_more})"
    end

    private

    def same?(list, other)
      return true if list == ListEmpty.instance && other == ListEmpty.instance
      list.first == other.first && same?(list.rest, other.rest)
    end
  end
end
