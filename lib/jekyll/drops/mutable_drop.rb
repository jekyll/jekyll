# encoding: UTF-8

module Jekyll
  module Drops
    class MutableDrop < Liquid::Drop

      def initialize(obj)
        @obj = obj
        @mutations = {}
      end

      def [](key)
        if @mutations.key? key
          @mutations[key]
        elsif respond_to? key
          public_send key
        else
          fallback_data[key]
        end
      end

      def []=(key, val)
        @mutations[key] = val
      end

    end
  end
end
