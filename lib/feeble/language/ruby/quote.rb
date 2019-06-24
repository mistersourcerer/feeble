module Feeble::Language::Ruby
  class Quote
    def invoke(_, params)
      params.first
    end
  end
end
