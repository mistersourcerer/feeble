module Feeble::Runtime
  class Str
    include ListProperties

    def self.create(body)
      body = String(body)
      return StrEmpty.instance if body.length == 0

      new body[0], create(body[1..-1]), count: body.length, body: body
    end

    def initialize(char, rest = StrEmpty.instance, count: 1, body: nil)
      @nill = StrEmpty.instance
      @count = count
      @first = String(char)
      @rest = rest
      @body = String(body || @first + String(rest))
      @fn = ListFunctions.new(nill)
    end

    def cons(char)
      if String(char).length > 1
        self.class.create String(char) + self.to_s
      else
        self.class.new char, self, count: count + 1
      end
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
      "\"#{elements}#{and_more}\""
    end

    def inspect
      "#{@body[0..20]} ...(str [#{@body.length} chars])"
    end

    private

    attr_reader :fn

    def same?(list, other)
      return true if list == StrEmpty.instance && other == StrEmpty.instance
      list.first == other.first && same?(list.rest, other.rest)
    end
  end
end
