module Feeble::Runtime
  RSpec.describe Atom do
    it "recognizes equality based on value/id" do
      this = Atom.new("lol")
      that = Atom.new("lol")

      expect(this).to eq that
    end

    it "can be used as hash key" do
      hash = {
        Atom.new("lol") => 1,
        Atom.new("bbq") => 2
      }

      expect(hash[Atom.new("lol")]).to eq 1
      expect(hash[Atom.new("bbq")]).to eq 2
    end
  end
end
