module Feeble::Language::Ruby
  include Feeble::Runtime

  RSpec.describe Lambda do
    subject(:creator) { described_class.new }

    it "returns an invokable" do
      new_lambda = creator.invoke([], [])
      expect(new_lambda.is_a?(Invokable)).to eq(true)
    end

    it "returns an invokable with arity related to the passed params" do
      zero_arity = creator.invoke([1])
      expect(zero_arity.invoke).to eq 1

      one_arity = creator.invoke([Symbol.new("a")], [2])
      expect(one_arity.invoke(1)).to eq 2

      two_arity = creator.invoke([
        Symbol.new("a"), Symbol.new("b")], [3])
      expect(two_arity.invoke(1, 2)).to eq 3

      var_args = creator.invoke([
        Symbol.new("*all")], [4])
      expect(var_args.invoke(1, 2, 3)).to eq 4
      expect(var_args.invoke(1, 2, 3, 4)).to eq 4
    end

    it "creates a lambda with properties"
  end
end
