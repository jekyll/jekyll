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
        entries = EntryFilter.new(site).filter(Dir['**/*.*'])
      end
      entries
    end

    def layout_name(file)
      file.split(".")[0..-2].join(".")
    end

    def within(directory)
      return unless File.exist?(directory)
      Dir.chdir(directory) { yield }
    end

    def layout_directory_inside_source
      site.in_source_dir(site.config['layouts_dir'])
    end

    def layout_directory_in_cwd
      dir = Jekyll.sanitized_path(Dir.pwd, site.config['layouts_dir'])
      if File.directory?(dir) && !site.safe
        dir
      else
        nil
      end
    end
  end
end
