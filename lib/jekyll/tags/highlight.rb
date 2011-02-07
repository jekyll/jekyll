module Jekyll

  class HighlightBlock < Liquid::Block
    include Liquid::StandardFilters

    # we need a language, but the linenos argument is optional.
    SYNTAX = /([\w+]+)\s?([\w\s=]+)*/

    def initialize(tag_name, markup, tokens)
      super
      if markup =~ SYNTAX
        @lang = $1
        if defined? $2
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
          tmp_options = tmp_options.to_a.collect { |opt| opt.join('=') }
          # additional options to pass to Albino.
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
        render_pygments(context, super.join)
      else
        render_codehighlighter(context, super.join)
      end
    end

    def render_pygments(context, code)
      output = add_code_tags(Albino.new(code, @lang).to_s(@options), @lang)
      output = context["pygments_prefix"] + output if context["pygments_prefix"]
      output = output + context["pygments_suffix"] if context["pygments_suffix"]
      output
    end

    def render_codehighlighter(context, code)
    #The div is required because RDiscount blows ass
      <<-HTML
<div>
  <pre>
    <code class='#{@lang}'>#{h(code).strip}</code>
  </pre>
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
