module Jekyll
  module Tags
    class Link < Liquid::Tag
      TagName = 'link'

      def initialize(tag_name, relative_path, tokens)
        super

        @relative_path = relative_path.strip
      end

      def render(context)
        site = context.registers[:site]

        site.docs_to_write.each do |document|
          return document.url if document.relative_path == @relative_path
        end

        raise ArgumentError, "Could not find document '#{@relative_path}' in tag '#{TagName}'.\n\n" \
          "Make sure the document exists and the path is correct."
      end
    end
  end
end

Liquid::Template.register_tag(Jekyll::Tags::Link::TagName, Jekyll::Tags::Link)
