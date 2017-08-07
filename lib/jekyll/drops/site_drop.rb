# encoding: UTF-8
# frozen_string_literal: true

module Jekyll
  module Drops
    class SiteDrop < Drop
      extend Forwardable

      mutable false

      def_delegator  :@obj, :site_data, :data
      def_delegators :@obj, :time, :pages, :static_files, :documents,
                            :tags, :categories

      def [](key)
        if @obj.collections.key?(key) && key != "posts"
          @obj.collections[key].docs
        else
          super(key)
        end
      end

      def key?(key)
        (@obj.collections.key?(key) && key != "posts") || super
      end

      def posts
        @site_posts ||= @obj.posts.docs.sort { |a, b| b <=> a }
      end

      def html_pages
        @site_html_pages ||= @obj.pages.select do |page|
          page.html? || page.url.end_with?("/")
        end
      end

      def collections
        @site_collections ||= @obj.collections.values.sort_by(&:label).map(&:to_liquid)
      end

      # return nil for `{{ site.config }}` even if --config was passed via CLI
      def config; end

      private
      def_delegator :@obj, :config, :fallback_data
    end
  end
end
