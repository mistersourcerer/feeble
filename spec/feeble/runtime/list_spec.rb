module Feeble::Runtime
  RSpec.describe List do
    subject(:list) { described_class }

    context "constructor function" do
      it "creates a list with one element" do
        new_list = list.create 1

        expect(new_list).to eq list.new 1
        expect(new_list.count).to eq 1
      end

      it "creates a list with two elements" do
        new_list = list.create 1, 2

        expect(new_list).to eq list.new 1, list.new(2)
        expect(new_list.count).to eq 2
      end

      it "creates a list with three elements" do
        new_list = list.create 1, 2, 3

        expect(new_list).to eq list.new 1, list.new(2, list.new(3))
        expect(new_list.count).to eq 3
      end
    end

    describe "#rest" do
      it "returns a list with all but the first element" do
        new_list = list.create 1, 2, 3, 4

        expect(new_list.rest).to eq list.create 2, 3, 4
      end

      it "returns an empty list if just one element exists" do
        new_list = list.create 1

        expect(new_list.rest).to eq ListEmpty.instance
      end
    end

    describe "#cons" do
      it "prepends an object" do
        new_list = list.create(2, 3).cons 1

        expect(new_list).to eq list.create 1, 2, 3
        expect(new_list.count).to eq 3
      end

      it "returns a new_list with just one element when cons(ing) to Empty List" do
        new_list = ListEmpty.instance.cons 1

        expect(new_list).to eq list.new 1
        expect(new_list.count).to eq 1
      end
    end

    describe "#conj" do
      it "prepends arguments to the new_list" do
        new_list = list.create(1, 2, 3, 4).conj 5, 6, 7

        expect(new_list).to eq list.create 7, 6, 5, 1, 2, 3, 4
        expect(new_list.count).to eq 7
      end

      it "returns a new_list of one when conj(ing) empty new_list" do
        new_list = ListEmpty.instance.conj 1

        expect(new_list).to eq list.new 1
        expect(new_list.count).to eq 1
      end
    end

    describe "#apnd" do
      it "append arguments to the new_list" do
        new_list = list.create(1, 2).apnd 3, 4, 5

        expect(new_list).to eq list.create 1, 2, 3, 4, 5
        expect(new_list.count).to eq 5
      end
    end
  end
end
