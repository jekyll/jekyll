module Jekyll
  class IncludeFragment
    include Convertible

    attr_accessor :content #, :data
    attr_reader :site, :name

    def initialize(site, container, file)
      @site = site
      @container = container
      @name = file

      self.read
    end

    def read
      self.content = File.read(self.path)
    end

    def placeholder
      @placeholder ||= "<# special include placeholder #{Random.rand}#>"
    end

    def ext
      File.extname(@name)
    end

    def path
      File.join(@site.dest, '_includes', @name)
    end

    # Just undef them here temporarily. Take this out before merge.
    undef_method :write
    undef_method :do_layout
    undef_method :render_all_layouts
  end
end