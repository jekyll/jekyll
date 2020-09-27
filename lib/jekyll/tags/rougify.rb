# frozen_string_literal: true

require "rouge"

module Jekyll
  module CustomRougeFormatters
    class LineTable < Rouge::Formatter
      def initialize(formatter, opts)
        @formatter    = formatter
        @start_line   = opts.fetch :start_line,   1
        @table_class  = opts.fetch :table_class,  "rouge-line-table"
        @gutter_class = opts.fetch :gutter_class, "rouge-gutter"
        @code_class   = opts.fetch :code_class,   "rouge-code"
        @line_class   = opts.fetch :line_class,   "lineno"
        @line_id      = opts.fetch :line_id,      "line-%i"
      end

      # rubocop:disable Style/FormatString
      def stream(tokens)
        lineno = @start_line - 1
        buffer = +""
        buffer << %(<table class="#{@table_class}"><tbody>)
        token_lines(tokens) do |line_tokens|
          lineno += 1
          buffer << %(<tr data-line-id="#{sprintf(@line_id, lineno)}" class="#{@line_class}">)
          buffer << %(<td class="#{@gutter_class} gl" )
          buffer << %(style="-moz-user-select: none;-ms-user-select: none;)
          buffer << %(-webkit-user-select: none;user-select: none;">)
          buffer << %(<pre>#{lineno}</pre></td>)
          buffer << %(<td class="#{@code_class}"><pre>)
          @formatter.stream(line_tokens) { |formatted| buffer << formatted }
          buffer << "\n</pre></td></tr>"
        end
        buffer << %(</tbody></table>)
        yield buffer
      end
      # rubocop:enable Style/FormatString
    end
  end

  module Tags
    class Rougify < Liquid::Block
      HTML_FORMATTER = Rouge::Formatters::HTML.new
      EMPTY_OPTIONS  = {}.freeze
      OPTIONS_SYNTAX = %r!
        ([\w-]+)\s*=\s*
        (?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w.-]+))
      !x.freeze

      private_constant :HTML_FORMATTER, :EMPTY_OPTIONS, :OPTIONS_SYNTAX

      def initialize(tag_name, markup, tokens)
        super

        @lang, @options = markup.strip.split(%r!\s+!, 2)
        @lang ||= "plaintext"
      end

      def render(context)
        code = super.to_s
        code.strip!

        prefix    = context["highlighter_prefix"] || ""
        suffix    = context["highlighter_suffix"] || ""
        options   = @options ? parse_options(context) : EMPTY_OPTIONS
        lexer     = Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
        body      = wrap_formatted(format_lexed(lexer.lex(code), options), options)

        "#{prefix}#{body}#{suffix}"
      end

      private

      def parse_options(context)
        {}.tap do |options|
          @options.scan(OPTIONS_SYNTAX) do |key, d_quoted, s_quoted, variable|
            value = if d_quoted
                      d_quoted.include?('\\"') ? d_quoted.gsub('\\"', '"') : d_quoted
                    elsif s_quoted
                      s_quoted.include?("\\'") ? s_quoted.gsub("\\'", "'") : s_quoted
                    elsif variable
                      context[variable]
                    end

            options[key.to_sym] = value
          end
        end
      end

      def format_lexed(lexed_code, options)
        linenos = options.key?(:linenos) && options.delete(:linenos)
        formatter = if linenos
                      CustomRougeFormatters::LineTable.new(HTML_FORMATTER, options)
                    else
                      HTML_FORMATTER
                    end
        result = formatter.format(lexed_code)
        return result if linenos

        %(<pre class="highlight"><code>#{result}</code></pre>)
      end

      def wrap_formatted(code, options)
        caption = options[:caption]

        buffer = +""
        buffer << %(<div class="language-#{@lang} highlighter-rouge">)
        buffer << %(<div class="code-block-lang">#{@lang}</div>) if options[:annotated]
        buffer << %(<div class="highlight">)
        buffer << code
        buffer << "</div>"
        buffer << %(<div class="code-block-caption">#{caption}</div>) if caption
        buffer << "</div>"
        buffer
      end
    end
  end
end

Liquid::Template.register_tag "rougify", Jekyll::Tags::Rougify
