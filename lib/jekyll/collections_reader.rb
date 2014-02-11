module Jekyll
  class CollectionsReader
    attr_reader :site

    def initialize(site)
      @site = site
      @collections = {}
    end

    def read
      collection_names.each do |collection_name|
        @collections[collection_name] = Collection.new(site, collection_name)
      end

      @collections
    end

    private

    def collection_names
      site.config["collections"].merge(["posts"])
    end

    def collection_layout(name)
      File.join(site.source, "_#{name}")
    end
  end
end
