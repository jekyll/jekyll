module AutoBlog
  module Convertible
    # Read the YAML frontmatter
    #   +base+ is the String path to the dir containing the file
    #   +name+ is the String filename of the file
    #
    # Returns nothing
    def read_yaml(base, name)
      self.content = File.read(File.join(base, name))
      
      if self.content =~ /^(---\n.*?)\n---\n/
        self.content = self.content[($1.size + 5)..-1]
        
        self.data = YAML.load($1)
      end
    end
  
    # Transform the contents based on the file extension.
    #
    # Returns nothing
    def transform
      if self.ext == ".textile"
        self.ext = ".html"
        self.content = RedCloth.new(self.content).to_html
      end
    end
  end
end