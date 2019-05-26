module Feeble::Runtime
  module Invokable
    def add_arity(*param_names, &procedure)
      arities[param_names.count] = InvokationShape.new param_names, procedure
    end

    def add_var_args(param_name, &procedure)
      self.var_args = InvokationShape.new Array(param_name), procedure
    end

    def invoke(*params, scope: nil)
      current_invokation = shape_for_arity(params)
      current_invokation ||= var_args if var_args
      raise "No function with arity #{params.count} was found." unless current_invokation

      internal_env = bind_args current_invokation, params
      env =
        if scope
          internal_env.wrap scope
        else
          internal_env
        end

      current_invokation.call env
    end

    private

    attr_accessor :var_args

    def arities
      @arities ||= {}
    end

    def shape_for_arity(args)
      arities[args.length]
    end

    def bind_args(invokation_shape, args)
      Env.new.tap { |env|
        var_args_invokation = invokation_shape.params.count == 1 && args.count > 1
        if var_args_invokation
          env.register invokation_shape.params.first, args
        else
          invokation_shape
            .params
            .each_with_index do |param, index|
              env.register param, args[index]
            end
        end
      }
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
  end
end
