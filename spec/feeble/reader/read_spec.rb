module Feeble::Reader
  RSpec.describe Read do
    subject(:reader) { described_class.new }

    it "reads symbols into a list of forms" do
      expect(reader.invoke("omg lol bbq")).to eq [
        Feeble::Runtime::Symbol.new("omg"),
        Feeble::Runtime::Symbol.new("lol"),
        Feeble::Runtime::Symbol.new("bbq"),
      ]
    end

    it "reads numbers into... numbers" do
      expect(reader.invoke("omg 1_2.1 -4 420 lol")).to eq [
        Feeble::Runtime::Symbol.new("omg"),
        12.1,
        -4,
        420,
        Feeble::Runtime::Symbol.new("lol"),
      ]
    end
  end
end
