require "feeble/runtime/argument_type_mismatch"

module Feeble::Runtime
  class SomeFunction
    include Invokable
  end

  RSpec.describe SomeFunction do
    subject(:fn) { described_class.new }

    describe "#arity" do
      it "only accepts symbols" do
        expect {
          fn.arity(:omg)
        }.to raise_error ArgumentTypeMismatch
        # TODO: why Zeitwerk doesn't find this one without the require?
        #   might be a bug...
      end
    end

    describe "#invoke" do
      it "returns the value returned by the block" do
        fn.arity(Symbol.new("a")) { 1 }

        expect(fn.invoke(nil)).to eq 1
      end

      it "raises if the function doesn't have the given arity" do
        fn.arity(Symbol.new("only_one")) { 1 }

        expect { fn.invoke }.to raise_error ArityMismatch
      end
    end

    context "Invoke routing via arity" do
      it "routes the invokation to the correct arity" do
        arity_one = false
        fn.arity(Symbol.new("a")) { |env|
          arity_one = true
        }

        bigger_arity = false
        fn.arity(Symbol.new("a"), Symbol.new("b")) { |env|
          bigger_arity = true
        }

        fn.invoke 1
        expect(arity_one).to eq true
        expect(bigger_arity).to eq false

        arity_one = false
        fn.invoke 1, 2
        expect(arity_one).to eq false
        expect(bigger_arity).to eq true
      end

      it "creates variables named after the arguments declared" do
        value = nil
        fn.arity(Symbol.new("a")) { |env|
          value = env.lookup(Symbol.new("a"))
        }

        fn.invoke 1
        expect(value).to eq 1
      end

      context "varargs" do
        it "allow create a varargs function using the splat syntax" do
          values = nil
          fn.arity(Symbol.new("*stuff")) { |env|
            values = env.lookup(Symbol.new("stuff"))
          }

          fn.invoke 1, 2, 3, 4
          expect(values).to eq [1, 2, 3, 4]

          fn.invoke
          expect(values).to eq []

          fn.invoke "1", "2"
          expect(values).to eq ["1", "2"]
        end
      end

      context "scope" do
        it "creates an environment for the invokation" do
          value = nil
          outter_scope = Env.new
          outter_scope.register Symbol.new("lol"), true
          fn.arity(Symbol.new("lol")) { |env|
            value = env.lookup Symbol.new("lol")
          }

          fn.invoke(false, scope: outter_scope)
          expect(value).to eq false
        end

        it "fallback to the external scope" do
          value = nil
          outter_scope = Env.new
          outter_scope.register Symbol.new("lol"), true
          fn.arity(Symbol.new("dont_override")) { |env|
            value = env.lookup Symbol.new("lol")
          }

          fn.invoke(false, scope: outter_scope)
          expect(value).to eq true
        end
      end
    end

    context "Properties and execution strategy"
  end
end
