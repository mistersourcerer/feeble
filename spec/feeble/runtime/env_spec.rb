module Feeble::Runtime
  RSpec.describe Env do
    subject(:env) { described_class.new }

    context "#register and #lookup" do
      it "associates a key with an object" do
        env.register Symbol.new(:omg), "lol"

        expect(env.lookup(Symbol.new(:omg))).to eq "lol"
      end

      it "registers functions on a specific 'area'" do
        fn = Feeble::Language::Ruby::Print.new
        env.register Symbol.new(:fn), fn

        expect(env.lookup(Symbol.new(:fn))).to eq fn
        expect(env.fn(:fn)).to eq fn
        expect(env.fn("fn")).to eq fn
        expect(env.fn(Symbol.new(:fn))).to eq fn
      end
    end

    describe "#lookup" do
      it "fetches the value associated with a symbol" do
        env.register Symbol.new(1), "omg"

        expect(env.lookup(Symbol.new(1))).to eq "omg"
      end

      it "fallbacks to the 'around' environment if symbol not found" do
        env.register Symbol.new("lol"), "bbq"
        inner = Env.new env

        expect(inner.lookup(Symbol.new("lol"))).to eq "bbq"
      end
    end

    describe "#fn" do
      it "returns nil if no function with the given name is registered" do
        expect(env.fn(:nope)).to eq nil
      end
    end
  end
end
