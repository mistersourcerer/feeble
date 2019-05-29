module Feeble::Language
  include Feeble::Runtime

  class Host < Env
    class Dot
      include Feeble::Runtime
      include Feeble::Runtime::Invokable

      def initialize
        @env = Env.new

        add_var_args(Symbol.new(:path)) { |env|
          path = env.lookup(Symbol.new(:path))
          target = path.shift
          raise "#{target} is not defined by %host." unless defined? target

          method = path.shift.id
          if path.count > 0
            target.send(method, *path)
          else
            target.send method
          end
        }
      end
    end

    def initialize(*_)
      super
      register Feeble::Runtime::Symbol.new("."), Dot.new
    end
  end

  module Math
    class Plus
      include Feeble::Runtime
      include Feeble::Runtime::Invokable

      def initialize
        add_arity(Symbol.new(:num1), Symbol.new(:num2)) { |env|
          env.lookup(Symbol.new(:num1)) + env.lookup(Symbol.new(:num2))
        }
      end
    end
  end

  class Fbl < Env
    include Feeble::Runtime

    def initialize
      super
      register Symbol.new("%host"), Host.new
      register Symbol.new("+"), Math::Plus.new
    end

    def invoke(*params)
      return lookup(params.first) if params.length == 1
    end
  end
end
