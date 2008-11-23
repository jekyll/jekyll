module Jekyll
  module Convertible
    # Return the contents as a string
    def to_s
      self.content || ''
    end
    
    # Read the YAML frontmatter
    #   +base+ is the String path to the dir containing the file
    #   +name+ is the String filename of the file
    #
    # Returns nothing
    def read_yaml(base, name)
      self.content = File.read(File.join(base, name))
      
      if self.content =~ /^(---.*\n.*?)\n---.*\n/m
        self.content = self.content[($1.size + 5)..-1]
        
        self.data = YAML.load($1)
      end
    end
  
    # Transform the contents based on the file extension.
    #
    # Returns nothing
    def transform
      case self.ext
      when ".textile":
        self.ext = ".html"
        self.content = RedCloth.new(self.content).to_html
      when ".markdown":
        self.ext = ".html"
        self.content = RDiscount.new(self.content).to_html
      end
    end
    
    # Add any necessary layouts to this post
    #   +layouts+ is a Hash of {"name" => "layout"}
    #   +site_payload+ is the site payload hash
    #
    # Returns nothing
    def do_layout(payload, layouts, site_payload)
      # construct payload
      payload = payload.merge(site_payload)
      
      # render content
      self.content = Liquid::Template.parse(self.content).render(payload, [Jekyll::Filters])
      self.transform
      
      # output keeps track of what will finally be written
      self.output = self.content
      
      # recursively render layouts
      layout = layouts[self.data["layout"]]
      while layout
        payload = payload.merge({"content" => self.output, "page" => self.data})
        self.output = Liquid::Template.parse(layout.content).render(payload, [Jekyll::Filters])
        
        layout = layouts[layout.data["layout"]]
      end
    end
  end
end