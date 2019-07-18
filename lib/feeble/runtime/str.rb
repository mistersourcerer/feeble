module Feeble::Runtime
  class Str
    include ListProperties

    def self.create(body)
      return StrEmpty.instance if body.length == 0

      new body[0], create(body[1..-1]), count: body.length, body: body
    end

    def initialize(char, rest = StrEmpty.instance, count: 1, body: nil)
      @count = count
      @first = char
      @rest = rest
      @body = body || char
      @fn = ListFunctions.new(StrEmpty.instance)
    end

    def nill
      StrEmpty.instance
    end

    def cons(char)
      self.class.new char, self, count: count + 1
    end

    def to_s
      @body.to_s
    end

    def to_a
      @body.split ""
    end

    def to_print
      and_more = count > 5 ? " ..." : ""
      elements = fn.take(5, self)
      "\"#{elements}\"#{and_more})"
    end

    private

    attr_reader :fn

    def same?(list, other)
      return true if list == StrEmpty.instance && other == StrEmpty.instance
      list.first == other.first && same?(list.rest, other.rest)
    end
  end
end
