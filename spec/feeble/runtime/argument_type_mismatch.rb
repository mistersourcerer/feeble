module Feeble::Runtime
  class ArgumentTypeMismatch < StandardError
    def initialize(given_type, expected_type)
      super "< #{expected_type.class} > received while expecting < #{expected_type} >"
    end
  end
end
