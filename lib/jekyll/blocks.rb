module Jekyll
  class Highlight < Liquid::Block
    include Liquid::StandardFilters
    
    def initialize(tag_name, lang, tokens)
      super
      @lang = lang.strip
    end
  
    def render(context)
      "<pre class='syntax-highlight:#{@lang}'>#{escape(super)}</pre>"
    end    
  end
end
Liquid::Template.register_tag('highlight', Jekyll::Highlight)