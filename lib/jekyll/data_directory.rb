# frozen_string_literal: true

module Jekyll
  class DataDirectory
    # Delegate given (zero-arity) method(s) to the Hash object stored in instance
    # variable `@meta`.
    def self.delegate_to_meta(*symbols)
      symbols.each { |sym| define_method(sym) { @meta.send(sym) } }
    end
    private_class_method :delegate_to_meta

    delegate_to_meta :freeze, :inspect
    attr_accessor :context

    def initialize
      @meta = {}
    end

    def [](key)
      @meta[key].tap do |value|
        value.context = context if value.respond_to?(:context=)
      end
    end

    def to_liquid
      self
    end

    def merge(other, &block)
      merged_meta = @meta.merge(other, &block)
      dup.tap { |d| d.instance_variable_set(:@meta, merged_meta) }
    end

    def merge!(other, &block)
      @meta.merge!(other, &block)
      self
    end

    def method_missing(method, *args, &block)
      @meta.send(method, *args, &block)
    end

    def respond_to_missing?(method, *)
      @meta.respond_to?(method)
    end
  end
end
