# frozen_string_literal: true

module Jekyll
  class DataReader
    attr_reader :site, :content

    def initialize(site, in_source_dir: nil)
      @site = site
      @content = {}
      @entry_filter = EntryFilter.new(site)
      @in_source_dir = in_source_dir || @site.method(:in_source_dir)
      @source_dir = @in_source_dir.call("/")
    end

    # Read all the files in <dir> and adds them to @content
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns @content, a Hash of the .yaml, .yml,
    # .json, and .csv files in the base directory
    def read(dir)
      base = @in_source_dir.call(dir)
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
        path = @in_source_dir.call(dir, entry)
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
      Jekyll.logger.debug "Reading:", path.sub(@source_dir, "")

      case File.extname(path).downcase
      when ".csv"
        CSV.read(path, **csv_config).map { |row| convert_row(row) }
      when ".tsv"
        CSV.read(path, **tsv_config).map { |row| convert_row(row) }
      else
        SafeYAML.load_file(path)
      end
    end

    def sanitize_filename(name)
      name.gsub(%r![^\w\s-]+|(?<=^|\b\s)\s+(?=$|\s?\b)!, "")
        .gsub(%r!\s+!, "_")
    end

    private

    # @return [Hash]
    def csv_config
      @csv_config ||= read_config("csv_reader")
    end

    # @return [Hash]
    def tsv_config
      @tsv_config ||= read_config("tsv_reader", { :col_sep => "\t" })
    end

    # @param config_key [String]
    # @param overrides [Hash]
    # @return [Hash]
    # @see https://ruby-doc.org/stdlib-2.5.0/libdoc/csv/rdoc/CSV.html#Converters
    def read_config(config_key, overrides = {})
      reader_config = config[config_key] || {}

      defaults = {
        :converters => reader_config.fetch("csv_converters", []).map(&:to_sym),
        :headers    => reader_config.fetch("headers", true),
        :encoding   => reader_config.fetch("encoding", config["encoding"]),
      }

      defaults.merge(overrides)
    end

    def config
      @config ||= site.config
    end

    # @param row [Array, CSV::Row]
    # @return [Array, Hash]
    def convert_row(row)
      row.instance_of?(CSV::Row) ? row.to_hash : row
    end
  end
end
