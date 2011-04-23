module Jekyll

  class Layout
    include Convertible

    attr_accessor :site
    attr_accessor :ext
    attr_accessor :data, :content, :src_path

    # Initialize a new Layout.
    #   +site+ is the Site
    #   +base+ is the String path to the <source>
    #   +name+ is the String filename of the post file
    #
    # Returns <Page>
    def initialize(site, base, name)
      @site = site
      @base = base
      @name = name
      @src_path = File.join(@base, @name) # source path of the layout

      self.data = {}

      self.process(name)
      self.read_yaml(base, name)
    end

    # Extract information from the layout filename
    #   +name+ is the String filename of the layout file
    #
    # Returns nothing
    def process(name)
      self.ext = File.extname(name)
    end
  end

end