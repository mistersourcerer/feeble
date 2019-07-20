module Feeble::Reader
  class Read
    include Feeble::Runtime
    include Invokable

    def initialize
      @fn = ListFunctions.new(StrEmpty.instance)
      @number = Number.new

      arity(Symbol.new(:code)) { |env|
        read Str.create(env.lookup(Symbol.new(:code))), env
      }
    end

    private

    SEPARATOR = /\A[\s,]/

    attr_reader :fn

    def read(string, env, token: Str.create(""), code: [])
      if fn.empty? string
        if !token.empty?
          atom, _ = read_token(string, env, token: token, code: code)
          code << atom
        end

        return code
      end

      new_string, new_token = *
        case String(string.first)
        when SEPARATOR
          read_separator string, env, token: token, code: code
        when Number::START
          read_number string, env, code: code
        else
          [string.rest, token.apnd(string.first)]
        end

      read(new_string, env, token: new_token, code: code)
    end

    def read_separator(string, env, token: Str.create(""), code: [])
      return [string, token] if token.count == 0

      atom, new_string = read_token(
        ignore_separators(string.rest), env, token: token, code: code)
      code << atom

      [new_string, Str.create("")]
    end

    def ignore_separators(string)
      return StrEmpty.instance if fn.empty? string
      return string if !SEPARATOR.match? String(string.first)

      ignore_separators(string.rest)
    end

    def read_number(string, env, token: Str.create(""), code: [])
      number, new_string = *@number.invoke(string)
      code << number

      [ignore_separators(new_string), Str.create("")]
    end

    def read_token(string, env, token: Str.create(""), code: [])
      # 1) token is a unary op function? process. Function is reader?
      # 2) token anything else, check if next token is a binary op
      #     if so, also read one more token and process
      # 3) else, return the symbolized token
      [Symbol.new(token), string]
    end
  end
end
