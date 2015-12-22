# encoding: UTF-8
require "jekyll/drops/immutable_drop"

module Jekyll
  module Drops
    class CollectionDrop < ImmutableDrop
      extend Forwardable

      def_delegators :@obj, :label, :docs, :files, :directory, :relative_directory

      def output
        @obj.write?
      end

      private
      def fallback_data
        @obj.metadata
      end

    end
  end
end
