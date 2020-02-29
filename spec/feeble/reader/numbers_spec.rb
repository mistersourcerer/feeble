RSpec.describe Feeble::Reader do
  subject(:reader) { described_class.new }

  describe "#next" do
    it "recognizes integers" do
      expect(reader.next "1").to be_a_token :int, 1
      expect(reader.next "2").to be_a_token :int, 2
    end

    it "recognizes integers ignoring _ in the middle" do
      expect(reader.next "1_2").to be_a_token :int, 12
      expect(reader.next "0_2").to be_a_token :int, 2
    end

    it "recognizes negative integers" do
      expect(reader.next "-1").to be_a_token :int, -1
      expect(reader.next "-12").to be_a_token :int, -12
      expect(reader.next "-4_2").to be_a_token :int, -42
    end

    it "recognizes float numbers" do
      expect(reader.next "1.2").to be_a_token :float, 1.2
      expect(reader.next "0.2").to be_a_token :float, 0.2
      expect(reader.next "0.4_2").to be_a_token :float, 0.42
      expect(reader.next "-4.2").to be_a_token :float, -4.2
      expect(reader.next "-1.6_9").to be_a_token :float, -1.69
    end

    it "raises if the number is not delimited by a separator" do
      msg = "Numbers should end in a separator (like ' ' or ',').\n"

      expect { reader.next "1a" }.to raise_error msg + "Invalid number: 1a"
      expect { reader.next "4.2a" }.to raise_error msg + "Invalid number: 4.2a"
      expect { reader.next "-1a" }.to raise_error msg + "Invalid number: -1a"
      expect { reader.next "-4.2a" }.to raise_error msg + "Invalid number: -4.2a"
    end
  end
end
