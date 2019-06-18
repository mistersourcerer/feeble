RSpec.describe Feeble::Runtime::Symbol do
  describe "#id" do
    it "symbolizes the id passed as a parameter" do
      expect(described_class.new("omg").id).to eq :omg
      expect(described_class.new(:lol).id).to eq :lol
      expect(described_class.new(1).id).to eq :"1"
    end
  end

  describe "#==" do
    it "consider symbols with the same id equal" do
      expect(described_class.new("omg")).to eq described_class.new "omg"
      expect(described_class.new(:lol)).to eq described_class.new :lol
    end
  end
end
