RSpec.describe Feeble::Reader do
  subject(:reader) { described_class.new }

  describe "#next" do
    context "separators" do
      context "new lines" do
        it "regonizes new lines" do
          token = reader.next "\n"

          expect(token).to be_a_token :new_line, "\n"
        end
      end

      context "space" do
        it "recognizes spaces as separators" do
          token = reader.next " "

          expect(token).to be_a_token :separator, " "
        end
      end

      context "comma" do
        it "recognizes commas as separators" do
          token = reader.next ","

          expect(token).to be_a_token :separator, ","
        end
      end
    end
  end
end
