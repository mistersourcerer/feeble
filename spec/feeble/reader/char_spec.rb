module Feeble::Reader
  RSpec.describe Char do
    let(:string_to_read) { "omg lol bbq" }
    subject(:reader) { described_class.new string_to_read }

    describe "#next" do
      it "'consumes' a character" do
        expect(reader.next).to eq "o"
        expect(reader.next).to eq "m"
      end

      it "returns nil when there is no more characters left" do
        string_to_read.split("").each { |_| reader.next }

        expect(reader.next).to eq nil
      end
    end

    describe "#eof?" do
      it "returns false if there are still chars to consume" do
        reader.next

        expect(reader.eof?).to eq false
      end

      it "returns true if everything was consumed" do
        string_to_read.split("").each { |_| reader.next }

        expect(reader.eof?).to eq true
      end

      it "doesn't each anything while checking" do
        reader.next # start consuming, first is "o"
        reader.eof?

        expect(reader.current).to eq "o"

        reader.eof?

        expect(reader.current).to eq "o"
      end
    end

    describe "#current" do
      it "knows the current char" do
        reader.next # "o"
        reader.next # "m"

        expect(reader.current).to eq "m"
      end

      it "returns nil if not started" do
        expect(reader.current).to eq nil

        reader.next

        expect(reader.current).to eq "o"
      end

      it "returns nil if eof" do
        string_to_read.split("").each { |_| reader.next }
        reader.next

        expect(reader.current).to eq nil
      end
    end

    describe "#peek" do
      it "allows look the next char without eating it" do
        expect(reader.peek).to eq "o"

        reader.next

        expect(reader.peek).to eq "m"
      end
    end

    describe "#until_next" do
      subject(:reader) { described_class.new('"omg lol bbq"nice') }

      before { reader.next }

      it "consumes the IO until find the parameter char" do
        expect(reader.until_next('"')).to eq "omg lol bbq"
        expect(reader.current).to eq '"'
      end

      it "raise if char is not found" do
        expect {
          reader.until_next ")"
        }.to raise_error "Expected ) but none was found"
      end
    end
  end
end
