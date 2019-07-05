module Feeble::Reader
  include ::Feeble::Runtime

  RSpec.describe Code do
    subject(:reader) { described_class.new }

    context "Quoting" do
      it "reads ' syntax into a (quote ...) invokation" do
        expect(reader.read "'(a)").to eq [
          List.create(
            Symbol.new("quote"),
            List.new(Symbol.new("a")))
        ]
      end
    end

    context "Keywords" do
      it "recognizes an atom in the wild" do
        expect(reader.read "a:").to eq [
          Keyword.new("a:")
        ]
      end
    end

    context "Booleans" do
      it "recognizes boolean values (as 'host' Boolean)" do
        expect(reader.read(" true ")).to eq [true]
        expect(reader.read(" false ")).to eq [false]
      end
    end

    context "Maps" do
      it "recognizes maps (as 'host' Hash)" do
        expect(reader.read(" {a: true b: false} ")).to eq [
          {
            Keyword.new("a:") => true,
            Keyword.new("b:") => false
          }
        ]

        expect(reader.read(" {a: true, b: false} ")).to eq [
          {
            Keyword.new("a:") => true,
            Keyword.new("b:") => false
          }
        ]
      end

      it "recognizes nested maps" do
        expect(reader.read("{a: true b: {c: false}}")).to eq [
          {
            Keyword.new("a:") => true,
            Keyword.new("b:") => {
              Keyword.new("c:") => false
            }
          }
        ]
      end
    end

    context "Function invokation" do
      it "recognizes the list invokation pattern" do
        code = "(quote (a:))"

        expect(reader.read(code)).to eq [
          List.create(
            Symbol.new("quote"),
            List.create(Keyword.new("a:")))
        ]
      end

      it "recognizes nested lists" do
        code = "(quote (a: (b: (c:))))"

        expect(reader.read(code)).to eq [
          List.create(
            Symbol.new("quote"),
            List.create(
              Keyword.new("a:"),
              List.create(
                Keyword.new("b:"),
                List.create(Keyword.new("c:")))))
        ]
      end

      it "recognizes the 'c-like' invokation pattern" do
        code = "define(omg, true)"

        expect(reader.read(code)).to eq [
          List.create(
            Symbol.new("define"),
            Symbol.new("omg"),
            true
          )
        ]
      end
    end

    context "Function declaration" do
      it "recognizes lambda without params" do
        expect(reader.read "-> {a:}").to eq [
          List.create(
            Symbol.new("lambda"), [Keyword.new("a:")])
        ]
      end

      it "recognizes lambda with some body" do
        expect(reader.read "-> { yes: }").to eq [
          List.create(
            Symbol.new("lambda"), [Keyword.new("yes:")])
        ]
      end

      it "recognizes lambda with params" do
        expect(reader.read "-> a, b { true }").to eq [
          List.create(
            Symbol.new("lambda"),
            [Symbol.new("a"), Symbol.new("b")],
            [true]
          )
        ]
      end

      it "recognizes lambda with params and meta-data" do
        expect(reader.read "-> a, b {special: false} { true }").to eq [
          List.create(
            Symbol.new("lambda"),
            [Symbol.new("a"), Symbol.new("b")],
            [true],
            {Keyword.new("special:") => false})
        ]
      end
    end

    context "Numbers" do
      it "recognizes integers" do
        expect(reader.read "1").to eq [1]
        expect(reader.read "1_001").to eq [1001]
        expect(reader.read "-1").to eq [-1]
        expect(reader.read "-100_1").to eq [-1001]
      end

      it "recognizes floats" do
        expect(reader.read "4.2").to eq [4.2]
        expect(reader.read "4_200.1").to eq [4200.1]
        expect(reader.read "-4.2").to eq [-4.2]
        expect(reader.read "-4_200.1").to eq [-4200.1]
      end
    end
  end
end
