module Feeble::Evaler
  include ::Feeble::Runtime

  RSpec.describe Lispey do
    subject(:evaler) { described_class.new }

    context "interop" do
      it "invokes method in the Kernel scope" do
        pending
        puts_invokation = List.create(
          Symbol.new("%host"), Symbol.new("puts"), 1)

        # should return nil and puts to stdout
        expect {
          expect(evaler.eval(puts_invokation)).to eq nil
        }.to output("1").to_stdout
      end

      [
        :"%host",
        [:"."]
      ]

      it "invokes method on object from host" do
        # ::"lol".upcase

        invokation = List.create(
          Symbol.new("%host"),
          Symbol.new("."),
          "lol",
          Symbol.new("upcase"))

        expect(evaler.eval(invokation)).to eq "LOL"
      end
    end

    describe "#eval" do
      it "interprets a list as an invocation" do
        pending
        sum = List.create Symbol.new("+"), 1, 2

        expect(evaler.eval(sum)).to eq 3
      end
    end
  end
end
