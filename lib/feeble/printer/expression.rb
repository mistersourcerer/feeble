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
      if expression.is_a?(Printable)
        expression.to_print { |el| printable_for(el) }
      else
        if expression.nil?
          "NIL"
        else
          "#{expression.inspect} (#{expression.class})"
        end
      end
    end
  end
end
