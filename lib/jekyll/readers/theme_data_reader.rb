module Jekyll
  class ThemeDataReader < DataReader
    attr_reader :site, :content
    def initialize(site)
      @site = site
      @content = {}
      @entry_filter = EntryFilter.new(site)
    end

    def read(dir)
      return unless site.theme && site.theme.data_path
      base = site.in_theme_dir(dir)
      read_data_to(base, @content)
      @content
    end

    def read_data_to(dir, data)
      return unless File.directory?(dir) && !@entry_filter.symlink?(dir)

      entries = Dir.chdir(dir) do
        Dir["*.{yaml,yml,json,csv}"] + Dir["*"].select { |fn| File.directory?(fn) }
      end

      entries.each do |entry|
        path = @site.in_theme_dir(dir, entry)
        next if @entry_filter.symlink?(path)

        if File.directory?(path)
          read_data_to(path, data[sanitize_filename(entry)] = {})
        else
          key = sanitize_filename(File.basename(entry, ".*"))
          data[key] = read_data_file(path)
        end
      end
    end
  end
end
