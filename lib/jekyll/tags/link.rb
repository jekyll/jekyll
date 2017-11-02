# frozen_string_literal: true

module Jekyll
  module Tags
    class Link < Liquid::Tag
      # TODO: Remove singleton class in v4.0
      class << self
        def tag_name
          self.name.split("::").last.downcase
        end
      end

      def initialize(tag_name, relative_path, tokens)
        super
        @relative_path = relative_path.strip
      end

      def render(context)
        # additionally handle static files, that have a leading `/`
        valid_paths = [@relative_path, "/#{@relative_path}"]
        site = context.registers[:site]

        site.each_site_file do |item|
          # return `item.url` if `item.relative_path` equals either
          # @relative path or @relative_path with a leading slash.
          return item.url if valid_paths.include?(item.relative_path)
        end

        raise ArgumentError, <<-MSG
Could not find document '#{@relative_path}' in tag 'link'.

Make sure the document exists and the path is correct.
MSG
      end
    end
  end
end

Liquid::Template.register_tag("link", Jekyll::Tags::Link)
