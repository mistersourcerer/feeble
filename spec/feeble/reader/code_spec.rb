module Feeble::Reader
  include ::Feeble::Runtime

  RSpec.describe Code do
    subject(:reader) { described_class.new }

    context "quoting" do
      it "reads ' syntax into a (quote ...) invokation" do
        expect(reader.read "'(a)").to eq [
          List.create(
            Symbol.new("quote"), List.create(Symbol.new("a")))
        ]
      end
    end
  end
end
