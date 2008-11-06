module AutoBlog
  
  class Site
    attr_accessor :source, :dest
    attr_accessor :layouts, :posts
    
    # Initialize the site
    #   +source+ is String path to the source directory containing
    #            the proto-site
    #   +dest+ is the String path to the directory where the generated
    #          site should be written
    #
    # Returns <Site>
    def initialize(source, dest)
      self.source = source
      self.dest = dest
      self.layouts = {}
      self.posts = []
    end
    
    # Do the actual work of processing the site and generating the
    # real deal.
    #
    # Returns nothing
    def process
      self.read_layouts
      self.read_posts
      self.write_posts
      self.transform_pages
    end
    
    # Read all the files in <source>/_layouts into memory for
    # later use.
    #
    # Returns nothing
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
    
    # Read all the files in <source>/posts and create a new Post
    # object with each one.
    #
    # Returns nothing
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
    
    # Write each post to <dest>/<year>/<month>/<day>/<slug>
    #
    # Returns nothing
    def write_posts
      self.posts.each do |post|
        post.add_layout(self.layouts, site_payload)
        post.write(self.dest)
      end
    end
    
    # Recursively transform and write all non-post pages to <dest>/
    #   +dir+ is the String path part representing the path from
    #         <source> to the currently processing dir (default '')
    #
    # Returns nothing
    def transform_pages(dir = '')
      base = File.join(self.source, dir)
      entries = Dir.entries(base)
      entries = entries.reject { |e| %w{_layouts posts drafts}.include?(e) }
      entries = entries.reject { |e| e[0..0] == '.' }
      
      entries.each do |f|
        if File.directory?(File.join(base, f))
          transform_pages(File.join(dir, f))
        else
          if %w{.png .jpg .gif}.include?(File.extname(f))
            FileUtils.mkdir_p(File.join(self.dest, dir))
            FileUtils.cp(File.join(self.source, dir, f), File.join(self.dest, dir, f))
          else
            page = Page.new(self.source, dir, f)
            page.add_layout(self.layouts, site_payload)
            page.write(self.dest)
          end
        end
      end
    end
    
    # The Hash payload containing site-wide data
    #
    # Returns {"site" => {"time" => <Time>, "posts" => [<Post>]}}
    def site_payload
      {"site" => {"time" => Time.now, "posts" => self.posts.sort.reverse}}
    end
  end

end