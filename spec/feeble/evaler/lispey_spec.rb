module Feeble::Evaler
  include ::Feeble::Runtime

  RSpec.describe Lispey do
    subject(:evaler) { described_class.new }

    context "quoting" do
      it "knows how to apply the 'quote' function" do
        list = List.create(Symbol.new("a"))
        quote = list.cons Symbol.new("quote")

        expect(evaler.eval quote).to eq list
      end
    end
  end
end
