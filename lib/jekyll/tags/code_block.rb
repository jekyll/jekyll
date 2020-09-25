# frozen_string_literal: true

require "rouge"

module Jekyll
  module Tags
    class CodeBlock < Liquid::Block
      EMPTY_OPTIONS  = {}.freeze
      HTML_FORMATTER = Rouge::Formatters::HTML.new
      MARKUP_SYNTAX  = %r!\s*([\w-]+)(?:\s+(.*?))?\s+(annotated)?!.freeze
      OPTIONS_SYNTAX = %r!
        ([\w-]+)\s*=\s*
        (?:"([^"\\]*(?:\\.[^"\\]*)*)"|'([^'\\]*(?:\\.[^'\\]*)*)'|([\w.-]+))
      !x.freeze

      private_constant :HTML_FORMATTER, :MARKUP_SYNTAX, :EMPTY_OPTIONS, :OPTIONS_SYNTAX

      def initialize(tag_name, markup, tokens)
        super

        if markup =~ MARKUP_SYNTAX
          @lang, @options, @annotated = Regexp.last_match.captures
        else
          @lang = "plaintext"
          @options = nil
          @annotated = nil
        end
      end

      def render(context)
        code = super.to_s
        code.strip!

        prefix    = context["highlighter_prefix"] || ""
        suffix    = context["highlighter_suffix"] || ""
        options   = @options ? parse_options(context) : EMPTY_OPTIONS
        formatter = Rouge::Formatters::HTMLLineTable.new(HTML_FORMATTER, options)
        lexer     = Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
        body      = wrap_formatted(formatter.format(lexer.lex(code)), options[:caption])

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

      def wrap_formatted(code, caption)
        buffer = +""
        buffer << %(<div class="highlighter language-#{@lang} highlighter-rouge">)
        buffer << %(  <div data-code-block-lang="#{@lang}">#{code}</div>) if @annotated
        buffer << code
        buffer << %(  <div class="code-block-caption">#{caption}</div>) if caption
        buffer << "</div>"
        buffer
      end
    end
  end
end

Liquid::Template.register_tag "codeblock", Jekyll::Tags::CodeBlock
