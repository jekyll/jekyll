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
        relative_path = Liquid::Template.parse(@relative_path).render(context)

        # This takes care of the case for static files that have a leading `/`.
        relative_path_with_leading_slash = PathManager.join("", relative_path)

        registry = Jekyll::Tags::Link.instance_variable_get(:@registry) || {}

        registry[relative_path] || \
          registry[relative_path_with_leading_slash] || \
          raise(ArgumentError, <<~MSG)
            Could not find resource '#{relative_path}' in tag '#{self.class.tag_name}'.
            Make sure the resource exists and the path is correct.
          MSG
      end
    end
  end
end

Liquid::Template.register_tag(Jekyll::Tags::Link.tag_name, Jekyll::Tags::Link)
