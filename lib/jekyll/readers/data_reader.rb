module Jekyll
  class DataReader
    attr_reader :site, :content
    def initialize(site)
      @site = site
      @content = {}
    end

    # Read all the files in <source>/<dir>/_drafts and create a new Draft
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read(dir)
      base = site.in_source_dir(dir)
      read_data_to(base, @content)
      @content
    end

    # Read and parse all yaml files under <dir> and add them to the
    # <data> variable.
    #
    # dir - The string absolute path of the directory to read.
    # data - The variable to which data will be added.
    #
    # Returns nothing
    def read_data_to(dir, data)
      return unless File.directory?(dir) && (!site.safe || !File.symlink?(dir))

      entries = Dir.chdir(dir) do
        Dir['*.{yaml,yml,json,csv}'] + Dir['*'].select { |fn| File.directory?(fn) }
      end

      entries.each do |entry|
        path = @site.in_source_dir(dir, entry)
        next if File.symlink?(path) && site.safe

        key = sanitize_filename(File.basename(entry, '.*'))
        if File.directory?(path)
          read_data_to(path, data[key] = {})
        else
          data[key] = read_data_file(path)
        end
      end
    end

    # Determines how to read a data file.
    #
    # Returns the contents of the data file.
    def read_data_file(path)
      case File.extname(path).downcase
        when '.csv'
          CSV.read(path, {
                           :headers => true,
                           :encoding => site.config['encoding']
                       }).map(&:to_hash)
        else
          SafeYAML.load_file(path)
      end
    end

    def sanitize_filename(name)
      name.gsub!(/[^\w\s-]+/, '')
      name.gsub!(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
      name.gsub(/\s+/, '_')
    end
  end
end
