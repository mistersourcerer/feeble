module Feeble::Reader
  class Number
    START = /\A[\d\-_]{1}/
    BODY = /\A[\d\-_\.]{1}/

    include Feeble::Runtime
    include Invokable

    def initialize
      prop :reader

      arity(Feeble::Runtime::Symbol.new(:code)) { |env|
        source_code = env.lookup(Feeble::Runtime::Symbol.new(:code))
        number, code = read_number_from source_code
        [parse_number(number), code]
      }
    end

    private

    FLOAT = /\A[\-\d_]+\.[\d_]+\z/

    def read_number_from(source_code, current_number = Str.create(""))
      finished_or_not_number = (source_code.empty? ||
        (current_number.empty? && !START.match?(source_code.first)))
      return current_number, source_code if finished_or_not_number
      return current_number, source_code if !BODY.match?(source_code.first)

      read_number_from(
        source_code.rest, current_number.apnd(source_code.first))
    end

    def parse_number(number)
      number = String(number)
      return nil if number.length == 0

      FLOAT.match?(number) ? Float(number) : Integer(number)
    end
  end
end
