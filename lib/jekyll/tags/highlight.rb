module Jekyll
  
  class HighlightBlock < Liquid::Block
    include Liquid::StandardFilters
    # we need a language, but the linenos argument is optional.
    SYNTAX = /(\w+)\s?(:?linenos)?\s?/
    
    def initialize(tag_name, markup, tokens)
      super
      if markup =~ SYNTAX
        @lang = $1
        if defined? $2
          # additional options to pass to Albino.
          @options = { 'O' => 'linenos=inline' }
        else
          @options = {}
        end
      else
        raise SyntaxError.new("Syntax Error in 'highlight' - Valid syntax: highlight <lang> [linenos]")
      end
    end
  
    def render(context)
      if Jekyll.pygments
        render_pygments(context, super.to_s)
      else
        render_codehighlighter(context, super.to_s)
      end
    end
    
    def render_pygments(context, code)
      if Jekyll.content_type == :markdown
        return "\n" + Albino.new(code, @lang).to_s(@options) + "\n"
      else
        "<notextile>" + Albino.new(code, @lang).to_s(@options) + "</notextile>"
      end
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
  end
  
end

Liquid::Template.register_tag('highlight', Jekyll::HighlightBlock)
