module Jekyll
  module Tags
    class Link < Liquid::Tag
      TAG_NAME = "link".freeze

      def initialize(tag_name, relative_path, tokens)
        super

        @relative_path = relative_path.strip
      end

      def render(context)
        site = context.registers[:site]

        site.docs_to_write.each do |document|
          return document.url if document.relative_path == @relative_path
        end

        raise ArgumentError, <<eos
Could not find document '#{@relative_path}' in tag '#{TAG_NAME}'.

Make sure the document exists and the path is correct.
eos
      end
    end
  end
end

Liquid::Template.register_tag(Jekyll::Tags::Link::TAG_NAME, Jekyll::Tags::Link)
