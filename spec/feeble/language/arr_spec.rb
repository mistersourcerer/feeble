module Feeble::Language
  RSpec.describe Arr do
    subject(:arr) { described_class.new }

    it "returns an array with all the parameters" do
      expect(arr.invoke 1, 2, 3, "4").to eq [1, 2, 3, "4"]
    end

    it "returns an empty array if no params are passed" do
      expect(arr.invoke).to eq []
    end
  end
end
