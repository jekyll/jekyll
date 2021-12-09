# frozen_string_literal: true

module Jekyll
  class Layout
    include Convertible

    attr_accessor :content, # content of layout
                  :data,    # the Hash that holds the metadata for this layout
                  :ext      # extension of layout

    attr_reader :name, # name of layout
                :path, # path to layout
                :site, # the Site object
                :relative_path # path to layout relative to its base

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
      @relative_path = @path.sub(@base_dir, "")

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

    # Returns the object as a debug String.
    def inspect
      "#<#{self.class} @path=#{@path.inspect}>"
    end
  end
end
