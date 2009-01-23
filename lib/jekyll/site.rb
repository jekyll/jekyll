module Jekyll
  
  class Site
    attr_accessor :source, :dest
    attr_accessor :layouts, :posts, :categories
    
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
      self.categories = Hash.new { |hash, key| hash[key] = Array.new }
    end
    
    # Do the actual work of processing the site and generating the
    # real deal.
    #
    # Returns nothing
    def process
      self.read_layouts
      self.transform_pages
      self.write_posts
    end
    
    # Read all the files in <source>/_layouts except backup files
    # (end with "~") into memory for later use.
    #
    # Returns nothing
    def read_layouts
      base = File.join(self.source, "_layouts")
      entries = Dir.entries(base)
      entries = entries.reject { |e| e[-1..-1] == '~' }
      entries = entries.reject { |e| File.directory?(File.join(base, e)) }
      
      entries.each do |f|
        name = f.split(".")[0..-2].join(".")
        self.layouts[name] = Layout.new(base, f)
      end
    rescue Errno::ENOENT => e
      # ignore missing layout dir
    end
    
    # Read all the files in <base>/_posts except backup files (end with "~")
    # and create a new Post object with each one.
    #
    # Returns nothing
    def read_posts(dir)
      base = File.join(self.source, dir, '_posts')
      
      entries = []
      Dir.chdir(base) { entries = Dir['**/*'] }
      entries = entries.reject { |e| e[-1..-1] == '~' }
      entries = entries.reject { |e| File.directory?(File.join(base, e)) }

      # first pass processes, but does not yet render post content
      entries.each do |f|
        if Post.valid?(f)
          post = Post.new(self.source, dir, f)
          self.posts << post
          post.categories.each { |c| self.categories[c] << post }
        end
      end
      
      # second pass renders each post now that full site payload is available
      self.posts.each do |post|
        post.render(self.layouts, site_payload)
      end
      
      self.posts.sort!
      self.categories.values.map { |cats| cats.sort! { |a, b| b <=> a} }
    rescue Errno::ENOENT => e
      # ignore missing layout dir
    end
    
    # Write each post to <dest>/<year>/<month>/<day>/<slug>
    #
    # Returns nothing
    def write_posts
      self.posts.each do |post|
        post.write(self.dest)
      end
    end
    
    # Copy all regular files from <source> to <dest>/ ignoring
    # any files/directories that are hidden or backup files (start
    # with "." or end with "~") or contain site content (start with "_")
    # unless they are "_posts" directories or web server files such as
    # '.htaccess'
    #   The +dir+ String is a relative path used to call this method
    #            recursively as it descends through directories
    #
    # Returns nothing
    def transform_pages(dir = '')
      base = File.join(self.source, dir)
      entries = Dir.entries(base)
      entries = entries.reject { |e| e[-1..-1] == '~' }
      entries = entries.reject do |e|
        (e != '_posts') and ['.', '_'].include?(e[0..0]) unless ['.htaccess'].include?(e)
      end
      directories = entries.select { |e| File.directory?(File.join(base, e)) }
      files = entries.reject { |e| File.directory?(File.join(base, e)) }

      # we need to make sure to process _posts *first* otherwise they 
      # might not be available yet to other templates as {{ site.posts }}
      if entries.include?('_posts')
        entries.delete('_posts')
        read_posts(dir)
      end
      [directories, files].each do |entries|
        entries.each do |f|
          if File.directory?(File.join(base, f))
            next if self.dest.sub(/\/$/, '') == File.join(base, f)
            transform_pages(File.join(dir, f))
          else
            first3 = File.open(File.join(self.source, dir, f)) { |fd| fd.read(3) }
        
            if first3 == "---"
              # file appears to have a YAML header so process it as a page
              page = Page.new(self.source, dir, f)
              page.render(self.layouts, site_payload)
              page.write(self.dest)
            else
              # otherwise copy the file without transforming it
              FileUtils.mkdir_p(File.join(self.dest, dir))
              FileUtils.cp(File.join(self.source, dir, f), File.join(self.dest, dir, f))
            end
          end
        end
      end
    end

    # Constructs a hash map of Posts indexed by the specified Post attribute
    #
    # Returns {post_attr => [<Post>]}
    def post_attr_hash(post_attr)
      # Build a hash map based on the specified post attribute ( post attr => array of posts )
      # then sort each array in reverse order
      hash = Hash.new { |hash, key| hash[key] = Array.new }
      self.posts.each { |p| p.send(post_attr.to_sym).each { |t| hash[t] << p } }
      hash.values.map { |sortme| sortme.sort! { |a, b| b <=> a} }
      return hash
    end

    # The Hash payload containing site-wide data
    #
    # Returns {"site" => {"time" => <Time>,
    #                     "posts" => [<Post>],
    #                     "categories" => [<Post>],
    #                     "topics" => [<Post>] }}
    def site_payload
      {"site" => {
        "time" => Time.now, 
        "posts" => self.posts.sort { |a,b| b <=> a },
        "categories" => post_attr_hash('categories'),
        "topics" => post_attr_hash('topics')
      }}
    end
  end

end
