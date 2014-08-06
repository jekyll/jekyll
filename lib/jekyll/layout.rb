module Jekyll
  class Layout
    include Convertible

    # Gets the Site object.
    attr_reader :site

    # Gets the name of this layout.
    attr_reader :name

    # Gets/Sets the extension of this layout.
    attr_accessor :ext
    alias_method :extname, :ext

    # Gets/Sets the Hash that holds the metadata for this layout.
    attr_accessor :data

    # Gets/Sets the content of this layout.
    attr_accessor :content

    # Initialize a new Layout.
    #
    # site - The Site.
    # base - The String path to the source.
    # name - The String filename of the post file.
    def initialize(site, base, name)
      @site = site
      @base = base
      @name = name

      process(name)

      self.content    = File.read(Jekyll.sanitized_path(base, name))
      @content, @data = Utils.parse_front_matter(content)
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
