# frozen_string_literal: true

module Jekyll
  class DataReader
    attr_reader :site, :content
    def initialize(site)
      @site = site
      @content = {}
      @entry_filter = EntryFilter.new(site)
    end

    # Read all the files in <dir> and adds them to @content
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns @content, a Hash of the .yaml, .yml,
    # .json, and .csv files in the base directory
    def read(dir)
      base = site.in_source_dir(dir)
      read_data_to(base, @content)
      @content
    end

    # Read and parse all .yaml, .yml, .json, .csv and .tsv
    # files under <dir> and add them to the <data> variable.
    #
    # dir - The string absolute path of the directory to read.
    # data - The variable to which data will be added.
    #
    # Returns nothing
    def read_data_to(dir, data)
      return unless File.directory?(dir) && !@entry_filter.symlink?(dir)

      entries = Dir.chdir(dir) do
        Dir["*.{yaml,yml,json,csv,tsv}"] + Dir["*"].select { |fn| File.directory?(fn) }
      end

      entries.each do |entry|
        path = @site.in_source_dir(dir, entry)
        next if @entry_filter.symlink?(path)

        if File.directory?(path)
          read_data_to(path, data[sanitize_filename(entry)] = {})
        else
          key = sanitize_filename(File.basename(entry, ".*"))
          data[key] = read_data_file(path)
        end
      end
    end

    # Determines how to read a data file.
    #
    # Returns the contents of the data file.
    def read_data_file(path)
      case File.extname(path).downcase
      when ".csv"
        CSV.read(path,
          :headers  => true,
          :encoding => site.config["encoding"]).map(&:to_hash)
      when ".tsv"
        CSV.read(path,
          :col_sep  => "\t",
          :headers  => true,
          :encoding => site.config["encoding"]).map(&:to_hash)
      else
        SafeYAML.load_file(path)
      end
    end

    def sanitize_filename(name)
      name.gsub(%r![^\w\s-]+|(?<=^|\b\s)\s+(?=$|\s?\b)!, "")
        .gsub(%r!\s+!, "_")
    end
  end
end
