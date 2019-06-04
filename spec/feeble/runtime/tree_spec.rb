module Feeble::Runtime
  RSpec.describe Tree do

    subject(:tree) { described_class.new }

    let(:eql) { Object.new }
    let(:eqeq) { Object.new }
    let(:eqeqeq) { Object.new }
    let(:eqbang) { Object.new }
    let(:eqtilde) { Object.new }
    let(:stareq) { Object.new }

    before do
      tree.add "=", eql
      tree.add "==", eqeq
      tree.add "===", eqeqeq
      tree.add "=!", eqbang
      tree.add "=~", eqtilde
      tree.add "*=", stareq
    end

    describe "#search" do
      it "returns the object associated with a given pattern" do
        expect(tree.search("=")).to be eql
        expect(tree.search("==")).to be eqeq
        expect(tree.search("===")).to be eqeqeq
        expect(tree.search("=!")).to be eqbang
        expect(tree.search("=~")).to be eqtilde
        expect(tree.search("*=")).to be stareq

        expect(tree.search("*")).to be nil
      end
    end
  end
end
