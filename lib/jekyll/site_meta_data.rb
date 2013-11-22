require "pstore"

module Jekyll
  class SiteMetaData
    extend Forwardable
    attr_reader :site

    def_delegator :@data, :[]

    def initialize(site)
      @site = site
      @data = {}
    end

    def store(entity)
      @data[entity] ||= Hash.new
      @data[entity][:modification_time] = File.mtime(entity)
    end

    def write_to_disk
      metadata = PStore.new(metadata_file)
      metadata.transaction do
        metadata["metadata"] = @data
      end
    end

    def read_from_disk
      metadata = PStore.new(metadata_file, true)
      metadata.transaction do
        @data = metadata["metadata"]
      end
    end

    private

    def metadata_file
      File.join(site.source, ".jekyll_metadata")
    end
  end
end
