module AutoBlog

  class Post
    MATCHER = /^(\d+-\d+-\d+)-(.*)\.([^.]+)$/
    
    def self.valid?(name)
      name =~ MATCHER
    end
    
    attr_accessor :date, :slug, :ext
    attr_accessor :data, :contents
    
    def initialize(base, name)
      @base = base
      @name = name
      
      self.process(name)
      self.read_yaml(base, name)
    end
    
    def process(name)
      m, date, slug, ext = *name.match(MATCHER)
      self.date = Time.parse(date)
      self.slug = slug
      self.ext = ext
    end
    
    def url
      self.date.strftime("/%Y/%m/%d/") + self.slug
    end
    
    def read_yaml(base, name)
      self.contents = File.read(File.join(base, name))
      
      if self.contents =~ /^(---\n.*?)\n---\n/
        self.contents = self.contents[($1.size + 5)..-1]
        
        self.data = YAML.load($1)
      end
    end
  end

end