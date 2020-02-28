RSpec.describe Feeble::Reader do
  subject(:reader) { described_class.new }

  describe "#next" do
    context "separators" do
      context "new lines" do
        it "regonizes new lines" do
          line, meta = reader.next "\n"

          expect(line).to eq "\n"
          expect(meta).to eq type: :new_line
        end
      end

      context "space" do
        it "recognizes spaces as separators" do
          space, meta = reader.next " "

          expect(space).to eq " "
          expect(meta).to eq type: :separator
        end
      end

      context "comma" do
        it "recognizes commas as separators" do
          comma, meta = reader.next ","

          expect(comma).to eq ","
          expect(meta).to eq type: :separator
        end
      end
    end

    context "delimited literals" do
      context "strings" do
        it "recognizes strings" do
          str, meta = reader.next "\"omg, lol! a string.\""

          expect(str).to eq "omg, lol! a string."
          expect(meta).to eq type: :string
          expect(meta.keys).to_not include(:open)
        end

        it "returns 'open' string if no closing delimiter is found" do
          str, meta = reader.next "\"omg, lol! a string."

          expect(str).to eq "omg, lol! a string."
          expect(meta).to eq type: :string, open: true
        end
      end

      context "comments" do
        it "recognizes comments" do
          comment, meta = reader.next ";\"a comment.\""

          expect(comment).to eq "\"a comment.\""
          expect(meta).to eq type: :comment
        end

        it "recognizes comments ended by new line" do
          comment, meta = reader.next ";some other comment\n"

          expect(comment).to eq "some other comment"
          expect(meta).to eq type: :comment
        end
      end

      context "vectors" do
        it "recongizes vectors" do
          vector, meta = reader.next "[\"str 1\"]"

          expect(vector).to eq Immutable::Vector[
            ["str 1", {type: :string}]
          ]
          expect(meta).to eq type: :vector
        end

        it "recongizes vectors ignoring separators" do
          vector, meta = reader.next "[\"str 1\" \"str 2\"  \"str 3\"\n\"str 4\"]"

          expect(vector).to eq Immutable::Vector[
            ["str 1", {type: :string}],
            [" ", {type: :separator}],
            ["str 2", {type: :string}],
            [" ", {type: :separator}],
            [" ", {type: :separator}],
            ["str 3", {type: :string}],
            ["\n", {type: :new_line}],
            ["str 4", {type: :string}],
          ]
          expect(meta).to eq type: :vector
        end
      end
    end
  end
end
