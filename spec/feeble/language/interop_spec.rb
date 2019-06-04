module Feeble::Language
  include Feeble::Runtime

  RSpec.describe Interop do
    subject(:interop) { described_class.new }

    it "#is? :special" do
      expect(interop.is? :special).to eq true
    end

    describe "invoke(List)" do
      it "transforms the param list on a Fbl::HOST invokation" do
        host_invokation = interop.invoke([
          "omg", Symbol.new("."), Symbol.new("upcase()")])

        expect(host_invokation).to eq List.create(
          Fbl::HOST, Symbol.new("."), "omg", Symbol.new("upcase"))
      end

      it "recognizes 'non-dot' invokation as Kernel#... invokations" do
        host_invokation = interop.invoke [Symbol.new("print"), "1"]

        expect(host_invokation).to eq List.create(
          Fbl::HOST,
          Symbol.new("."),
          Symbol.new("Kernel"),
          Symbol.new("print"),
          "1"
        )
      end
    end
  end
end
