module Feeble::Evaler
  include ::Feeble::Runtime

  RSpec.describe Lispey do
    subject(:evaler) { described_class.new }

    context "quoting" do
      it "knows how to apply the 'quote' function" do
        expression = List.create(Symbol.new("quote"), Symbol.new("a"))

        expect(evaler.eval(expression)).to eq Symbol.new("a")
      end

      it "knows how to apply the 'quote' function to a List" do
        expression = List.create(Symbol.new("quote"), List.create(Symbol.new("a")))

        expect(evaler.eval(expression)).to eq List.create(Symbol.new("a"))
      end
    end
  end
end
