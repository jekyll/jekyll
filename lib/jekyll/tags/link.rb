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

        @tokens        = tokens
        @relative_path = relative_path.strip
      end

      def render(context)
        site = context.registers[:site]

        site.each_site_file do |item|
          template = Liquid::Variable.new("'#{item.url}' | relative_url", @tokens)
          return template.render(context) if item.relative_path == @relative_path
          # This takes care of the case for static files that have a leading /
          return template.render(context) if item.relative_path == "/#{@relative_path}"
        end

        raise ArgumentError, <<-MSG
Could not find document '#{@relative_path}' in tag '#{self.class.tag_name}'.

Make sure the document exists and the path is correct.
MSG
      end
    end
  end
end

Liquid::Template.register_tag(Jekyll::Tags::Link.tag_name, Jekyll::Tags::Link)
