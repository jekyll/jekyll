module Jekyll
  class CollectionsReader
    attr_reader :site

    # Public: Create a new Collections Reader
    #
    # Returns nothing
    def initialize(site)
      @site = site
      @collections = {}
    end

    # Public: Read in all the collections
    #
    # Returns the collections which have been read in
    def read
      collection_names.each do |collection_name|
        @collections[collection_name] = Collection.new(site, collection_name)
        @collections[collection_name].documents.each(&:read)
      end

      @collections
    end

    # Public: Fetch the collection names to read in
    #
    # Returns an array of collection names
    def collection_names
      [site.config["collections"], %w[posts data]].flatten.compact
    end
  end
end
