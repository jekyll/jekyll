module Jekyll
  
  class IncludeTag < Liquid::Tag
    def initialize(tag_name, file, tokens)
      super
      @file = file.strip
    end
    
    def render(context)
      File.read(File.join(Jekyll.source, '_includes', @file))
    end
  end
  
end

Liquid::Template.register_tag('include', Jekyll::IncludeTag)