module Jekyll
  module Tags
    class HighlightBlock < Liquid::Block
      include Liquid::StandardFilters

      # The regular expression syntax checker. Start with the language specifier.
      # Follow that by zero or more space separated options that take one of three
      # forms: name, name=value, or name="<quoted list>"
      #
      # <quoted list> is a space-separated list of numbers
      SYNTAX = /^([a-zA-Z0-9.+#-]+)((\s+\w+(=(\w+|"([0-9]+\s)*[0-9]+"))?)*)$/

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          @lang = Regexp.last_match(1).downcase
          @highlight_options = {}
          if defined?(Regexp.last_match(2)) && Regexp.last_match(2) != ''
            # Split along 3 possible forms -- key="<quoted list>", key=value, or key
            Regexp.last_match(2).scan(/(?:\w="[^"]*"|\w=\w|\w)+/) do |opt|
              key, value = opt.split('=')
              # If a quoted list, convert to array
              if value && value.include?("\"")
                value.delete!('"')
                  value = value.split
              end
              @highlight_options[key.to_sym] = value || true
            end
          end
          @highlight_options[:linenos] = "inline" if @highlight_options.key?(:linenos) && @highlight_options[:linenos] == true
        else
          raise SyntaxError.new <<-eos
Syntax Error in tag 'highlight' while parsing the following markup:

  #{markup}

Valid syntax: highlight <lang> [linenos]
eos
        end
      end

      def render(context)
        prefix = context["highlighter_prefix"] || ""
        suffix = context["highlighter_suffix"] || ""
        code = super.to_s.gsub(/\A(\n|\r)+|(\n|\r)+\z/, '')

        is_safe = !!context.registers[:site].safe

        output =
          case context.registers[:site].highlighter
          when 'pygments'
            render_pygments(code, is_safe)
          when 'rouge'
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
            [:encoding,    opts.fetch(:encoding, 'utf-8')],
            [:cssclass,    opts.fetch(:cssclass, nil)]
          ].reject { |f| f.last.nil? }]
        else
          opts
        end
      end

      def render_pygments(code, is_safe)
        Jekyll::External.require_with_graceful_fail('pygments')

        highlighted_code = Pygments.highlight(
          code,
          :lexer   => @lang,
          :options => sanitized_opts(@highlight_options, is_safe)
        )

        if highlighted_code.nil?
          Jekyll.logger.error "There was an error highlighting your code:"
          puts
          Jekyll.logger.error code
          puts
          Jekyll.logger.error "While attempting to convert the above code, Pygments.rb" \
            " returned an unacceptable value."
          Jekyll.logger.error "This is usually a timeout problem solved by running `jekyll build` again."
          raise ArgumentError.new("Pygments.rb returned an unacceptable value when attempting to highlight some code.")
        end

        highlighted_code.sub('<div class="highlight"><pre>', '').sub('</pre></div>', '')
      end

      def render_rouge(code)
        Jekyll::External.require_with_graceful_fail('rouge')
        formatter = Rouge::Formatters::HTML.new(:line_numbers => @highlight_options[:linenos], :wrap => false)
        lexer = Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
        formatter.format(lexer.lex(code))
      end

      def render_codehighlighter(code)
        h(code).strip
      end

      def add_code_tag(code)
        code_attributes = [
          "class=\"language-#{@lang.to_s.tr('+', '-')}\"",
          "data-lang=\"#{@lang}\""
        ].join(" ")
        "<figure class=\"highlight\"><pre><code #{code_attributes}>#{code.chomp}</code></pre></figure>"
      end
    end
  end
end

Liquid::Template.register_tag('highlight', Jekyll::Tags::HighlightBlock)
