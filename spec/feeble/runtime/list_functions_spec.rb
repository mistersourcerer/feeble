module Feeble::Runtime
  RSpec.describe ListFunctions do
    subject(:fn) { described_class.new }

    context "The building blocks" do
      let(:list) { List.create 1, 2, 3, 4, 5 }

      describe "#cons" do
        it "consing a element to a list" do
          expect(fn.cons(0, list)).to eq List.create(0, 1, 2, 3, 4, 5)
        end
      end

      describe "#car" do
        it "returns the head of the list" do
          expect(fn.car(list)).to eq 1
        end
      end

      describe "#cdr" do
        it "returns the tail of the list" do
          expect(fn.cdr(list)).to eq List.create(2, 3, 4, 5)
        end
      end

      describe "#nill" do
        it "returns a nil(l)ist" do
          expect(fn.nill).to eq ListEmpty.instance
        end
      end
    end

    describe "#empty?" do
      it "returns true for an empty list" do
        expect(fn.empty?(List.new(1).rest)).to eq true
        expect(fn.empty?(ListEmpty.instance)).to eq true
      end

      it "returns false for a list with one or more elements" do
        expect(fn.empty?(List.new(1))).to eq false
      end
    end

    describe "#take" do
      it "returns a new listw with the first N elements of a list" do
        list = List.create 1, 2, 3, 4, 5
        expect(fn.take(3, list)).to eq List.create(1, 2, 3)
      end

      it "returns the whole list if N > list.count" do
        list = List.create 1, 2, 3, 4, 5
        expect(fn.take(30, list)).to eq List.create(1, 2, 3, 4, 5)
      end
    end
  end
end
