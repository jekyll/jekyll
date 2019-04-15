# frozen_string_literal: true

module Jekyll
  module Drops
    class UnifiedPayloadDrop < Drop
      mutable true

      attr_reader :page, :layout, :content, :paginator
      attr_reader :highlighter_prefix, :highlighter_suffix

      def jekyll
        JekyllDrop.global
      end

      def site
        @site_drop ||= SiteDrop.new(@obj)
      end

      private

      def fallback_data
        @fallback_data ||= {}
      end
    end
  end
end
