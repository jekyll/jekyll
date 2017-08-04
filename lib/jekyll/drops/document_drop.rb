# encoding: UTF-8
# frozen_string_literal: true

module Jekyll
  module Drops
    class DocumentDrop < Drop
      extend Forwardable

      NESTED_OBJECT_FIELD_BLACKLIST = %w(
        content output excerpt next previous
      ).freeze

      mutable false

      def_delegator :@obj, :relative_path, :path
      def_delegators :@obj, :id, :output, :content, :to_s, :relative_path, :url

      def collection
        @obj.collection.label
      end

      def excerpt
        fallback_data["excerpt"].to_s
      end

      def <=>(other)
        return nil unless other.is_a? DocumentDrop
        cmp = self["date"] <=> other["date"]
        cmp = self["path"] <=> other["path"] if cmp.nil? || cmp.zero?
        cmp
      end

      def previous
        @obj.previous_doc.to_liquid
      end

      def next
        @obj.next_doc.to_liquid
      end

      # Generate a Hash for use in generating JSON.
      # This is useful if fields need to be cleared before the JSON can generate.
      #
      # state - the JSON::State object which determines the state of current processing.
      #
      # Returns a Hash ready for JSON generation.
      def hash_for_json(state = nil)
        to_h.tap do |hash|
          if state && state.depth >= 2
            hash["previous"] = collapse_document(hash["previous"]) if hash["previous"]
            hash["next"]     = collapse_document(hash["next"]) if hash["next"]
          end
        end
      end

      # Generate a Hash which breaks the recursive chain.
      # Certain fields which are normally available are omitted.
      #
      # Returns a Hash with only non-recursive fields present.
      def collapse_document(doc)
        doc.keys.each_with_object({}) do |(key, _), result|
          result[key] = doc[key] unless NESTED_OBJECT_FIELD_BLACKLIST.include?(key)
        end
      end

      private
      def_delegator :@obj, :data, :fallback_data
    end
  end
end
