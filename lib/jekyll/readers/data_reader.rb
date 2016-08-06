module Jekyll
  class DataReader
    attr_reader :site, :content

    EXTENSIONS = %w(.yaml .yml .json .csv).freeze

    def initialize(site)
      @site = site
      @entry_filter = EntryFilter.new(site)
    end

    def read_data(dir)
      site.reader.get_entries(dir, site.config["data_dir"]).map do |entry|
        next unless EXTENSIONS.include?(File.extname(entry))

        path = @site.in_source_dir(File.join(dir, site.config["data_dir"], entry))
        next if @entry_filter.symlink?(path)

        doc = Document.new(path, {
          :site       => @site,
          :collection => @site.data_collection
        })
        doc.read

        doc
      end.reject(&:nil?)
    end
  end
end
