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

        if snippet
          add_as_dependency(snippet, context) if @site.config["incremental"]
          return snippet.output
        end

        Jekyll.logger.warn "Snippet: #{relative_path.inspect} not found."
        ""
      end

      private

      def add_as_dependency(snippet, context)
        page = context.registers[:page]
        return unless page&.key?("path")

        absolute_path = \
          if page["collection"]
            @site.in_source_dir(@site.config["collections_dir"], page["path"])
          else
            @site.in_source_dir(page["path"])
          end

        @site.regenerator.add_dependency(absolute_path, snippet.path)
      end
    end

    Liquid::Template.register_tag "snippet", SnippetTag
  end
end
