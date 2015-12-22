# encoding: UTF-8

module Jekyll
  module Drops
    class SiteDrop < ImmutableDrop
      extend Forwardable

      def_delegator  :@obj, :site_data, :data
      def_delegators :@obj, :time, :pages, :static_files, :documents

      def posts
        @site_posts ||= @obj.posts.docs.sort { |a, b| b <=> a }
      end

      def html_pages
        @site_html_pages ||= @obj.pages.select { |page| page.html? || page.url.end_with?("/") }
      end

      def categories
        @site_categories ||= @obj.post_attr_hash('categories')
      end

      def tags
        @site_tags ||= @obj.post_attr_hash('tags')
      end

      def collections
        @site_collections ||= @obj.collections.values.map(&:to_liquid)
      end

      private
      def data
        @obj.config
      end

    end
  end
end
