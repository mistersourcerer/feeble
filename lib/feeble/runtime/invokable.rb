module Feeble::Runtime
  module Invokable
    def arity(*names, &callable)
      if names.find { |name| !_verify.symbol? name }
        raise ArgumentTypeMismatch.new(nil, Symbol)
      end

      arities_identifier =
        # TODO: generalize star so it can appear in any position
        if names.length == 1 && String(names.first).start_with?("*")
          "*"
        else
          names.count
        end

      _arities[arities_identifier] = {
        callable: callable,
        symbols: names,
      }
    end

    def invoke(*params, scope: EnvNull.instance)
      env = Env.new(scope)
      function = _arity_for(params)

      function[:symbols].each_with_index do |symbol, index|
        name, value =
          if String(symbol).start_with?("*")
            [Symbol.new(String(symbol)[1..]), params]
          else
            [symbol, params[index]]
          end

        env.register name, value
      end

      function[:callable].call(env)
    end

    def prop(key, value = true)
      _props[key] = value
    end

    def prop?(key)
      _props[key] == true
    end

    private

    def _verify
      @_verify ||= Verifier.new
    end

    def _arities
      @_arities ||= {}
    end

    def _arity_for(params)
      _arities.fetch(params.count) { _arities["*"] } ||
        raise(ArityMismatch.new(params.count, _arities))
    end

    def _props
      @_props ||= {}
    end
  end

  class ArityMismatch < StandardError
    def initialize(given, arities)
      super with_message(given, arities)
    end

    private

    def with_message(given, arities)
      "No arity < #{given} > for this function. Existent: #{arities.keys.join(", ")}"
    end
  end
end
