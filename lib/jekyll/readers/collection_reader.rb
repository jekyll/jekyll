# frozen_string_literal: true

module Jekyll
  class CollectionReader
    include DocumentReader
    attr_reader :site, :content
    SPECIAL_COLLECTIONS = %w(posts data).freeze

    def initialize(site)
      @site = site
      @content = {}
    end

    # Read in all collections specified in the configuration
    #
    # Returns nothing.
    def read(dir = "")
      site.collections.each_value do |collection|
        next if SPECIAL_COLLECTIONS.include?(collection.label)
        # next unless collection.write?
        collection.docs.concat(read_collection(dir, collection.relative_directory))
      end
    end

    def read_collection(dir, collection_dir)
      read_publishable(dir, collection_dir, Document::DATELESS_FILENAME_MATCHER)
    end
  end
end
