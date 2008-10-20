module AutoBlog

  class Post
    MATCHER = /^(\d+-\d+-\d+)-(.*)\.([^.]+)$/
    
    def self.valid?(name)
      name =~ MATCHER
    end
    
    attr_accessor :date, :slug, :ext
    
    def initialize(base, name)
      @base = base
      @name = name
      
      self.process(name)
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
  end

end