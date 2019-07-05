module Feeble::Runtime
  module ListProperties
    def first
      @first
    end

    def rest
      return ListEmpty.instance if @rest.nil?
      @rest
    end

    def count
      return 0 if @count.nil?
      @count
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
