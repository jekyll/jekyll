module Jekyll
  class PageReader
    attr_reader :site

    def initialize(site)
      @site = site
    end

    def pages_collection
      @pages_collection ||= ->() {
        collection = Jekyll::Collection.new(site, "pages", [])
        collection.relative_directory = ""
        collection
      }.()
    end

    def read
      Dir.chdir(site.source) do
        Dir["**/*.*"].map do |entry|
          pages_collection.documents << Jekyll::Page.new(site, pages_collection, entry)
        end
      end
      pages_collection
    end
  end
end
