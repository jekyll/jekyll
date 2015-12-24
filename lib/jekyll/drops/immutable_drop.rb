# encoding: UTF-8

module Jekyll
  module Drops
    class ImmutableDrop < Liquid::Drop
      IllegalDropModification = Class.new(Jekyll::StandardError)

      def initialize(obj)
        @obj = obj
      end

      def [](key)
        if respond_to? key
          public_send key
        else
          fallback_data[key]
        end
      end

      def []=(key, val)
        if respond_to? key
          raise IllegalDropModification.new("Key #{key} cannot be set in the drop.")
        else
          fallback_data[key] = val
        end
      end

    end
  end
end
