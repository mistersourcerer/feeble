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

      token, remaining_code = *next_token(code, env)
      # the whole read two token at once can be done here...
      expressions << token

      read(remaining_code, env, expressions: expressions)
    end

    def ignore_separators(string)
      return StrEmpty.instance if fn.empty? string
      return string if !SEPARATOR.match? String(string.first)

      ignore_separators(string.rest)
    end

    def next_token(code, env, looking_at = StrEmpty.instance)
      if fn.empty? code
        return [handle_token(looking_at, env), StrEmpty.instance]
      end

      case String(code.first)
      when SEPARATOR
        [handle_token(looking_at, env), ignore_separators(code.rest)]
      when Number::START
        number, remaining_code = *@number.invoke(code)
        [number, ignore_separators(remaining_code)]
      else
        next_token(code.rest, env, looking_at.apnd(code.first))
      end
    end

    def handle_token(token, env)
      # TODO: can be:
      #   - an invokation ( some() )
      #   - an invokation ( some(more 1 stuff) )
      #   - an invokation ( some({ more: stuff }) )
      case
      when token.first == ":" || token.to_s[-1] == ":"
        Keyword.new(token)
      else
        Sym.new(token)
      end
    end
  end
end
