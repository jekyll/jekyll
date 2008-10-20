module AutoBlog

  class Page
    attr_accessor :ext
    attr_accessor :data, :content
    
    def initialize(base, dir, name)
      @base = base
      @dir = dir
      @name = name
      
      self.process(name)
      self.read_yaml(base, dir, name)
      self.set_defaults
      self.transform
    end
    
    def process(name)
      self.ext = File.extname(name)
    end
    
    def read_yaml(base, dir, name)
      self.content = File.read(File.join(base, dir, name))
      
      if self.content =~ /^(---\n.*?)\n---\n/
        self.content = self.content[($1.size + 5)..-1]
        
        self.data = YAML.load($1)
      end
    end
    
    def set_defaults
      self.data["layout"] ||= "default"
    end
    
    def transform
      if self.ext == "textile"
        self.ext = "html"
        self.content = RedCloth.new(self.content).to_html
      end
    end
    
    def add_layout(layouts)
      payload = {"page" => self.data}
      self.content = Liquid::Template.parse(self.content).render(payload)
      
      layout = layouts[self.data["layout"]] || self.content
      payload = {"content" => self.content, "page" => self.data}
      
      self.content = Liquid::Template.parse(layout).render(payload)
    end
    
    def write(dest)
      FileUtils.mkdir_p(File.join(dest, @dir))
      
      path = File.join(dest, @dir, @name)
      File.open(path, 'w') do |f|
        f.write(self.content)
      end
    end
  end

end