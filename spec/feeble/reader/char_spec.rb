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

    describe "#start" do
      it "moves cursor to the first char" do
        expect(reader.current).to eq nil

        expect(reader.start).to eq "o"
        expect(reader.current).to eq "o"
      end

      it "doesn't move the cursor if reading is already started" do
        expect(reader.start).to eq "o"
        expect(reader.start).to eq "o"
        expect(reader.current).to eq "o"
      end
    end

    describe "#until_next" do
      subject(:reader) { described_class.new('"omg lol bbq"nice') }

      before { reader.start }

      it "consumes the IO until find the parameter char" do
        reader.next

        expect(reader.until_next('"')).to eq "omg lol bbq"
        expect(reader.current).to eq '"'
      end

      it "raises if char is not found" do
        expect {
          reader.until_next ")"
        }.to raise_error "Expected ) but nothing was found"
      end

      it "accepts a condition to 'stop'" do
        reader = described_class.new("omg lol:bbq")
        string = reader.until_next("omg lol:bbq") { |char| char == ":" }

        expect(string).to eq "omg lol"
      end

      it "accepts a flag for 'or pattern or eof?'" do
        reader = described_class.new("omg lol")
        string = reader.until_next("|", or_eof: true)

        expect(string).to eq "omg lol"
      end
    end

    describe "#prev" do
      it "returns the previous char before the current one" do
        reader.next
        reader.next

        expect(reader.prev).to eq "o"
      end

      it "returns nil if first char" do
        reader.next

        expect(reader.prev).to eq nil
      end

      it "returns nil if not started" do
        expect(reader.prev).to eq nil
      end

      it "returns last char if eof?" do
        reader.until_next("q")
        reader.next

        expect(reader.prev).to eq "q"
      end
    end
  end
end
