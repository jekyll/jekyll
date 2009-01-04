module Jekyll

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
  end

end