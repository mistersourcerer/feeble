module Feeble::Runtime
  class ListFunctions
    def cons(a, list)
      list.cons(a)
    end

    def car(list)
      list.first
    end

    def cdr(list)
      list.rest
    end

    def empty?(list)
      list == nill
    end

    def take(n, list)
      return nill if empty?(list) || n == 0

      cons(
        car(list),
        take(n - 1, cdr(list)))
    end

    def nill
      ListEmpty.instance
    end
  end
end
