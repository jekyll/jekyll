# encoding: UTF-8

module Jekyll
  module Drops
    class UnifiedPayloadDrop < Liquid::Drop

      attr_accessor :page, :layout, :content, :paginator
      attr_accessor :highlighter_prefix, :highlighter_suffix

      def initialize(site)
        @site = site
      end

      def jekyll
        JekyllDrop.global
      end

      def site
        @site_drop ||= SiteDrop.new(@site)
      end

    end
  end
end
