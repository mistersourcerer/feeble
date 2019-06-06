module Feeble::Reader
  include ::Feeble::Runtime

  RSpec.describe Code do
    subject(:reader) { described_class.new }

    describe ".read" do
      context "Numbers" do
        it "recognizes integers" do
          expect(reader.read("123")).to eq [123]
          expect(reader.read("123_555")).to eq [123555]
          expect(reader.read("123_555_2")).to eq [1235552]
        end

        it "recognizes floats" do
          expect(reader.read("123.2")).to eq [123.2]
          expect(reader.read("123_555.2")).to eq [123555.2]
          expect(reader.read("123_555_2.2")).to eq [1235552.2]
        end
      end

      context "Interop with square function" do
        it "reads :: expressions as a direct Ruby (host) code invocation" do
          code = "::puts(1)"

          expect(reader.read(code)).to eq [
            List.create(
              Symbol.new("%host"),
              Symbol.new("."),
              Symbol.new("Kernel"),
              Symbol.new("puts"),
              1
            )
          ]
        end

        it "Translate" do
          pending
          code = '::"omg".upcase()'

          expect(reader.read(code)).to eq [
            List.create(
              Symbol.new("%host"),
              Symbol.new("."),
              "omg",
              Symbol.new("upcase")
            )
          ]
        end
      end
    end
  end
end
