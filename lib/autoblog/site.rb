module AutoBlog
  
  class Site
    attr_accessor :root, :layouts
    
    def initialize(root)
      self.root = root
      
      self.layouts = {}
      
      self.read_layouts
    end
    
    def read_layouts
      base = File.join(self.root, "_layouts")
      dir = Dir.new(base)
      dir.each do |f|
        unless %w{. ..}.include?(f)
          name = f.split(".")[0..-2].join(".")
          self.layouts[name] = File.read(File.join(base, f))
        end
      end
    rescue Errno::ENOENT => e
      # ignore missing layout dir
    end
    
    def process
      
    end
  end

end