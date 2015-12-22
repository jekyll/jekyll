# encoding: UTF-8

module Jekyll
  module Drops
    class DocumentDrop < ImmutableDrop

      def output
        @obj.output
      end

      def content
        @obj.content
      end

      def relative_path
        @obj.relative_path
      end
      alias_method :path, :relative_path

      def url
        @obj.url
      end

      def collection
        @obj.collection.label
      end

      def next
        @obj.next_doc
      end

      def previous
        @obj.previous_doc
      end

      def id
        @obj.id
      end

      def excerpt
        data['excerpt'].to_s
      end

      def data
        @obj.data
      end

    end
  end
end
