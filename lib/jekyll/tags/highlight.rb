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
      SYNTAX = %r!^([a-zA-Z0-9.+#_-]+)((\s+\w+(=(\w+|"([0-9]+\s)*[0-9]+"))?)*)$!

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          @lang = Regexp.last_match(1).downcase
          @highlight_options = parse_options(Regexp.last_match(2))
        else
          raise SyntaxError, <<-MSG
Syntax Error in tag 'highlight' while parsing the following markup:

  #{markup}

Valid syntax: highlight <lang> [linenos]
MSG
        end
      end

      def render(context)
        prefix = context["highlighter_prefix"] || ""
        suffix = context["highlighter_suffix"] || ""
        code = super.to_s.gsub(%r!\A(\n|\r)+|(\n|\r)+\z!, "")

        is_safe = !!context.registers[:site].safe

        output =
          case context.registers[:site].highlighter
          when "pygments"
            render_pygments(code, is_safe)
          when "rouge"
            render_rouge(code)
          else
            render_codehighlighter(code)
          end

        rendered_output = add_code_tag(output)
        prefix + rendered_output + suffix
      end

      def sanitized_opts(opts, is_safe)
        if is_safe
          Hash[[
            [:startinline, opts.fetch(:startinline, nil)],
            [:hl_lines,    opts.fetch(:hl_lines, nil)],
            [:linenos,     opts.fetch(:linenos, nil)],
            [:encoding,    opts.fetch(:encoding, "utf-8")],
            [:cssclass,    opts.fetch(:cssclass, nil)],
          ].reject { |f| f.last.nil? }]
        else
          opts
        end
      end

      private

      def parse_options(input)
        options = {}
        unless input.empty?
          # Split along 3 possible forms -- key="<quoted list>", key=value, or key
          input.scan(%r!(?:\w="[^"]*"|\w=\w|\w)+!) do |opt|
            key, value = opt.split("=")
            # If a quoted list, convert to array
            if value && value.include?("\"")
              value.delete!('"')
              value = value.split
            end
            options[key.to_sym] = value || true
          end
        end
        if options.key?(:linenos) && options[:linenos] == true
          options[:linenos] = "inline"
        end
        options
      end

      def render_pygments(code, is_safe)
        Jekyll::External.require_with_graceful_fail("pygments") unless defined?(Pygments)

        highlighted_code = Pygments.highlight(
          code,
          :lexer   => @lang,
          :options => sanitized_opts(@highlight_options, is_safe)
        )

        if highlighted_code.nil?
          Jekyll.logger.error <<-MSG
There was an error highlighting your code:

#{code}

While attempting to convert the above code, Pygments.rb returned an unacceptable value.
This is usually a timeout problem solved by running `jekyll build` again.
MSG
          raise ArgumentError, "Pygments.rb returned an unacceptable value "\
          "when attempting to highlight some code."
        end

        highlighted_code.sub('<div class="highlight"><pre>', "").sub("</pre></div>", "")
      end

      def render_rouge(code)
        formatter = Jekyll::Utils::Rouge.html_formatter(
          :line_numbers => @highlight_options[:linenos],
          :wrap         => false,
          :css_class    => "highlight",
          :gutter_class => "gutter",
          :code_class   => "code"
        )
        lexer = ::Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
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
