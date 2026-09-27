# frozen_string_literal: true

module Jekyll
  module Tags
    class Link < Liquid::Tag
      include Jekyll::Filters::URLFilters

      class << self
        def tag_name
          name.split("::").last.downcase
        end
      end

      def initialize(tag_name, relative_path, tokens)
        super

        @relative_path = relative_path.strip
        @rendered_cache = {}
      end

      def render(context)
        @context = context
        site = context.registers[:site]
        relative_path = Liquid::Template.parse(@relative_path).render(context)

        # Return cached result if available
        return @rendered_cache[relative_path] if @rendered_cache&.key?(relative_path)

        relative_path_with_leading_slash = PathManager.join("", relative_path)

        site.each_site_file do |item|
          next unless item.relative_path == relative_path ||
            item.relative_path == relative_path_with_leading_slash

          @rendered_cache[relative_path] = relative_url(item)
          return @rendered_cache[relative_path]
        end

        raise ArgumentError, <<~MSG
          Could not find document '#{relative_path}' in tag '#{self.class.tag_name}'.

          Make sure the document exists and the path is correct.
        MSG
      end
    end
  end
end

Liquid::Template.register_tag(Jekyll::Tags::Link.tag_name, Jekyll::Tags::Link)
