module Jekyll
  class LayoutReader
    attr_reader :site
    def initialize(site)
      @site = site
      @layouts = {}
    end

    def read
      layout_entries.each do |f|
        @layouts[layout_name(f)] = Layout.new(site, layout_directory, f)
      end

      @layouts
    end

    def layout_directory
      @layout_directory ||= (layout_directory_in_cwd || layout_directory_inside_source)
    end

    private

    def layout_entries
      entries = EntryFilter.new(site).filter(
        site.fs.glob(File.join(layout_directory, '**', '*')).map do |entry|
          site.fs.relative_to(layout_directory, entry)
        end
      )
    end

    def layout_name(file)
      file.split(".")[0..-2].join(".")
    end

    def layout_directory_inside_source
      site.fs.sanitized_path(site.config['layouts'])
    end

    def layout_directory_in_cwd
      dir = site.fs.sanitized_path(Dir.pwd, site.config['layouts'])
      if site.fs.directory?(dir)
        dir
      else
        nil
      end
    end
  end
end
