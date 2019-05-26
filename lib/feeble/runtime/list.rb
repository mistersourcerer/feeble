module Feeble::Runtime
  class List
    include Enumerable

    class EmptyList
      def first
        List::EMPTY
      end

      def rest
        List::EMPTY
      end

      def cons(obj)
        List.create obj
      end

      def conj(obj)
        cons obj
      end

      def apnd(obj)
        cons obj
      end

      def count
        0
      end
    end

    EMPTY = EmptyList.new

    attr_reader :first, :rest, :count

    def self.create(*args)
      return EMPTY if args.length == 0
      new args[0], create(*args[1..args.length]), count: args.length
    end

    def initialize(obj, rest = EMPTY, count: 1)
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

    def each(&block)
      if block_given?
        block.call first
        rest.each(&block) if rest != EMPTY
      else
        to_enum(:each)
      end
    end

    def ==(other)
      return false if self.class != other.class
      first == other.first && rest == other.rest
    end

    def eql?(other)
      self == other
    end

    def hash
      @first.hash + @second.hash + :fbl_list.hash
    end
  end
end
