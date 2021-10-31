# frozen_string_literal: true

module Jekyll
  module Tags
    class SnippetTag < Liquid::Tag
      def initialize(tag_name, markup, options)
        super

        @relative_path = Liquid::Variable.new(markup.strip, options)
      end

      def render(context)
        @site ||= context.registers[:site]
        relative_path = @relative_path&.render(context)
        snippet = @site.snippets[relative_path]

        return (snippet.output || "") if snippet

        Jekyll.logger.warn "Snippet: #{relative_path.inspect} not found."
        ""
      end
    end

    Liquid::Template.register_tag "snippet", SnippetTag
  end
end
