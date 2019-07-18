module Feeble::Runtime
  RSpec.describe Str do
    let(:s) { ListFunctions.new }
    let(:body) { "this is going to be... feeble" }
    subject(:string) { described_class.create body }

    context "behaves like a list" do
      describe "#car" do
        it "returns the first char" do
          expect(string.car).to eq "t"
          expect(string.first).to eq "t"
        end
      end

      describe "#rest" do
        it "returns the remaining of the string" do
          expect(string.cdr).to eq described_class.create(body[1..-1])
          expect(string.rest).to eq described_class.create(body[1..-1])
        end

        it "returns StrEmpty if there is no more chars" do
          expect(described_class.create("").rest).to eq StrEmpty.instance
        end
      end
    end

    describe "#to_print" do
      it "returns a printable version of the string" do
        expect(string.to_print).to eq "this ..."
      end
    end
  end
end
