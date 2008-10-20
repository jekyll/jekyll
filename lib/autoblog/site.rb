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
      self.write_posts
      self.transform_pages
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
        post.write(self.dest)
      end
    end
    
    def transform_pages(dir = '')
      base = File.join(self.source, dir)
      entries = Dir.entries(base)
      entries = entries.reject { |e| %w{_layouts posts}.include?(e) }
      entries = entries.reject { |e| e[0..0] == '.' }
      
      entries.each do |f|
        if File.directory?(File.join(base, f))
          transform_pages(File.join(dir, f))
        else
          page = Page.new(self.source, dir, f)
          page.add_layout(self.layouts, site_payload)
          page.write(self.dest)
        end
      end
    end
    
    def site_payload
      {"site" => {"time" => Time.now, "posts" => self.posts}}
    end
  end

end