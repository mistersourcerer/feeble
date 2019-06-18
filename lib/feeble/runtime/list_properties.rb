module Feeble::Runtime
  module ListProperties
    def first
      @first || List::EMPTY
    end

    def rest
      @rest || List::EMPTY
    end

    def count
      @count || 0
    end

    def head
      first
    end

    def car
      first
    end

    def tail
      rest
    end

    def cdr
      rest
    end

    def eql?(other)
      self == other
    end

    def hash
      @first.hash + @second.hash + :fbl_list.hash
    end

    private

    def same?(list, other)
      return true if list == ListEmpty.instance && other == ListEmpty.instance
      list.first == other.first && same?(list.rest, other.rest)
    end
  end
end
