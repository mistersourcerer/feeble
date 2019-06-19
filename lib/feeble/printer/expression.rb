module Feeble::Printer
  class Expression
    include Feeble::Runtime

    def initialize
      @verify = Verifier.new
    end

    def print(expression, to: $stdout)
      to.print " > #{printable_for(expression)}"
    end

    private

    def printable_for(expression)
      if expression.respond_to?(:printable)
        expression.printable { |el| printable_for(el) }
      else
        expression.inspect
      end
    end
  end
end
