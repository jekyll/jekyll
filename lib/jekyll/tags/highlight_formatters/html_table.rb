# frozen_string_literal: true

module Jekyll
  module HighlightTagFormatters
    class HTMLTable < Rouge::Formatter
      def initialize(delegate, **opts)
        @delegate = delegate
        @start_line   = opts.fetch(:start_line, 1)
        @line_format  = opts.fetch(:line_format, "%i")
        @table_class  = opts.fetch(:table_class, "rouge-table")
        @gutter_class = opts.fetch(:gutter_class, "gutter")
        @code_class   = opts.fetch(:code_class, "code")
      end

      def style(scope)
        yield %(#{scope} .rouge-table { border-spacing: 0 })
      end

      # rubocop:disable Metrics/AbcSize, Style/FormatString

      def stream(tokens)
        last_val = nil
        num_lines = tokens.reduce(0) { |count, (_, val)| count + (last_val = val).count("\n") }
        formatted = @delegate.format(tokens)
        unless last_val&.end_with?("\n")
          num_lines += 1
          formatted << "\n"
        end

        # generate a string of newline-separated line numbers for the gutter>
        formatted_line_numbers = (@start_line..(@start_line + num_lines - 1)).map do |i|
          sprintf(@line_format, i)
        end.join("\n") << "\n"

        buffer = [%(<table class="#{@table_class}"><tbody><tr>)]
        buffer << %(<td class="#{@gutter_class} gl">) # "gl" class => Generic.Lineno token
        buffer << %(<pre class="lineno">#{formatted_line_numbers}</pre>)
        buffer << %(</td><td class="#{@code_class}"><pre>)
        buffer << formatted.gsub(%r!\n+$!, "\n") # prevent multiple trailing newlines
        buffer << "</pre></td>"
        buffer << "</tr></tbody></table>"

        yield buffer.join
      end

      # rubocop:enable Metrics/AbcSize, Style/FormatString
    end
  end
end
