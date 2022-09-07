# frozen_string_literal: true

module Jekyll
  # A class that behaves very similar to Ruby's `Hash` class yet different in how it is handled by
  # Liquid. This class emulates Hash by delegation instead of inheritance to minimize overridden
  # methods especially since some Hash methods returns another Hash instance instead of the
  # subclass instance.
  class DataHash
    #
    # Delegate given (zero-arity) method(s) to the Hash object stored in instance variable
    # `@registry`.
    # NOTE: Avoiding the use of `Forwardable` module's `def_delegators` for preventing unnecessary
    # creation of interim objects on multiple calls.
    def self.delegate_to_registry(*symbols)
      symbols.each { |sym| define_method(sym) { @registry.send(sym) } }
    end
    private_class_method :delegate_to_registry

    # -- core instance methods --

    attr_accessor :context

    def initialize
      @registry = {}
    end

    def [](key)
      @registry[key].tap do |value|
        value.context = context if value.respond_to?(:context=)
      end
    end

    # `Hash#to_liquid` returns the Hash instance itself.
    # Mimic that behavior by returning `self` instead of returning the `@registry` variable value.
    def to_liquid
      self
    end

    # -- supplementary instance methods to emulate Hash --

    delegate_to_registry :freeze, :inspect

    def merge(other, &block)
      merged_registry = @registry.merge(other, &block)
      dup.tap { |d| d.instance_variable_set(:@registry, merged_registry) }
    end

    def merge!(other, &block)
      @registry.merge!(other, &block)
      self
    end

    def method_missing(method, *args, &block)
      @registry.send(method, *args, &block)
    end

    def respond_to_missing?(method, *)
      @registry.respond_to?(method)
    end
  end
end
