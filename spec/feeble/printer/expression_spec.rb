require "stringio"

module Feeble::Printer
  include Feeble::Runtime

  RSpec.describe Expression do
    subject(:printer) { described_class.new }

    describe "#print" do
      it "prints to a specific output stream" do
        output = StringIO.new
        printer.print(Keyword.new("a:"), to: output)

        expect(output.string).to eq " > a:"
      end

      it "uses stdout by default" do
        expect {
          printer.print(Keyword.new("a:"))
        }.to output(" > a:").to_stdout
      end
    end
  end
end
