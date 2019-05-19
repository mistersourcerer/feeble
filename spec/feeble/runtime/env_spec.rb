module Feeble::Runtime
  RSpec.describe Env do
    subject(:env) { described_class.new }

    context "#register and #lookup" do
      it "associates a key with an object" do
        env.register Symbol.new(:omg), "lol"
        expect(env.lookup(Symbol.new(:omg))).to eq "lol"
      end
    end

    describe "#lookup" do
      it "fetches the value associated with a symbol" do
        env.register Symbol.new(1), "omg"
        expect(env.lookup(Symbol.new(1))).to eq "omg"
      end
    end
  end
end
