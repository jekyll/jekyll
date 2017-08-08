# encoding: UTF-8
# frozen_string_literal: true

module Jekyll
  module Drops
    class CollectionDrop < Drop
      extend Forwardable

      mutable false

      def_delegator :@obj, :write?, :output
      def_delegators :@obj, :label, :docs, :files, :directory,
                            :relative_directory

      def to_s
        docs.to_s
      end

      private
      def_delegator :@obj, :metadata, :fallback_data
    end
  end
end
