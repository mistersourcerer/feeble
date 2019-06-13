module Feeble::Reader
  include ::Feeble::Runtime

  RSpec.describe Code do
    subject(:reader) { described_class.new }

    def eval_list(*values)
      List.create(Symbol.new("eval"), *values)
    end

    describe ".read" do
      context "Numbers" do
        it "recognizes integers" do
          expect(reader.read("123")).to eq 123
          expect(reader.read("123_555")).to eq 123555
          expect(reader.read("123_555_2")).to eq 1235552
        end

        it "recognizes floats" do
          expect(reader.read("123.2")).to eq 123.2
          expect(reader.read("123_555.2")).to eq 123555.2
          expect(reader.read("123_555_2.2")).to eq 1235552.2
        end
      end

      context "Strings" do
        it "recognizes strings" do
          expect(reader.read("\"lol\"")).to eq "lol"
        end
      end

      context "Symbols" do
        it "recognizes symbols" do
          expect(reader.read("omg")).to eq Symbol.new("omg")
        end
      end

      context "Arrays" do
        it "recognizes array declarations" do
          expect(reader.read("[1]")).to eq List.create(Symbol.new("%arr"), 1)
        end

        it "recognizes multiple values comma separated" do
          expect(reader.read("[1, 2, 3, 4]")).to eq List.create(Symbol.new("%arr"), 1, 2, 3, 4)
        end

        it "recognizes multiple values space separated" do
          expect(reader.read("[1 2 3 4]")).to eq List.create(Symbol.new("%arr"), 1, 2, 3, 4)
        end
      end

      context "Interop with square function" do
        it "reads :: expressions as a direct Ruby (host) code invocation" do
          code = "::puts(1)"

          expect(reader.read(code)).to eq List.create(
            Symbol.new("%host"),
            Symbol.new("."),
            Symbol.new("Kernel"),
            Symbol.new("puts"),
            1
          )
        end

        it "Translate" do
          code = '::"omg".upcase()'

          expect(reader.read(code)).to eq List.create(
            Symbol.new("%host"),
            Symbol.new("."),
            "omg",
            Symbol.new("upcase")
          )
        end
      end
    end
  end
end
