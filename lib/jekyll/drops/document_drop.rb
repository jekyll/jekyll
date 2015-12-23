# encoding: UTF-8

module Jekyll
  module Drops
    class DocumentDrop < ImmutableDrop
      extend Forwardable

      def_delegators :@obj, :id, :output, :content, :to_s, :relative_path, :url

      alias_method :path, :relative_path

      def collection
        @obj.collection.label
      end

      def next
        @obj.next_doc
      end

      def previous
        @obj.previous_doc
      end

      def excerpt
        fallback_data['excerpt'].to_s
      end

      private
      def_delegator :@obj, :data, :fallback_data

    end
  end
end
