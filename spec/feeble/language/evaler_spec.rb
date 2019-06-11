module Feeble::Language
  include Feeble::Runtime

  RSpec.describe Evaler do
    subject(:evaler) { described_class.new }

    it "evaluates a List function call on the standard (Fbl) env" do
      call = List.create(Symbol.new("::"), Symbol.new("print"), "lol")

      expect {
        expect(evaler.invoke(call)).to eq nil
      }.to output("lol").to_stdout
    end
  end
end
