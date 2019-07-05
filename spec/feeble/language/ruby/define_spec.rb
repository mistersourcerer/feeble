module Feeble::Language::Ruby
  RSpec.describe Define do

    subject(:definer) { described_class.new }

    describe "#invoke" do
      context "when receiving and env and an array with two elements" do
        it "treats the 2nd and 3rd params as symbol and value and register it on env" do
          external_env = Feeble::Runtime::Env.new
          fn_env = Feeble::Runtime::Env.new
          fn_env.register Symbol.new("%xenv"), external_env
          definer.invoke(Feeble::Runtime::Symbol.new(:lol), 123, scope: fn_env)

          expect(external_env.lookup(Feeble::Runtime::Symbol.new(:lol))).to eq 123
        end
      end
    end
  end
end
