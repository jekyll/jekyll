require 'mime/types'

module Jekyll
  class Layout
    include Convertible

    # Gets the Site object.
    attr_reader :site

    # Gets the name of this layout.
    attr_reader :name

    # Gets the path to this layout.
    attr_reader :path

    # Gets/Sets the MIME type of this layout.
    attr_accessor :mime_type

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
      @path = site.in_source_dir(base, name)

      self.data = {}

      process(name)
      read_yaml(base, name)
    end

    # Extract information from the layout filename.
    #
    # name - The String filename of the layout file.
    #
    # Returns nothing.
    def process(name)
      self.mime_type = MIME::Types.find{|t| ".#{t.preferred_extension}" == File.extname(name)}
    end
    
    def ext
      "." + @mime_type.preferred_extension
    end
  end
end
