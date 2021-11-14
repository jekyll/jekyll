# frozen_string_literal: true

module Jekyll
  module SiteData
    class Directory
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

      def method_missing(method, *args, &block)
        @meta.send(method, *args, &block)
      end

      def respond_to_missing?(method, *)
        @meta.respond_to?(method)
      end

      def inspect
        @meta.inspect
      end
    end
  end
end
