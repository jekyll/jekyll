module AutoBlog

  class Post
    MATCHER = /^(\d+-\d+-\d+)-(.*)\.([^.]+)$/
    
    def self.valid?(name)
      name =~ MATCHER
    end
    
    attr_accessor :date, :slug, :ext
    attr_accessor :data, :content, :output
    
    def initialize(base, name)
      @base = base
      @name = name
      
      self.process(name)
      self.read_yaml(base, name)
      self.set_defaults
      self.transform
    end
    
    def process(name)
      m, date, slug, ext = *name.match(MATCHER)
      self.date = Time.parse(date)
      self.slug = slug
      self.ext = ext
    end
    
    def dir
      self.date.strftime("/%Y/%m/%d/")
    end
    
    def url
      self.dir + self.slug + ".html"
    end
    
    def id
      self.dir + self.slug
    end
    
    def read_yaml(base, name)
      self.content = File.read(File.join(base, name))
      
      if self.content =~ /^(---\n.*?)\n---\n/
        self.content = self.content[($1.size + 5)..-1]
        
        self.data = YAML.load($1)
      end
    end
    
    def set_defaults
      self.data["layout"] ||= "default"
    end
    
    def transform
      self.content = RedCloth.new(self.content).to_html
    end
    
    def add_layout(layouts)
      payload = {"page" => self.data}
      self.content = Liquid::Template.parse(self.content).render(payload)
      
      layout = layouts[self.data["layout"]] || self.content
      payload = {"content" => self.content, "page" => self.data}
      
      self.output = Liquid::Template.parse(layout).render(payload)
    end
    
    def write(dest)
      FileUtils.mkdir_p(File.join(dest, self.dir))
      
      path = File.join(dest, self.url)
      File.open(path, 'w') do |f|
        f.write(self.output)
      end
    end
    
    def to_liquid
      { "title" => self.data["title"] || "",
        "url" => self.url,
        "date" => self.date,
        "id" => self.id,
        "content" => self.content }
    end
  end

end