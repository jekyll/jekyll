# frozen_string_literal: true

module Jekyll
  module Tags
    class Link < Liquid::Tag
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
        site = context.registers[:site]

        site.each_site_file do |item|
          return item.url if item.relative_path == @relative_path
          # This takes care of the case for static files that have a leading /
          return item.url if item.relative_path == "/#{@relative_path}"
        end

        raise ArgumentError, <<eos
Could not find document '#{@relative_path}' in tag '#{self.class.tag_name}'.

Make sure the document exists and the path is correct.
eos
      end
    end
  end
end

Liquid::Template.register_tag(Jekyll::Tags::Link.tag_name, Jekyll::Tags::Link)
