module Feeble::Runtime
  class Verifier
    def symbol?(obj)
      obj.is_a? Feeble::Runtime::Symbol
    end

    def env?(obj)
      obj.is_a? Feeble::Runtime::Env
    end

    def list?(obj)
      obj.is_a?(Feeble::Runtime::List) ||
        obj.is_a?(Feeble::Runtime::List::EmptyList)
    end

    def fn?(obj)
      obj.is_a?(Feeble::Runtime::Invokable)
    end

    def string?(obj)
      obj.is_a?(String)
    end

    def int?(obj)
      obj.is_a?(Integer)
    end

    def float?(obj)
      obj.is_a?(Float)
    end
  end
end
