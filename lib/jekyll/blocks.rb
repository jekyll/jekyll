module Jekyll
  class Highlight < Liquid::Block
    include Liquid::StandardFilters
    
    def initialize(tag_name, lang, tokens)
      super
      @lang = lang.strip
    end
  
    def render(context)
      #The div is required because RDiscount blows ass
      <<-HTML
<div>
  <pre>
    <code class='#{@lang}'>#{h(super.to_s).strip}</code>
  </pre>
</div>
      HTML
    end    
  end
end
Liquid::Template.register_tag('highlight', Jekyll::Highlight)