module AutoBlog

  class Layout
    include Convertible
    
    attr_accessor :ext
    attr_accessor :data, :content
    
    # Initialize a new Layout.
    #   +base+ is the String path to the <source>
    #   +name+ is the String filename of the post file
    #
    # Returns <Page>
    def initialize(base, name)
      @base = base
      @name = name
      
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
    
    # Add any necessary layouts to this post
    #   +layouts+ is a Hash of {"name" => "layout"}
    #   +site_payload+ is the site payload hash
    #
    # Returns nothing
    def add_layout(layouts, site_payload)
      payload = {"page" => self.data}.merge(site_payload)
      self.content = Liquid::Template.parse(self.content).render(payload, [AutoBlog::Filters])
      
      layout = layouts[self.data["layout"]] || self.content
      payload = {"content" => self.content, "page" => self.data}
      
      self.content = Liquid::Template.parse(layout).render(payload, [AutoBlog::Filters])
    end
  end

end