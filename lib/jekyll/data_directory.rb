# frozen_string_literal: true

module Jekyll
  # A class that behaves very similar to Ruby's `Hash` class yet different in how
  # it is handled by Liquid. Almost all public methods delegate to the Hash object
  # stored in the instance_variable `@metadata` to some degree.
  class DataDirectory
    # Delegate given (zero-arity) method(s) to the Hash object stored in instance
    # variable `@metadata`.
    # NOTE: Avoiding the use of `Forwardable` module's `def_delegators` for
    # preventing unnecessary creation of interim objects on multiple calls.
    def self.delegate_to_metadata(*symbols)
      symbols.each { |sym| define_method(sym) { @metadata.send(sym) } }
    end
    private_class_method :delegate_to_metadata

    delegate_to_metadata :freeze, :inspect
    attr_accessor :context

    def initialize
      @metadata = {}
    end

    def [](key)
      @metadata[key].tap do |value|
        value.context = context if value.respond_to?(:context=)
      end
    end

    # `Hash#to_liquid` returns the Hash instance itself.
    # Mimic that behavior by returning `self` instead of returning the `@metadata`
    # variable value.
    def to_liquid
      self
    end

    def merge(other, &block)
      merged_metadata = @metadata.merge(other, &block)
      dup.tap { |d| d.instance_variable_set(:@metadata, merged_metadata) }
    end

    def merge!(other, &block)
      @metadata.merge!(other, &block)
      self
    end

    def method_missing(method, *args, &block)
      @metadata.send(method, *args, &block)
    end

    def respond_to_missing?(method, *)
      @metadata.respond_to?(method)
    end
  end
end
