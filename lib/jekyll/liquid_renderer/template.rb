# frozen_string_literal: true

require_relative "file"

module Jekyll
  class LiquidRenderer
    class Template < File
      def initialize(renderer, filename)
        @renderer = renderer
        @filename = filename
      end

      def parse(content)
        @renderer.cache[@filename] ||= Liquid::Template.parse(content, :line_numbers => true)
        @template = @renderer.cache[@filename]

        self
      end

      def render(*args)
        reset_template_assigns
        @template.render(*args)
      end

      # This method simply 'rethrows any error' before attempting to render the template.
      def render!(*args)
        reset_template_assigns
        @template.render!(*args)
      end
    end
  end
end
