module Jekyll

  class StylesheetTag < Liquid::Tag
    #
    # CSS Stylesheet Liquid Tag for Jekyll.  This link tag will include the
    # last modification time of the css file if it can be found, or the current
    # as a fall back if the file can not be found.
    #
    # Example:
    #
    #    {% stylesheet_link '/path/to/file.css' %}
    #
    #  =>
    #    <link rel="stylesheet" href="/path/to/file.css?1336750796" type="text/css" media="screen, projection" />
    #
    # This plugin looks for the CSS file using the following strategy, using
    # the first one that finds a file:
    #
    #   * (site-directory)/path/to/file.css
    #   * (site-directory)path/to/file.css
    #   * (includig-file)/path/to/file.css
    #
    # If your _config.yml includes:
    #
    #   stylesheet_link:
    #     search_paths: ['/css/path1', '/css/path2']
    #
    # Then those directories will also be searched:
    #
    #   * /css/path1/path/to/file.css
    #   * /css/path1/path/to/file.css
    #   * /css/path2/path/to/file.css
    #   * /css/path2/path/to/file.css
    #
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

