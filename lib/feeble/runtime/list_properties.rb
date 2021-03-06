module Feeble::Runtime
  module ListProperties
    def first
      @first
    end

    def rest
      return nill if @rest.nil?
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

    def apnd(*args)
      args.reduce(self) { |list, obj|
        self.class.new list.first, list.rest.apnd(obj), count: list.count + 1
      }
    end

    def conj(*args)
      args.reduce(self) { |list, obj|
        self.class.new obj, list, count: list.count + 1
      }
    end

    def empty?
      nill == self
    end

    def ==(other)
      return false if self.class != other.class
      same? self, other
    end

    def eql?(other)
      self == other
    end

    def hash
      @first.hash + @second.hash + :fbl_list.hash
    end

    def nill
      @nill || ListEmpty.instance
    end
  end
end
