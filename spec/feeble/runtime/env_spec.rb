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

      context "scoping environments" do
        it "searches for values in the 'internal' environments first" do
          env.register Symbol.new(:override), "omg"
          internal = described_class.new.tap { |e|
            e.register Symbol.new(:override), "lol"
          }
          new_env = env.wrap internal

          expect(new_env.lookup(Symbol.new(:override))).to eq "lol"
        end
      end
    end

    end
  end
end
