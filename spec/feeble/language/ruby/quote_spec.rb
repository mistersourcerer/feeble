module Feeble::Language::Ruby
  include Feeble::Runtime
  RSpec.describe Quote do
    subject(:quoter) { described_class.new }

    it "when receives a list, return it as it is" do
      list = List.create(Symbol.new("a"), Symbol.new("b"))
      result = quoter.invoke list

      expect(result).to eq List.create(Symbol.new("a"), Symbol.new("b"))
    end
  end
end
