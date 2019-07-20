module Feeble::Reader
  RSpec.describe Number do
    let(:str) { Feeble::Runtime::Str }
    let(:empty) { Feeble::Runtime::StrEmpty.instance }
    subject(:reader) { described_class.new }

    context "recognizing numbers" do
      it "recognizes integers" do
        expect(reader.invoke str.create("1")).to eq [1, empty]
        expect(reader.invoke str.create("1_001")).to eq [1001, empty]
        expect(reader.invoke str.create("-1")).to eq [-1, empty]
        expect(reader.invoke str.create("-100_1")).to eq [-1001, empty]
      end

      it "recognizes floats" do
        expect(reader.invoke str.create("4.2")).to eq [4.2, empty]
        expect(reader.invoke str.create("4_200.1")).to eq [4200.1, empty]
        expect(reader.invoke str.create("-4.2")).to eq [-4.2, empty]
        expect(reader.invoke str.create("-4_200.1")).to eq [-4200.1, empty]
      end
    end

    context "when there are more things in the source code" do
      it "returns the number found and 'stops'" do
        code = str.create("1_2.1 something else")
        rest = str.create(" something else")

        expect(reader.invoke(code)).to eq [12.1, rest]
      end

      it "returns nil if first thing isn't a number and 'stops'" do
        code = str.create("not a number")

        expect(reader.invoke(code)).to eq [nil, code]
      end
    end
  end
end
