module Jekyll

  class Javascript < Liquid::Tag
    def initialize(tag_name, file, tokens)
      super
      @file = file
    end

    def find_javascript(context)
      file = @file
      file.strip!
      file.gsub! /^["']/, ""
      file.gsub! /["']$/, ""
      if ! file =~ /.[a-z]+$/
        file = "#{file}.js"
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
      file = find_javascript(context)

      mtime = nil
      if ! File.exists?(file)
        warn "Javascript file: '#{@file}' not found (#{file})"
        mtime = Time.now.to_i
      else
        mtime = File.mtime(file).to_i
      end

      return %Q{<script src="#{@file}?#{mtime}" type="text/javascript" ></script>}
    end
  end

end

Liquid::Template.register_tag('javascript', Jekyll::Javascript)

