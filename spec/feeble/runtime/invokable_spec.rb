module Feeble::Runtime
  class Fn
    include Invokable
  end

  RSpec.describe Fn do
    subject(:fn) { described_class.new }

    context "multiple arities" do
      describe "#add_arity" do
        it "ties a 'block' with a number of parameters" do
          fn.add_arity(Symbol.new(:param1)) { 1 }
          fn.add_arity(Symbol.new(:param1), Symbol.new(:param2)) { 2 }

          expect(fn.invoke(:one)).to eq 1
          expect(fn.invoke(:one, :two)).to eq 2
        end

        it "raises if non-symbols are passed as param names" do
          expect { fn.add_arity(:oh_no) }
            .to raise_error(Invokable::InvalidParamName)

          expect { fn.add_arity(1) }
            .to raise_error(Invokable::InvalidParamName)
        end

        it "handles 0 arity" do
          fn.add_arity { "no-params!" }

          expect(fn.invoke).to eq "no-params!"
        end
      end

      describe "#var_args" do
        it "associates a block with a variable number of args" do
          fn.add_var_args(Symbol.new(:args)) { "var-args" }

          expect(fn.invoke(:one)).to eq "var-args"
          expect(fn.invoke(:one, :two)).to eq "var-args"
        end

        it "ensures var args have the lowest precedence" do
          fn.add_var_args(Symbol.new(:args)) { "var-args" }
          fn.add_arity(Symbol.new(:priority)) { "explicit-arity" }

          expect(fn.invoke(:one)).to eq "explicit-arity"
          expect(fn.invoke(:one, :two)).to eq "var-args"
          expect(fn.invoke(:one, :two, :tree)).to eq "var-args"
        end
      end
    end

    context "invokation" do
      describe "#invoke" do
        it "bind arguments to the parameter (names)" do
          fn.add_arity(Symbol.new(:param1), Symbol.new(:param2)) { |env|
            param1 = env.lookup Symbol.new(:param1)
            param2 = env.lookup Symbol.new(:param2)
            "#{param1}:#{param2}"
          }

          expect(fn.invoke("one", "two")).to eq "one:two"
        end

        it "searches external scope for values" do
          scope = Env.new.tap { |e| e.register(Symbol.new(:external), 1) }
          fn.add_arity(Symbol.new(:internal)) { |env|
            external = env.lookup Symbol.new(:external)
            internal = env.lookup Symbol.new(:internal)

            external + internal
          }
          result = fn.invoke(2, scope: scope)

          expect(result).to eq 3
        end
      end
    end

    describe "#props" do
      it "associates value with a given symbol" do
        fn.put Symbol.new(:this), "is good"

        expect(fn.get(Symbol.new(:this))).to eq "is good"
      end

      it "associates true with property if no value is given" do
        fn.put Symbol.new(:you_sure?)

        expect(fn.get(Symbol.new(:you_sure?))).to eq true
      end

      describe "#is? as a shorthand for accessing boolean props" do
        it "returns true for existent true props" do
          fn.put Symbol.new(:awesome)

          expect(fn.is? :awesome).to eq true
          expect(fn.is? "awesome").to eq true
        end

        it "returns false for false/inexistent props" do
          fn.put Symbol.new(:awesome), false

          expect(fn.is? :awesome).to eq false
          expect(fn.is? "awesome").to eq false
          expect(fn.is? "anything?").to eq false
        end

        it "returns false for non-true props" do
          fn.put Symbol.new(:awesome), "true"

          expect(fn.is? :awesome).to eq false
        end
      end
    end
  end
end
