# frozen_string_literal: true

module Jekyll
  module Drops
    class SiteDrop < Drop
      extend Forwardable

      mutable false

      delegate_method_as :site_data, :data
      delegate_methods :time, :pages, :static_files, :tags, :categories

      private delegate_method_as :config, :fallback_data

      def [](key)
        if key != "posts" && @obj.collections.key?(key)
          @obj.collections[key].docs
        else
          super(key)
        end
      end

      def key?(key)
        (key != "posts" && @obj.collections.key?(key)) || super
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

      # `Site#documents` cannot be memoized so that `Site#docs_to_write` can access the
      # latest state of the attribute.
      #
      # Since this method will be called after `Site#pre_render` hook, the `Site#documents`
      # array shouldn't thereafter change and can therefore be safely memoized to prevent
      # additional computation of `Site#documents`.
      def documents
        @documents ||= @obj.documents
      end

      # `{{ site.related_posts }}` is how posts can get posts related to
      # them, either through LSI if it's enabled, or through the most
      # recent posts.
      # We should remove this in 4.0 and switch to `{{ post.related_posts }}`.
      def related_posts
        return nil unless @current_document.is_a?(Jekyll::Document)

        @current_document.related_posts
      end
      attr_writer :current_document

      # return nil for `{{ site.config }}` even if --config was passed via CLI
      def config; end
    end
  end
end
