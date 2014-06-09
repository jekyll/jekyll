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
      entries = []
      within(layout_directory) do
        entries = EntryFilter.new(site).filter(site.fs['**/*.*'])
      end
      entries
    end

    def layout_name(file)
      file.split(".")[0..-2].join(".")
    end

    def within(directory)
      return unless site.fs.exist?(directory)
      site.fs.chdir(directory) { yield }
    end

    def layout_directory_inside_source
      site.fs.path_with_source(site.config['layouts'])
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
