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

        site.docs_to_write.each do |document|
          return document.url if document.relative_path == @relative_path
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
