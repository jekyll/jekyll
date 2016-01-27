# encoding: UTF-8

module Jekyll
  module Drops
    class DocumentDrop < Drop
      extend Forwardable

      mutable false

      def_delegator :@obj, :next_doc, :next
      def_delegator :@obj, :previous_doc, :previous
      def_delegator :@obj, :relative_path, :path
      def_delegators :@obj, :id, :to_s, :relative_path, :url

      def content
        link_dependency
        return @obj.content
      end

      def output
        link_dependency
        return @obj.output
      end

      def collection
        @obj.collection.label
      end

      def excerpt
        fallback_data['excerpt'].to_s
      end

      private
      def_delegator :@obj, :data, :fallback_data
    end
  end
end
