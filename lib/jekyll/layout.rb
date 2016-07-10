module Jekyll
  class Layout
    include Convertible

    # Gets the Site object.
    attr_reader :site

    # Gets the name of this layout.
    attr_reader :name

    # Gets the path to this layout.
    attr_reader :path

    # Gets/Sets the extension of this layout.
    attr_accessor :ext

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

      if site.theme && site.theme.layouts_path.eql?(base)
        @base_dir = site.theme.root
        @path = site.in_theme_dir(base, name)
      else
        @base_dir = site.source
        @path = site.in_source_dir(base, name)
      end

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
      self.ext = File.extname(name)
    end

    # The path to the layout, relative to the site source.
    #
    # Returns a String path which represents the relative path
    #   from the site source to this layout
    def relative_path
      @relative_path ||= Pathname.new(path).relative_path_from(
        Pathname.new(@base_dir)
      ).to_s
    end
  end
end
