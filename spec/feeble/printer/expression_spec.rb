module Feeble::Printer
  RSpec.describe Expression do
    subject(:printer) { described_class.new }

    describe "#to_print" do
      context "Strings" do
        it "returns formatted string" do
          expect(printer.to_print "lol").to eq "\"lol\""
        end
      end

      context "Numbers" do
        it "returns formatted int" do
          expect(printer.to_print 1).to eq "1"
        end

        it "returns formatted float" do
          expect(printer.to_print 1.2).to eq "1.2"
        end
      end
    end
  end
end
