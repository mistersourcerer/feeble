RSpec.describe Feeble::Reader do
  subject(:reader) { described_class.new }

  describe "#next" do
    context "delimited literals" do
      context "strings" do
        it "recognizes strings" do
          token = reader.next "\"omg, lol! a string.\""

          expect(token).to be_a_token(:string, "omg, lol! a string.")
          expect(token[1].keys).to_not include :open
        end

        it "returns 'open' string if no closing delimiter is found" do
          token = reader.next "\"omg, lol! a string."

          expect(token).to be_a_token(
            :string,
            "omg, lol! a string.",
            {open: true}
          )
        end
      end

      context "comments" do
        it "recognizes comments" do
          token = reader.next ";\"a comment.\""

          expect(token).to be_a_token :comment, "\"a comment.\""
        end

        it "recognizes comments ended by new line" do
          token = reader.next ";some other comment\n"

          expect(token).to be_a_token :comment, "some other comment"
        end
      end

      context "vectors" do
        it "recongizes vectors" do
          token = reader.next "[\"str 1\"]"

          expect(token).to be_a_token :vector
          expect(token[0]).to include a_token(:string, "str 1")
        end

        it "recongizes vectors ignoring separators" do
          token = reader.next "[\"str 1\" \"str 2\"  \"str 3\"\n\"str 4\"]"

          expect(token).to be_a_token :vector
          expect(token[0]).to include(
            a_token(:string, "str 1"),
            a_token(:separator, " "),
            a_token(:string, "str 2"),
            a_token(:separator, " "),
            a_token(:separator, " "),
            a_token(:string, "str 3"),
            a_token(:new_line, "\n"),
            a_token(:string, "str 4"),
          )
        end
      end

      context "blocks" do
        it "recognizes blocks" do
          token = reader.next "{\"one\",\"block\"\n\"three strings\"}"

          expect(token).to be_a_token :block
          expect(token[0]).to include(
            a_token(:string, "one"),
            a_token(:separator, ","),
            a_token(:string, "block"),
            a_token(:new_line, "\n"),
            a_token(:string, "three strings"),
          )
        end
      end

    end
  end
end
