module Jekyll
  module Tags
    class HighlightBlock < Liquid::Block
      include Liquid::StandardFilters

      # The regular expression syntax checker. Start with the language specifier.
      # Follow that by zero or more space separated options that take one of two
      # forms:
      #
      # 1. name
      # 2. name=value
      SYNTAX = /^([a-zA-Z0-9.+#-]+)((\s+\w+(=\w+)?)*)$/

      def initialize(tag_name, markup, tokens)
        super
        if markup.strip =~ SYNTAX
          @lang = $1.downcase
          @options = {}
          if defined?($2) && $2 != ''
            $2.split.each do |opt|
              key, value = opt.split('=')
              if value.nil?
                if key == 'linenos'
                  value = 'inline'
                else
                  value = true
                end
              end
              @options[key] = value
            end
          end
        else
          raise SyntaxError.new <<-eos
Syntax Error in tag 'highlight' while parsing the following markup:

  #{markup}

Valid syntax: highlight <lang> [linenos]
eos
        end
      end

      def render(context)
        case context.registers[:site].highlighter
        when 'pygments'
          render_pygments(context, super)
        when 'rouge'
          render_rouge(context, super)
        else
          render_codehighlighter(context, super)
        end
      end

      def render_pygments(context, code)
        require 'pygments'

        @options[:encoding] = 'utf-8'

        output = add_code_tags(
          Pygments.highlight(code, :lexer => @lang, :options => @options),
          @lang
        )

        output = context["highlighter_prefix"] + output if context["highlighter_prefix"]
        output << context["highlighter_suffix"] if context["highlighter_suffix"]

        return output
      end

      def render_rouge(context, code)
        require 'rouge'

        linenos = @options.keys.include?('linenos')
        lexer = Rouge::Lexer.find_fancy(@lang, code) || Rouge::Lexers::PlainText
        formatter = Rouge::Formatters::HTML.new(line_numbers: linenos)

        output = context["highlighter_prefix"] || ""
        output << "<div class=\"highlight\">"
        output << add_code_tags(formatter.render(lexer.lex(code)), @lang)
        output << "</div>"
        output << context["highlighter_suffix"] if context["highlighter_suffix"]

        return output
      end

      def render_codehighlighter(context, code)
        #The div is required because RDiscount blows ass
        <<-HTML
  <div>
    <pre><code class='#{@lang}'>#{h(code).strip}</code></pre>
  </div>
        HTML
      end

      def add_code_tags(code, lang)
        # Add nested <code> tags to code blocks
        code = code.sub(/<pre>/,'<pre><code class="' + lang + '">')
        code = code.sub(/<\/pre>/,"</code></pre>")
      end

    end
  end
end

Liquid::Template.register_tag('highlight', Jekyll::Tags::HighlightBlock)
