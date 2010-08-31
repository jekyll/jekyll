module Jekyll

  class Site
    attr_accessor :config, :layouts, :posts, :pages, :static_files,
                  :categories, :exclude, :source, :dest, :lsi, :pygments,
                  :permalink_style, :tags, :time, :future, :safe, :plugins
    attr_accessor :converters, :generators

    # Initialize the site
    #   +config+ is a Hash containing site configurations details
    #
    # Returns <Site>
    def initialize(config)
      self.config          = config.clone

      self.safe            = config['safe']
      self.source          = File.expand_path(config['source'])
      self.dest            = File.expand_path(config['destination'])
      self.plugins         = File.expand_path(config['plugins'])
      self.lsi             = config['lsi']
      self.pygments        = config['pygments']
      self.permalink_style = config['permalink'].to_sym
      self.exclude         = config['exclude'] || []
      self.future          = config['future']

      self.reset
      self.setup
    end

    def reset
      self.time            = Time.parse(self.config['time'].to_s) || Time.now
      self.layouts         = {}
      self.posts           = []
      self.pages           = []
      self.static_files    = []
      self.categories      = Hash.new { |hash, key| hash[key] = [] }
      self.tags            = Hash.new { |hash, key| hash[key] = [] }
    end

    def setup
      require 'classifier' if self.lsi

      # If safe mode is off, load in any ruby files under the plugins
      # directory.
      unless self.safe
        Dir[File.join(self.plugins, "**/*.rb")].each do |f|
          require f
        end
      end

      self.converters = Jekyll::Converter.subclasses.select do |c|
        !self.safe || c.safe
      end.map do |c|
        c.new(self.config)
      end

      self.generators = Jekyll::Generator.subclasses.select do |c|
        !self.safe || c.safe
      end.map do |c|
        c.new(self.config)
      end
    end

    # Do the actual work of processing the site and generating the
    # real deal.  5 phases; reset, read, generate, render, write.  This allows
    # rendering to have full site payload available.
    #
    # Returns nothing
    def process
      self.reset
      self.read
      self.generate
      self.render
      self.write
    end

    # Process a single post using the site's configuration and layouts. 
    #
    # Returns the rendered post
    def process_post(filename)
      self.reset
      self.read_layouts
      dir = File.dirname(filename)
      f = File.basename(filename)
      post = Post.new(self, self.source, dir, f, true)
      post.render(self.layouts, site_payload)
      post.write(self.dest)

      return post
    end

    # Process a single page using the site's configuration and layouts. 
    #
    # Returns the rendered page
    def process_page(filename)
      self.reset
      self.read_layouts
      dir = File.dirname(filename)
      f = File.basename(filename)
      page= Page.new(self, self.source, dir, f)
      page.render(self.layouts, site_payload)
      page.write(self.dest)

      return page
    end

    def read
      self.read_layouts # existing implementation did this at top level only so preserved that
      self.read_directories
    end

    # Read all the files in <source>/<dir>/_layouts and create a new Layout
    # object with each one.
    #
    # Returns nothing
    def read_layouts(dir = '')
      base = File.join(self.source, dir, "_layouts")
      return unless File.exists?(base)
      entries = []
      Dir.chdir(base) { entries = filter_entries(Dir['*.*']) }

      entries.each do |f|
        name = f.split(".")[0..-2].join(".")
        self.layouts[name] = Layout.new(self, base, f)
      end
    end

    # Read all the files in <source>/<dir>/_posts and create a new Post
    # object with each one.
    #
    # Returns nothing
    def read_posts(dir)
      base = File.join(self.source, dir, '_posts')
      return unless File.exists?(base)
      entries = Dir.chdir(base) { filter_entries(Dir['**/*']) }

      # first pass processes, but does not yet render post content
      entries.each do |f|
        if Post.valid?(f)
          post = Post.new(self, self.source, dir, f)

          if post.published && (self.future || post.date <= self.time)
            self.posts << post
            post.categories.each { |c| self.categories[c] << post }
            post.tags.each { |c| self.tags[c] << post }
          end
        end
      end

      self.posts.sort!
    end

    def generate
      self.generators.each do |generator|
        generator.generate(self)
      end
    end

    def render
      self.posts.each do |post|
        post.render(self.layouts, site_payload)
      end

      self.pages.each do |page|
        page.render(self.layouts, site_payload)
      end

      self.categories.values.map { |ps| ps.sort! { |a, b| b <=> a} }
      self.tags.values.map { |ps| ps.sort! { |a, b| b <=> a} }
    rescue Errno::ENOENT => e
      # ignore missing layout dir
    end

    # Write static files, pages and posts
    #
    # Returns nothing
    def write
      self.posts.each do |post|
        post.write(self.dest)
      end
      self.pages.each do |page|
        page.write(self.dest)
      end
      self.static_files.each do |sf|
        sf.write(self.dest)
      end
    end

    # Reads the directories and finds posts, pages and static files that will
    # become part of the valid site according to the rules in +filter_entries+.
    #   The +dir+ String is a relative path used to call this method
    #            recursively as it descends through directories
    #
    # Returns nothing
    def read_directories(dir = '')
      base = File.join(self.source, dir)
      entries = filter_entries(Dir.entries(base))

      self.read_posts(dir)

      entries.each do |f|
        f_abs = File.join(base, f)
        f_rel = File.join(dir, f)
        if File.directory?(f_abs)
          next if self.dest.sub(/\/$/, '') == f_abs
          read_directories(f_rel)
        elsif !File.symlink?(f_abs)
          first3 = File.open(f_abs) { |fd| fd.read(3) }
          if first3 == "---"
            # file appears to have a YAML header so process it as a page
            pages << Page.new(self, self.source, dir, f)
          else
            # otherwise treat it as a static file
            static_files << StaticFile.new(self, self.source, dir, f)
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
    #                     "pages" => [<Page>],
    #                     "categories" => [<Post>]}
    def site_payload
      {"site" => self.config.merge({
          "time"       => self.time,
          "posts"      => self.posts.sort { |a,b| b <=> a },
          "pages"      => self.pages,
          "html_pages" => self.pages.reject { |page| !page.html? },
          "categories" => post_attr_hash('categories'),
          "tags"       => post_attr_hash('tags')})}
    end

    # Filter out any files/directories that are hidden or backup files (start
    # with "." or "#" or end with "~"), or contain site content (start with "_"),
    # or are excluded in the site configuration, unless they are web server
    # files such as '.htaccess'
    def filter_entries(entries)
      entries = entries.reject do |e|
        unless ['.htaccess'].include?(e)
          ['.', '_', '#'].include?(e[0..0]) || e[-1..-1] == '~' || self.exclude.include?(e)
        end
      end
    end

  end
end
