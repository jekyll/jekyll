module Jekyll
  class PageReader
    attr_reader :site, :dir
    def initialize(site, dir)
      @site = site
      @dir = dir
    end

    # Read all the files in <source>/<dir>/ for Yaml header and create a new Page
    # object for each file.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns an array of static pages.
    def read(files)
      read_documents(files).tap do |docs|
        docs.each(&:read)
      end.select { |page| site.publisher.publish?(page) }
    end

    def read_documents(files)
      files.map do |page|
        path = @site.in_source_dir(File.join(@dir, page))
        Page.new(path, {
          :site => @site,
          :collection => @site.pages
        })
      end
    end
  end
end
