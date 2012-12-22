module Jekyll

  class Javascript < Liquid::Tag
    def initialize(tag_name, file, tokens)
      super
      @file = file
    end

    def find_javascript(original_file,context)
      file = original_file
      file.strip!
      file.gsub! /^["']/, ""
      file.gsub! /["']$/, ""
      if ! file =~ /.[a-z]+$/
        file = "#{file}.js"
      end

      source_dir = context.registers[:site].source
      page_url = context.environments.first['page']['url']
      files = [File.join(source_dir, file),
               # try with stripping a leading slash
               File.join(source_dir, file[1..-1]),
               # try relative to the current page
               File.join(source_dir, File.dirname(page_url), file)]

      if context['site']['javascript']
        context['site']['javascript']['search_paths'].each do |path|
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
      warn "JAVASCRIPT FILE: '#{original_file}' NOT FOUND"
      return original_file
    end

    def render(context, *stuff)
      files = context.environments.first['page']['js_includes']
      if !@file.nil? && !@file.empty?
        files = [@file]
      end

      result = []
      files.each do |file|
        next if file.nil? || file.empty?
        mfile = find_javascript(file,context)

        mtime = nil
        if ! File.exists?(mfile)
          mtime = Time.now.to_i
        else
          mtime = File.mtime(mfile).to_i
        end

        result << %Q{<script src="#{file}?#{mtime}" type="text/javascript" ></script>}
      end

      result.join("")
    end
  end

end

Liquid::Template.register_tag('javascript', Jekyll::Javascript)

