module Feeble::Runtime
  class Verifier
    def list?(obj)
      obj.is_a?(List) || obj.is_a?(ListEmpty)
    end

    def symbol?(obj)
      obj.is_a? Feeble::Runtime::Symbol
    end

    def keyword?(obj)
      obj.is_a? Keyword
    end

    def fn?(obj)
      obj.is_a? Invokable
    end
  end
end
