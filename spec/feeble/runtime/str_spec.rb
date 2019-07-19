module Feeble::Runtime
  RSpec.describe Str do
    let(:s) { ListFunctions.new }
    let(:body) { "this is going to be... feeble" }
    let(:str) { described_class }
    subject(:string) { str.create body }

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

    describe "#cons" do
      it "prepends a char" do
        new_str = str.create("ol").cons "l"

        expect(new_str).to eq str.create "lol"
        expect(new_str.count).to eq 3
      end

      it "returns a new str with just one element when cons(ing) to Empty String" do
        new_str = StrEmpty.instance.cons "M"

        expect(new_str).to eq str.create "M"
        expect(new_str.count).to eq 1
      end

      it "knows how to cons a str with a str" do
        # This behavior is "as expected", but it differs from a list consing...
        new_str = str.create("wzers").cons str.create("wo")

        expect(new_str).to eq str.create(str.create("wowzers"))
      end
    end

    describe "#take" do
      it "returns a printable version of the string" do
        expect(string.to_print).to eq "\"this  ...\""
      end
    end
  end
end
