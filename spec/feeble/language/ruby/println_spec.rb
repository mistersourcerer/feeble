module Feeble::Language::Ruby
  RSpec.describe Println do
    subject(:printer) { described_class.new }

    describe "one argument" do
      it "send the argument as it is to stdout" do
        expect {
          printer.invoke "omg"
        }.to output("omg\n").to_stdout
      end
    end
  end
end
