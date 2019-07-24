module Feeble::Reader
  class Read
    include Feeble::Runtime
    include Invokable

    def initialize
      @fn = ListFunctions.new(StrEmpty.instance)
      @number = Number.new

      arity(Feeble::Runtime::Symbol.new(:code)) { |env|
        read Str.create(env.lookup(Feeble::Runtime::Symbol.new(:code))), env
      }
    end

    private

    SEPARATOR = /\A[\s,]/

    attr_reader :fn

    Sym = Feeble::Runtime::Symbol

    def read(code, env, expressions: [])
      return expressions if fn.empty?(code)

      token, remaining_code = *next_token(code)
      expressions << token

      read(remaining_code, env, expressions: expressions)
    end

    def ignore_separators(string)
      return StrEmpty.instance if fn.empty? string
      return string if !SEPARATOR.match? String(string.first)

      ignore_separators(string.rest)
    end

    def next_token(code, looking_at = StrEmpty.instance)
      return [Sym.new(looking_at), StrEmpty.instance] if fn.empty? code

      case String(code.first)
      when SEPARATOR
        [Sym.new(looking_at), ignore_separators(code.rest)]
      when Number::START
        number, remaining_code = *@number.invoke(code)
        [number, ignore_separators(remaining_code)]
      else
        next_token(code.rest, looking_at.apnd(code.first))
      end
    end
  end
end
