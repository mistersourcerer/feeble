RSpec.describe Feeble::PushbackReader do
  let(:content) { StringIO.new("OMG lol BBQ, so much chars!\nSome more chars.") }
  subject(:reader) { described_class.new content }

  describe "#next" do
    it "reads the next char from io" do
      expect(reader.next).to eq "O"
      expect(reader.next).to eq "M"
      expect(reader.next).to eq "G"
    end
  end

  describe "#push" do
    it "pushes a string 'back' to the reader" do
      reader.next
      reader.next
      reader.next

      reader.push "Zing!"

      expect(reader.next).to eq "Z"
      expect(reader.next).to eq "i"
      expect(reader.next).to eq "n"
      expect(reader.next).to eq "g"
      expect(reader.next).to eq "!"

      expect(reader.next).to eq " "
      expect(reader.next).to eq "l"
      expect(reader.next).to eq "o"
      expect(reader.next).to eq "l"
    end
  end
end
