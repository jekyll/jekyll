# frozen_string_literal: true

module Jekyll
  module Tags
    class Link < Liquid::Tag
      VARIABLE_SYNTAX = %r!
        (?<variable>[^{]*(\{\{\s*[\w\-\.]+\s*(\|.*)?\}\}[^\s{}]*)+)
      !x

      class << self
        def tag_name
          self.name.split("::").last.downcase
        end
      end

      def initialize(tag_name, relative_path, tokens)
        super
        matched = relative_path.strip.match(VARIABLE_SYNTAX)
        if matched
          @relative_path = matched["variable"].strip
        else
          @relative_path = relative_path.strip
        end
      end

      def render_variable(context)
        if @relative_path.match(VARIABLE_SYNTAX)
          partial = context.registers[:site]
            .liquid_renderer
            .file("(variable)")
            .parse(@relative_path)
          partial.render!(context)
        end
      end

      def render(context)
        site = context.registers[:site]

        relative_path = render_variable(context) || @relative_path

        site.each_site_file do |item|
          return item.url if item.relative_path == relative_path
          # This takes care of the case for static files that have a leading /
          return item.url if item.relative_path == "/#{relative_path}"
        end

        raise ArgumentError, <<-MSG
Could not find document '#{relative_path}' in tag '#{self.class.tag_name}'.

Make sure the document exists and the path is correct.
MSG
      end
    end
  end
end

Liquid::Template.register_tag(Jekyll::Tags::Link.tag_name, Jekyll::Tags::Link)
