module Feeble::Language
  include Feeble::Runtime

  class Host < Env
    # Just a "blueprint" for how invokables should look like
    class Dot
      include Feeble::Runtime
      include Feeble::Runtime::Invokable

      def initialize
        @env = Env.new

        add_var_args(Symbol.new(:path)) { |env|
          path = env.lookup(Symbol.new(:path))
          target = path.shift
          method = path.shift.id
          if path.count > 0
            target.send method, params
          else
            target.send method
          end
        }
      end

      private

      def ruby(symbol)
        symbol.id
      end
    end

    def initialize(*_)
      super
      register Feeble::Runtime::Symbol.new("."), Dot.new
    end
  end

  class Fbl < Env
    def initialize
      super
      register Feeble::Runtime::Symbol.new("%host"), Host.new
    end

    def invoke(*params)
      return lookup(params.first) if params.length == 1
    end
  end
end
