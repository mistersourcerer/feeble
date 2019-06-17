module Feeble::Printer
  class Expression
    include Feeble::Runtime

    def initialize
      @verify = Verifier.new
    end

    def to_print(expression)
      return "\"#{expression}\"" if @verify.string? expression
      return "#{expression}" if @verify.int?(expression) || @verify.float?(expression)

      expression.inspect
    end
  end
end
