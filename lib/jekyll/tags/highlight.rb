# frozen_string_literal: true

module Jekyll
  module Tags
    class HighlightBlock < Liquid::Block
      include Liquid::StandardFilters

      # The regular expression syntax checker. Start with the language specifier.
      # Follow that by zero or more space separated options that take one of three
      # forms: name, name=value, or name="<quoted list>"
      #
      # <quoted list> is a space-separated list of numbers
      # 
      # Both the language specifier and the options can be passed as liquid variables
      LANG_SYNTAX = %r![a-zA-Z0-9.+#_-]+!.freeze
      OPTIONS_SYNTAX = %r!(\s+\w+(=(\w+|"([0-9]+\s)*[0-9]+"))?)*!.freeze
      SYNTAX = %r!^((?<lang_var>\{\{[ ]*((\w+[.])*(lang))[ ]*\}\})|(?<lang>#{LANG_SYNTAX}))?[ ]*((?<params_var>\{\{[ ]*(\w+([.]\w+)*)[ ]*\}\})|(?<params>#{OPTIONS_SYNTAX}))$!.freeze

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          matched = Regexp.last_match
          puts matched[0]
          
          if matched["lang_var"]
            @lang = matched["lang_var"].strip
          elsif matched["lang"]
            @lang = matched["lang"].strip.downcase
          else
            @lang = ""
          end

          if matched["params_var"]
            @highlight_options = matched["params_var"].strip
          elsif matched["params"]
            @highlight_options = parse_options(matched["params"].strip)
          else
            @highlight_options = parse_options()
          end

        else
          raise SyntaxError, <<~MSG
            Syntax Error in tag '#{tag_name}' while parsing the following markup:

            #{markup}

            Valid syntax: #{tag_name} [lang] [linenos]
                      \tOR: #{tag_name} [{{ lang_variable }}] [linenos]
                      \tOR: #{tag_name} [lang] [{{ linenos_variable(s) }}]
                      \tOR: #{tag_name} [{{ lang_variable }}] [{{ linenos_variable(s) }}]
          MSG
        end
      end

      LEADING_OR_TRAILING_LINE_TERMINATORS = %r!\A(\n|\r)+|(\n|\r)+\z!.freeze
      VARIABLE_SYNTAX = %r![^{]*(\{\{\s*[\w\-.]+\s*(\|.*)?\}\}[^\s{}]*)+!.freeze
      
      def render(context)
        prefix = context["highlighter_prefix"] || ""
        suffix = context["highlighter_suffix"] || ""
        code = super.to_s.gsub(LEADING_OR_TRAILING_LINE_TERMINATORS, "")

        if VARIABLE_SYNTAX.match?(@highlight_options.to_s)
          @highlight_options = parse_options(context[@highlight_options])
        end
        
        output =
          case context.registers[:site].highlighter
          when "rouge"
            render_rouge(code, context)
          when "pygments"
            render_pygments(code, context)
          else
            render_codehighlighter(code)
          end

        rendered_output = add_code_tag(output)
        prefix + rendered_output + suffix
      end

      private

      OPTIONS_REGEX = %r!(?:\w="[^"]*"|\w=\w|\w)+!.freeze

      def parse_options(input)
        options = {}
        return options if input.nil?

        # Split along 3 possible forms -- key="<quoted list>", key=value, or key
        input.scan(OPTIONS_REGEX) do |opt|
          key, value = opt.split("=")
          # If a quoted list, convert to array
          if value&.include?('"')
            value.delete!('"')
            value = value.split
          end
          options[key.to_sym] = value || true
        end

        options[:linenos] = "inline" if options[:linenos] == true
        options
      end

      def render_pygments(code, _context)
        Jekyll.logger.warn "Warning:", "Highlight Tag no longer supports rendering with Pygments."
        Jekyll.logger.warn "", "Using the default highlighter, Rouge, instead."
        render_rouge(code, _context)
      end

      def render_rouge(code, _context)
        require "rouge"
        formatter = ::Rouge::Formatters::HTMLLegacy.new(
          :line_numbers => @highlight_options[:linenos],
          :wrap         => false,
          :css_class    => "highlight",
          :gutter_class => "gutter",
          :code_class   => "code"
        )
        
        if VARIABLE_SYNTAX.match?(@lang)
          @lang = _context[@lang].downcase.strip
          lexer = ::Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
        elsif LANG_SYNTAX.match?(@lang)
          lexer = ::Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
        else
          lexer = Rouge::Lexers::PlainText
        end
        puts lexer
        formatter.format(lexer.lex(code))
      end

      def render_codehighlighter(code)
        h(code).strip
      end

      def add_code_tag(code)
        code_attributes = [
          "class=\"language-#{@lang.to_s.tr("+", "-")}\"",
          "data-lang=\"#{@lang}\"",
        ].join(" ")
        "<figure class=\"highlight\"><pre><code #{code_attributes}>"\
        "#{code.chomp}</code></pre></figure>"
      end
    end
  end
end

Liquid::Template.register_tag("highlight", Jekyll::Tags::HighlightBlock)
