module Jekyll
  class CollectionReader
    attr_reader :site, :content
    def initialize(site)
      @site = site
      @content = {}
    end

    # Read in all collections specified in the configuration
    #
    # Returns nothing.
    def read
      site.collections.each do |_, collection|
        collection.read unless collection.label.eql?('data')
      end
    end

  end
end