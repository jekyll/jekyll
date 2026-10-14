# frozen_string_literal: true

module Jekyll
  module Tags
    class RelativeLink < Liquid::Tag
      include Jekyll::Filters::URLFilters

      class << self
        def tag_name
          "relative_link"
        end
      end

      def initialize(tag_name, relative_path, tokens)
        super

        @relative_path = relative_path.strip
      end

      def dir(url)
        url.end_with?("/") ? Pathname(url) : Pathname(url).parent
      end

      def relativize_url(item)
        page_dir = dir(@context.registers[:page]["url"].to_s)
        site_relative_url = relative_url(item)
        Pathname(site_relative_url).relative_path_from(page_dir).to_s
      end

      def render(context)
        @context = context
        site = context.registers[:site]
        relative_path = Liquid::Template.parse(@relative_path).render(context)
        relative_path_with_leading_slash = PathManager.join("", relative_path)

        site.each_site_file do |item|
          return relativize_url(item) if item.relative_path == relative_path
          # This takes care of the case for static files that have a leading /
          return relativize_url(item) if item.relative_path == relative_path_with_leading_slash
        end

        raise ArgumentError, <<~MSG
          Could not find document '#{relative_path}' in tag '#{self.class.tag_name}'.

          Make sure the document exists and the path is correct.
        MSG
      end
    end
  end
end

Liquid::Template.register_tag(Jekyll::Tags::RelativeLink.tag_name, Jekyll::Tags::RelativeLink)
