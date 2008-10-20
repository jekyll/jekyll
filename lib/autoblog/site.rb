module AutoBlog
  
  class Site
    attr_accessor :source, :dest
    attr_accessor :layouts
    
    def initialize(source, dest)
      self.source = source
      self.dest = dest
      self.layouts = {}
    end
    
    def process
      self.read_layouts
    end
    
    def read_layouts
      base = File.join(self.source, "_layouts")
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
  end

end