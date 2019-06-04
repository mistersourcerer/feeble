module Feeble::Evaler
  include ::Feeble::Runtime

  RSpec.describe Lispey do
    subject(:evaler) { described_class.new }

    describe "#eval" do
      it "interprets a list as an invocation" do
        sum = List.create Symbol.new("+"), 1, 2

        expect(evaler.eval(sum)).to eq 3
      end
    end

    context "interop" do
      describe "::" do
        it "translates 'square' invokation into host invokation" do
          # ::print(1)

          host_invokation = List.create(
            Symbol.new("::"),
            Symbol.new("print"),
            1
          )

          expect {
            expect(evaler.eval(host_invokation)).to eq nil
          }.to output("1").to_stdout
        end
      end

      it "invokes method in the Kernel scope" do
        # ::print(1)

        puts_invokation = List.create(
          Symbol.new("%host"),
          Symbol.new("."),
          Symbol.new("Kernel"),
          Symbol.new("print"),
          1)

        # should return nil and print to stdout
        expect {
          expect(evaler.eval(puts_invokation)).to eq nil
        }.to output("1").to_stdout
      end

      it "invokes method on object from host" do
        # ::"lol".upcase()

        invokation = List.create(
          Symbol.new("%host"),
          Symbol.new("."),
          "lol",
          Symbol.new("upcase"))

        expect(evaler.eval(invokation)).to eq "LOL"
      end
    end
  end
end
