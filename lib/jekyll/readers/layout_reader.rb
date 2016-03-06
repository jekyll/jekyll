module Jekyll
  class LayoutReader
    attr_reader :site
    def initialize(site)
      @site = site
      @layouts = {}
    end

    def read
      layout_entries.each do |directory, entries|
        entries.each do |name|
          @layouts[layout_name(name)] = Layout.new(site, directory, name)
        end
      end

      @layouts
    end

    def layout_directories
      @layout_directories ||= Array(site.config['layouts_dir']).map do |directory|
        layout_directory_in_cwd(directory) || layout_directory_inside_source(directory)
      end
    end

    private

    def layout_entries
      entries = {}
      layout_directories.each do |directory|
        entries[directory] = []
        within(directory) do
          entries[directory].concat EntryFilter.new(site).filter(Dir['**/*.*'])
        end
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

    def layout_directory_inside_source(directory)
      site.in_source_dir(directory)
    end

    def layout_directory_in_cwd(directory)
      dir = Jekyll.sanitized_path(Dir.pwd, directory)
      if File.directory?(dir) && !site.safe
        dir
      else
        nil
      end
    end
  end
end
