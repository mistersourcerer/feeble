module Feeble::Runtime
  class Verifier
    def list?(obj)
      obj.is_a?(Feeble::Runtime::List) ||
        obj.is_a?(Feeble::Runtime::ListEmpty)
    end
  end
end
