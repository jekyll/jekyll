module AutoBlog
  
  class Site
    attr_accessor :source, :dest
    attr_accessor :layouts, :posts
    
    def initialize(source, dest)
      self.source = source
      self.dest = dest
      self.layouts = {}
      self.posts = []
    end
    
    def process
      self.read_layouts
      self.read_posts
    end
    
    def read_layouts
      base = File.join(self.source, "_layouts")
      entries = Dir.entries(base)
      entries = entries.reject { |e| File.directory?(e) }
      
      entries.each do |f|
        name = f.split(".")[0..-2].join(".")
        self.layouts[name] = File.read(File.join(base, f))
      end
    rescue Errno::ENOENT => e
      # ignore missing layout dir
    end
    
    def read_posts
      base = File.join(self.source, "posts")
      entries = Dir.entries(base)
      entries = entries.reject { |e| File.directory?(e) }
      
      entries.each do |f|
        self.posts << Post.new(base, f) if Post.valid?(f)
      end
      
      self.posts.sort!
    rescue Errno::ENOENT => e
      # ignore missing layout dir
    end
    
    def write_posts
      self.posts.each do |post|
        post.add_layout(self.layouts)
      end
    end
  end

end