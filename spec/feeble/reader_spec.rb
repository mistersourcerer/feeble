RSpec.describe Feeble::Reader do
  subject(:reader) { described_class.new }

  describe "#call" do
    it "reads all tokens in a given string" do
      code = "\"this code\" \"has two strings\"\n[\"and\" \"a\" \"vector\"]"
      tokens = reader.call code
      vector_tokens = tokens[4][0]

      expect(tokens).to include(
        a_token(:string, "this code"),
        a_token(:separator, " "),
        a_token(:string, "has two strings"),
        a_token(:new_line, "\n"),
        a_token(:vector),
      )

      expect(vector_tokens).to include(
        a_token(:string, "and"),
        a_token(:separator, " "),
        a_token(:string, "a"),
        a_token(:separator, " "),
        a_token(:string, "vector"),
      )
    end
  end
end
