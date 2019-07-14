module Feeble::Language::Ruby
  RSpec.describe Print do
    subject(:printer) { described_class.new }

    describe "one argument" do
      it "send the argument as it is to stdout" do
        expect {
          printer.invoke "omg"
        }.to output("omg").to_stdout
      end
    end
  end
end
