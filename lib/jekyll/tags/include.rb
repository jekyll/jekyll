module Jekyll
  
  class IncludeTag < Liquid::Tag
    def initialize(tag_name, file, tokens)
      super
      @file = file.strip
    end
    
    def render(context)
      if @file !~ /^[a-zA-Z0-9_\/\.-]+$/ || @file =~ /\.\// || @file =~ /\/\./
        return "Include file '#{@file}' contains invalid characters or sequences"
      end
      
      Dir.chdir(File.join(Jekyll.source, '_includes')) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(@file)
          File.read(@file)
        else
          "Included file '#{@file}' not found in _includes directory"
        end
      end
    end
  end
  
end

Liquid::Template.register_tag('include', Jekyll::IncludeTag)