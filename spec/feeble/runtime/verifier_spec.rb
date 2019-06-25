module Feeble::Runtime
  RSpec.describe Verifier do
    subject(:verify) { described_class.new }

    describe "#list?" do
      it "returns true only for Lists" do
        expect(verify.list?(ListEmpty.instance)).to eq true
        expect(verify.list?(List.new(1))).to eq true
        expect(verify.list?(:omg)).to eq false
        expect(verify.list?(nil)).to eq false
      end
    end

    describe "#symbol?" do
      it "returns true only for Symbols" do
        expect(verify.symbol?(Symbol.new(:omg))).to eq true
        expect(verify.symbol?(:omg)).to eq false
        expect(verify.symbol?(nil)).to eq false
      end
    end

    describe "#keyword?" do
      it "returns true only for Keywords" do
        expect(verify.keyword?(Keyword.new("omg:"))).to eq true
        expect(verify.keyword?("omg:")).to eq false
        expect(verify.keyword?(:"omg:")).to eq false
        expect(verify.keyword?(:omg)).to eq false
        expect(verify.keyword?(nil)).to eq false
      end
    end
  end
end
