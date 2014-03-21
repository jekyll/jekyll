module Jekyll
  class Layout
    include Convertible

    attr_reader :site, :name
    attr_accessor :data, :content

    # Initialize a new Layout.
    #
    # site - The Site.
    # path - The String path of the post file.
    def initialize(site, path)
      @site = site
      @name = File.basename(path)

      self.data = {}

      process(name)
      read_yaml(path)
    end

    # Extract information from the layout filename.
    #
    # name - The String filename of the layout file.
    #
    # Returns nothing.
    def process(name)
      self.ext = File.extname(name)
    end
  end
end
