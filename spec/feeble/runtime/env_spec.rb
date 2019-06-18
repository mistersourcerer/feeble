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

    context "when behaving as a function" do
      describe "symbol parameter" do
        it "resolves the value associated with it" do
          env.register Symbol.new(:omg), "lol"

          expect(env.invoke(Symbol.new(:omg))).to eq "lol"
        end
      end
    end

    context "knows how to search for registered functions" do
      describe "#fn_lookup" do
        class Fn
          include Feeble::Runtime::Invokable
        end

        let(:fn) { Fn.new }

        it "returns the associated function based on the Symbol" do
          env.register Symbol.new(:fn), fn

          expect(env.fn_lookup(Symbol.new(:fn))).to eq fn
        end

        it "returns nil if the associated value is not a function" do
          env.register Symbol.new(:fake), "something"

          expect(env.fn_lookup(Symbol.new(:fake))).to eq nil
        end

        it "returns nil if the Symbol is not associated" do
          expect(env.fn_lookup(Symbol.new(:nada))).to eq nil
        end
      end
    end
  end
end
