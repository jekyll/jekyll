module Jekyll

  class StylesheetTag < Liquid::Tag
    def initialize(tag_name, file, tokens)
      super
      @file = file
    end

    def find_stylesheet(context)
      file = @file
      file.strip!
      file.gsub! /^["']/, ""
      file.gsub! /["']$/, ""
      if ! file =~ /.[a-z]+$/
        file = "#{file}.css"
      end

      files = [File.join(context.registers[:site].source, @file),
               # strip a leading slash
               File.join(context.registers[:site].source, @file[1..-1]),
               ]
      files.each {|file|
        if File.exists? file
          return file
        end
      }
      return file
    end

    def render(context)
      file = find_stylesheet(context)

      mtime = nil
      if ! File.exists?(file)
        warn "Stylesheet file: '#{@file}' not found (#{file})"
        mtime = Time.now.to_i
      else
        mtime = File.mtime(file).to_i
      end

      return %Q{<link rel="stylesheet" href="#{@file}?#{mtime}" type="text/css" media="screen, projection" />}
    end
  end

end

Liquid::Template.register_tag('stylesheet', Jekyll::StylesheetTag)

