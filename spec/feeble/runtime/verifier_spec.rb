module Feeble::Runtime
  RSpec.describe Verifier do
    class Fn
      include Invokable
    end

    subject(:verify) { described_class.new }

    describe "#symbol?" do
      it "returns true only for Symbols" do
        expect(verify.symbol?(Symbol.new(:omg))).to eq true
        expect(verify.symbol?(:omg)).to eq false
        expect(verify.symbol?(nil)).to eq false
      end
    end

    describe "#env?" do
      it "returns true only for Envs" do
        expect(verify.env?(Env.new)).to eq true
        expect(verify.env?(:omg)).to eq false
        expect(verify.env?(nil)).to eq false
      end
    end

    describe "#list?" do
      it "returns true only for Envs" do
        expect(verify.list?(List::EmptyList.new)).to eq true
        expect(verify.list?(List.new(1))).to eq true
        expect(verify.list?(:omg)).to eq false
        expect(verify.list?(nil)).to eq false
      end
    end

    describe "#fn?" do
      it "returns true only for Functions" do
        expect(verify.fn?(Fn.new)).to eq true
        expect(verify.fn?(:omg)).to eq false
        expect(verify.fn?(nil)).to eq false
      end
    end
  end
end
