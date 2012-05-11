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

      source_dir = context.registers[:site].source
      page_url = context.environments.first['page']['url']
      files = [File.join(source_dir, file),
               # try with stripping a leading slash
               File.join(source_dir, file[1..-1]),
               # try relative to the current page
               File.join(source_dir, File.dirname(page_url), file)]

      if context['site']['stylesheet_link']
        context['site']['stylesheet_link']['search_paths'].each do |path|
          files << File.join(path, file)
          files << File.join(path, file[1..-1])
          files << File.join(path, File.dirname(page_url), file)
        end
      end

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

