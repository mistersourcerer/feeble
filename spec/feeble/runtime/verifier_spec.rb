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
  end
end
