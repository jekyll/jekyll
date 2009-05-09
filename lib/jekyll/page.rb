module Jekyll

  class Page
    include Convertible

    attr_accessor :site
    attr_accessor :ext
    attr_accessor :data, :content, :output

    # Initialize a new Page.
    #   +site+ is the Site
    #   +base+ is the String path to the <source>
    #   +dir+ is the String path between <source> and the file
    #   +name+ is the String filename of the file
    #
    # Returns <Page>
    def initialize(site, base, dir, name)
      @site = site
      @base = base
      @dir = dir
      @name = name

      self.data = {}

      self.process(name)
      self.read_yaml(File.join(base, dir), name)
      #self.transform
    end

    # Extract information from the page filename
    #   +name+ is the String filename of the page file
    #
    # Returns nothing
    def process(name)
      self.ext = File.extname(name)
    end

    # Add any necessary layouts to this post
    #   +layouts+ is a Hash of {"name" => "layout"}
    #   +site_payload+ is the site payload hash
    #
    # Returns nothing
    def render(layouts, site_payload)
      payload = {"page" => self.data}.deep_merge(site_payload)
      do_layout(payload, layouts)
    end

    # Write the generated page file to the destination directory.
    #   +dest_prefix+ is the String path to the destination dir
    #   +dest_suffix+ is a suffix path to the destination dir
    #
    # Returns nothing
    def write(dest_prefix, dest_suffix = nil)
      dest = File.join(dest_prefix, @dir)
      dest = File.join(dest, dest_suffix) if dest_suffix
      FileUtils.mkdir_p(dest)

      name = @name
      if self.ext != ""
        name = @name.split(".")[0..-2].join('.') + self.ext
      end

      path = File.join(dest, name)
      File.open(path, 'w') do |f|
        f.write(self.output)
      end
    end
  end

end