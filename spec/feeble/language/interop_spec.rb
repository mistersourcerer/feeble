module Feeble::Language
  include Feeble::Runtime

  RSpec.describe Interop do
    subject(:interop) { described_class.new }

    it "#is? :special" do
      expect(interop.is? :special).to eq true
    end

    describe "invokde(reader, evaler)" do
      it "sends the parameters for a (dot) method invokation" do
        reader = Feeble::Reader::Char.new('"lol bbq".chomp(" bbq")')
        host_invokation = interop.invoke(reader, Feeble::Evaler::Lispey.new)

        expect(host_invokation).to eq List.create(
          Fbl::HOST,
          Symbol.new("."),
          "lol bbq",
          Symbol.new("chomp"),
          " bbq"
        )
      end
    end

    describe "invoke(List)" do
      context "dot invokations" do
        it "transforms the param list on a Fbl::HOST invokation" do
          host_invokation = interop.invoke([
            "omg", Symbol.new("."), Symbol.new("upcase")])

          expect(host_invokation).to eq List.create(
            Fbl::HOST, Symbol.new("."), "omg", Symbol.new("upcase"))
        end
      end

      it "recognizes 'non-dot' invokation as Kernel#... invokations" do
        host_invokation = interop.invoke [
          Symbol.new("print"),
          List.create(Symbol.new("%arr"), "1")
        ]

        expect(host_invokation).to eq List.create(
          Fbl::HOST,
          Symbol.new("."),
          Symbol.new("Kernel"),
          Symbol.new("print"),
          "1"
        )

        host_invokation = interop.invoke [
          Symbol.new("print"),
          List.create(Symbol.new("%arr"), 1)
        ]

        expect(host_invokation).to eq List.create(
          Fbl::HOST,
          Symbol.new("."),
          Symbol.new("Kernel"),
          Symbol.new("print"),
          1
        )
      end
    end
  end
end
