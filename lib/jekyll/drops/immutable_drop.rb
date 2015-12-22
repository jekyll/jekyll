# encoding: UTF-8

module Jekyll
  module Drops
    class ImmutableDrop < Liquid::Drop

      def initialize(obj)
        @obj = obj
      end

      def [](key)
        if respond_to? key
          public_send key
        else
          data[key]
        end
      end

      def []=(key, val)
        if respond_to? key
          raise ArgumentError.new("Key #{key} cannot be set in the drop.")
        else
          data[key] = val
        end
      end

    end
  end
end
