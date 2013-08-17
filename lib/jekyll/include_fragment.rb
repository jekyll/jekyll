module Jekyll
  class IncludeFragment
    include Convertible

    attr_reader :site, :placeholder, :name
    attr_accessor :content, :data, :output

    def initialize(site, container, file, placeholder)
      @site = site
      @container = container
      @name = file
      @placeholder = placeholder

      self.content = File.read(self.path)
    end

    def ext
      File.extname(@name)
    end

    def path
      File.join(@site.dest, '_includes', @name)
    end
  end
end