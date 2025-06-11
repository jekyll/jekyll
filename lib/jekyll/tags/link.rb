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
      end

      def render(context)
        # Return cached result if already rendered for this context
        return @rendered_value if @rendered_value && @cached_context == context

        @context = context
        @cached_context = context
        site = context.registers[:site]
        relative_path = Liquid::Template.parse(@relative_path).render(context)
        relative_path_with_leading_slash = PathManager.join("", relative_path)

        site.each_site_file do |item|
          @rendered_value = relative_url(item) if item.relative_path == relative_path
          return @rendered_value if @rendered_value
          # This takes care of the case for static files that have a leading /
          @rendered_value = relative_url(item) if item.relative_path == relative_path_with_leading_slash
          return @rendered_value if @rendered_value
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
