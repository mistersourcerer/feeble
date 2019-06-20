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

    context "Atoms" do
      it "recognizes an atom in the wild" do
        expect(reader.read "a:").to eq [
          Atom.new("a:")
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
            Atom.new("a:") => true,
            Atom.new("b:") => false
          }
        ]

        expect(reader.read(" {a: true, b: false} ")).to eq [
          {
            Atom.new("a:") => true,
            Atom.new("b:") => false
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
            List.create(Atom.new("a:")))
        ]
      end

      it "recognizes nested lists" do
        code = "(quote (a: (b: (c:))))"

        expect(reader.read(code)).to eq [
          List.create(
            Symbol.new("quote"),
            List.create(
              Atom.new("a:"),
              List.create(
                Atom.new("b:"),
                List.create(Atom.new("c:")))))
        ]
      end
    end

    context "Function declaration" do
      it "recognizes lambda without params" do
        expect(reader.read "-> {}").to eq [
          List.create(
            Symbol.new("lambda"), [])
        ]
      end

      it "recognizes lambda with some body" do
        expect(reader.read "-> { yes: }").to eq [
          List.create(
            Symbol.new("lambda"), [Atom.new("yes:")])
        ]
      end

      it "recognizes lambda with params" do
        expect(reader.read "-> a, b {}").to eq [
          List.create(
            Symbol.new("lambda"),
            [Symbol.new("a"), Symbol.new("b")],
            []
          )
        ]
      end

      it "recognizes lambda with params and meta-data" do
        expect(reader.read "-> a, b {special: false} { }").to eq [
          List.create(
            Symbol.new("lambda"),
            [Symbol.new("a"), Symbol.new("b")],
            [],
            {Atom.new("special:") => false})
        ]
      end
    end
  end
end
