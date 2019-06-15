module Feeble::Evaler
  include ::Feeble::Runtime

  RSpec.describe Lispey do
    subject(:evaler) { described_class.new }

    describe "#eval" do
      context "Lists" do
        class ZeroParam
          include Feeble::Runtime::Invokable

          def initialize
            add_arity { "yup" }
          end
        end

        it "knows to invoke fn without parameters" do
          env = Env.new
          env.register Symbol.new("zero"), ZeroParam.new
          invokation = List.create Symbol.new("zero")

          expect(evaler.eval(invokation, env: env)).to eq "yup"
        end

        it "interprets a list as an invocation" do
          ping = List.create Symbol.new("%_ping"), "world"

          expect(evaler.eval(ping)).to eq "pong with: world"
        end

        it "raise runtime error if form is not sym, primitive, fun or lookup" do
          expect {
            evaler.eval(List.create("nothing"))
          }.to raise_error "Can't invoke <nothing>, nor recognize it as a form"
        end
      end
    end

    context "interop" do
      describe "::" do
        it "translates 'square' invokation into host invokation" do
          # ::print(1)

          host_invokation = List.create(
            Symbol.new("::"),
            Symbol.new("print"),
            List.create(Symbol.new("%arr"), 1)
          )

          expect {
            expect(evaler.eval(host_invokation)).to eq nil
          }.to output("1").to_stdout
        end
      end

      it "invokes method in the Kernel scope" do
        # ::print(1)

        puts_invokation = List.create(
          Symbol.new("%host"),
          Symbol.new("."),
          Symbol.new("Kernel"),
          Symbol.new("print"),
          1)

        # should return nil and print to stdout
        expect {
          expect(evaler.eval(puts_invokation)).to eq nil
        }.to output("1").to_stdout
      end

      it "invokes method on object from host" do
        # ::"lol".upcase()

        invokation = List.create(
          Symbol.new("%host"),
          Symbol.new("."),
          "lol",
          Symbol.new("upcase"))

        expect(evaler.eval(invokation)).to eq "LOL"
      end
    end
  end
end
