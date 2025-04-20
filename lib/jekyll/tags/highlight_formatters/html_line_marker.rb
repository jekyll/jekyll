# frozen_string_literal: true

module Jekyll
  module HighlightTagFormatters
    class HTMLLineMarker < Rouge::Formatter
      def initialize(delegate, opts = {})
        @delegate = delegate
        @mark_line_class = opts.fetch(:mark_line_class, "hll")
        @mark_lines      = opts.fetch(:mark_lines, [])
      end

      def stream(tokens)
        token_lines(tokens).with_index(1) do |line_tokens, lineno|
          line = %(#{@delegate.format(line_tokens)}\n)
          line = %(<div class="#{@mark_line_class}">#{line}</div>) if @mark_lines.include?(lineno)
          yield line
        end
      end
    end
  end
end
