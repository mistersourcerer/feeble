module Feeble::Language::Ruby
  RSpec.describe Define do

    subject(:definer) { described_class.new }

    describe "#invoke" do
      context "when receiving and env and an array with two elements" do
        it "treats the 2nd and 3rd params as symbo and value and register it on env" do
          env = Feeble::Runtime::Env.new
          definer.invoke(env, [Feeble::Runtime::Symbol.new(:lol), 123])

          expect(env.lookup(Feeble::Runtime::Symbol.new(:lol))).to eq 123
        end
      end
    end
  end
end
