# frozen_string_literal: true

module Jekyll
  class Layout
    include Convertible

    # Gets the Site object.
    attr_reader :site

    # Gets the name of this layout.
    attr_reader :name

    # Gets the path to this layout.
    attr_reader :path

    # Gets the path to this layout relative to its base
    attr_reader :relative_path

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
      @relative_path = @path.sub("#{@base_dir}/", "")

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

    # Compute layout's location information from its path.
    #
    # Unlike `#relative_path`, which doesn't distinguish between a layout from the source
    # directory and that from a theme-gem, this method returns the relative path of a
    # layout from the theme-gem with the gem's dirname prepended.
    #
    #   <source_dir>/_layouts/home.html        =>  _layouts/home.html
    #   <minima-2.3.0.gem>/_layouts/home.html  =>  minima-2.3.0/_layouts/home.html
    def relative_file_path
      @relative_file_path ||= begin
        if site.theme && path.start_with?(site.theme.root)
          path.sub("#{site.theme.gem_dir}/", "")
        else
          relative_path
        end
      end
    end
  end
end
