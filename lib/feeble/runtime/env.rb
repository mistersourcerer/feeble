module Feeble::Runtime
  class Env
    include Invokable

    def initialize(registry = Map.new)
      @registry = registry
      @verify = Verifier.new
      @envs = []
      @functions = Tree.new

      register_lookup_invokation
      register_storing_invokation
    end

    def lookup(id)
      @registry.get id
    end

    def register(name, value = nil)
      check_name_type name

      @registry.put name, value
      register_function name, value
    end

    def wrap(env)
      return self if !env
      raise "Expected #{env} to be an Env" unless @verify.env? env

      self.class.new env.registry.merge(@registry)
    end

    def fn_lookup(name)
      check_name_type name

      @functions.search name.id.to_s
    end

    protected

    def registry
      @registry
    end

    private

    def register_lookup_invokation
      add_arity(Symbol.new(:lookup)) { |env|
        name = env.lookup Symbol.new(:lookup)
        @verify.symbol?(name) ? self.lookup(name) : nil
      }
    end

    def register_storing_invokation
      add_arity(Symbol.new(:name), Symbol.new(:value)) { |env|
        name = env.lookup Symbol.new(:name)
        check_hame_type name
        self.register name, env.lookup(Symbols.new(:value))
      }
    end

    def check_name_type(name)
      return if @verify.symbol?(name)

      raise "Only Symbols can be associated with values, not #{name}"
    end

    def register_function(name, value)
      if @verify.fn? value
        @functions.add name.id.to_s, value
      end
    end
  end
end
