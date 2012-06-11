module Jekyll

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
        @lang = $1
        if defined?($2) && $2 != ''
          tmp_options = {}
          $2.split.each do |opt|
            key, value = opt.split('=')
            if value.nil?
              if key == 'linenos'
                value = 'inline'
              else
                value = true
              end
            end
            tmp_options[key] = value
          end
          tmp_options = tmp_options.to_a.sort.collect { |opt| opt.join('=') }
          # additional options to pass to Albino
          @options = { 'O' => tmp_options.join(',') }
        else
          @options = {}
        end
      else
        raise SyntaxError.new("Syntax Error in 'highlight' - Valid syntax: highlight <lang> [linenos]")
      end
    end

    def render(context)
      if context.registers[:site].pygments
        render_pygments(context, super)
      else
        render_codehighlighter(context, super)
      end
    end

    def render_pygments(context, code)
      @options[:encoding] = 'utf-8'

      output = add_code_tags(
        Pygments.highlight(code, :lexer => @lang, :options => @options),
        @lang
      )

      output = context["pygments_prefix"] + output if context["pygments_prefix"]
      output = output + context["pygments_suffix"] if context["pygments_suffix"]
      output
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

Liquid::Template.register_tag('highlight', Jekyll::HighlightBlock)
