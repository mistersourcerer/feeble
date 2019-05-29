module Feeble::Runtime
  module Invokable
    def add_arity(*param_names, &procedure)
      arities[param_names.count] = InvokationShape.new param_names, procedure
    end

    def add_var_args(param_name, &procedure)
      self.var_args = InvokationShape.new Array(param_name), procedure
    end

    def invoke(*params, scope: nil)
      current_invokation = current_invokation_from(params)
      env = bind_args(current_invokation, params).wrap(scope)

      current_invokation.call env
    end

    private

    attr_accessor :var_args

    def arities
      @arities ||= {}
    end

    def current_invokation_from(params)
      current_invokation = shape_for_arity(params) || var_args

      if !current_invokation
        raise "No function with arity #{params.count} was found."
      else
        current_invokation
      end
    end

    def shape_for_arity(args)
      arities[args.length]
    end

    def bind_args(invokation_shape, args)
      Env.new.tap { |env|
        if var_args?(invokation_shape, args)
          env.register invokation_shape.params.first, args
        else
          invokation_shape.register env, args
        end
      }
    end

    def var_args?(invokation_shape, args)
      invokation_shape.params.count == 1 && args.count > 1
    end
  end

  class InvokationShape
    attr_reader :params

    def initialize(params, procedure)
      @params = params
      @procedure = procedure
    end

    def call(env)
      @procedure.call env
    end

    def register(env, args)
      params.each_with_index do |param, index|
        env.register param, args[index]
      end
    end
  end
end
