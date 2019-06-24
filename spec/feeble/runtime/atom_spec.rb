module Feeble::Runtime
  RSpec.describe Keyword do
    it "recognizes equality based on value/id" do
      this = Keyword.new("lol")
      that = Keyword.new("lol")

      expect(this).to eq that
    end

    it "can be used as hash key" do
      hash = {
        Keyword.new("lol") => 1,
        Keyword.new("bbq") => 2
      }

      expect(hash[Keyword.new("lol")]).to eq 1
      expect(hash[Keyword.new("bbq")]).to eq 2
    end
  end
end
