require 'set'

module Jekyll

  class Site
    attr_accessor :config, :layouts, :posts, :pages, :static_files,
                  :categories, :exclude, :source, :dest, :lsi, :pygments,
                  :permalink_style, :tags, :time, :future, :safe, :plugins, :limit_posts

    attr_accessor :converters, :generators

    # Public: Initialize a new Site.
    #
    # config - A Hash containing site configuration details.
    #  safe            — (boolean) ???
    #  lsi             — (boolean) produces an index for related posts,
    #                    see http://en.wikipedia.org/wiki/Latent_Semantic_Indexing
    #  pygments        — (boolean) enables highlight tag with Pygments
    #  permalink_style — (:date, :pretty, :none)
    #  exclude         — (array) a list of directories and files to exclude
    #                    from the conversion
    #  future          — (boolean) render future dated posts
    #  limit_posts     — (integer) limit the number of posts to publish
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
      self.limit_posts     = config['limit_posts'] || nil

      self.reset
      self.setup
    end

    # Public: Read, process, and write this Site to output.
    #
    # Returns nothing.
    def process
      self.reset
      self.read
      self.generate
      self.render
      self.cleanup
      self.write
    end

    # Reset Site details.
    #
    # Returns nothing
    def reset
      self.time            = if self.config['time']
                               Time.parse(self.config['time'].to_s)
                             else
                               Time.now
                             end
      self.layouts         = {}
      self.posts           = []
      self.pages           = []
      self.static_files    = []
      self.categories      = Hash.new { |hash, key| hash[key] = [] }
      self.tags            = Hash.new { |hash, key| hash[key] = [] }

      if !self.limit_posts.nil? && self.limit_posts < 1
        raise ArgumentError, "Limit posts must be nil or >= 1"
      end
    end

    # Load necessary libraries, plugins, converters, and generators.
    #
    # Returns nothing.
    def setup
      require 'classifier' if self.lsi

      # If safe mode is off, load in any Ruby files under the plugins
      # directory.
      unless self.safe
        Dir[File.join(self.plugins, "**/*.rb")].each do |f|
          require f
        end
      end

      self.converters = build_plugins(Jekyll::Converter.subclasses)
      self.generators = build_plugins(Jekyll::Generator.subclasses)
    end

    # Read Site data from disk and load it into internal data structures.
    #
    # Returns nothing.
    def read
      self.read_layouts
      self.read_directories
    end

    # Read all the files in <source>/<dir>/_layouts and create a new Layout
    # object with each one.
    #
    # Returns nothing.
    def read_layouts(dir = '')
      base = File.join(self.source, dir, "_layouts")

      valid_filenames_from base do |f|
        name = File.basename(f, '.*')
        self.layouts[name] = Layout.new(self, base, f)
      end
    end

    # Recursively traverse directories to find posts, pages and static files
    # that will become part of the site according to the rules in
    # filter_entries.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_directories(dir = '')
      base = File.join(self.source, dir)

      read_posts(dir)

      valid_filenames_from(base, :pattern => '**/*') do |f|
        if File.directory?(f)
          read_posts(f)
        elsif f !~ /_posts/
          # we're not processing files in the _posts directories
          first3 = File.open(f) { |fd| fd.read(3) }
          if first3 == "---"
            # file appears to have a YAML header so process it as a page
            pages << Page.new(self, self.source, File.dirname(f), File.basename(f))
          else
            # otherwise treat it as a static file
            static_files << StaticFile.new(self, self.source, File.dirname(f), File.basename(f))
          end
        end
      end
    end

    # Recursively read all the files in <source>/<dir>/_posts and create
    # a new Post object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_posts(dir)
      base = File.join(self.source, dir, '_posts')

      # first pass processes, but does not yet render post content
      valid_filenames_from(base, :pattern => '**/*.*') do |f|
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

      # limit the posts if :limit_posts option is set
      self.posts = self.posts[-limit_posts, limit_posts] if limit_posts
    end

    # Run each of the Generators.
    #
    # Returns nothing.
    def generate
      self.generators.each do |generator|
        generator.generate(self)
      end
    end

    # Render the site to the destination.
    #
    # Returns nothing.
    def render
      inner_elements_of(posts, pages) do |el|
        el.send(:render, layouts, site_payload)
      end

      self.categories.values.map { |ps| ps.sort! { |a, b| b <=> a } }
      self.tags.values.map { |ps| ps.sort! { |a, b| b <=> a } }
    rescue Errno::ENOENT => e
      # ignore missing layout dir
    end

    # Remove orphaned files and empty directories in destination.
    #
    # Returns nothing.
    def cleanup
      # all files and directories in destination, including hidden ones
      dest_files = Set.new
      Dir.glob(File.join(self.dest, "**", "*"), File::FNM_DOTMATCH) do |file|
        dest_files << file unless file =~ /\/\.{1,2}$/
      end

      # files to be written
      files = Set.new
      inner_elements_of(posts, pages, static_files) do |el|
        files << el.send(:destination, dest)
      end

      # adding files' parent directories
      dirs = Set.new
      files.each { |file| dirs << File.dirname(file) }
      files.merge(dirs)

      obsolete_files = dest_files - files

      FileUtils.rm_rf(obsolete_files.to_a)
    end

    # Write static files, pages, and posts.
    #
    # Returns nothing.
    def write
      inner_elements_of(posts, pages, static_files) do |el|
        el.send(:write, dest)
      end
    end

    # Constructs a Hash of Posts indexed by the specified Post attribute.
    #
    # post_attr - The String name of the Post attribute.
    #
    # Examples
    #
    #   post_attr_hash('categories')
    #   # => { 'tech' => [<Post A>, <Post B>],
    #   #      'ruby' => [<Post B>] }
    #
    # Returns the Hash: { attr => posts } where
    #   attr  - One of the values for the requested attribute.
    #   posts - The Array of Posts with the given attr value.
    def post_attr_hash(post_attr)
      # Build a hash map based on the specified post attribute ( post attr =>
      # array of posts ) then sort each array in reverse order.
      hash = Hash.new { |hsh, key| hsh[key] = Array.new }
      self.posts.each { |p| p.send(post_attr.to_sym).each { |t| hash[t] << p } }
      hash.values.map { |sortme| sortme.sort! { |a, b| b <=> a } }
      hash
    end

    # The Hash payload containing site-wide data.
    #
    # Returns the Hash: { "site" => data } where data is a Hash with keys:
    #   "time"       - The Time as specified in the configuration or the
    #                  current time if none was specified.
    #   "posts"      - The Array of Posts, sorted chronologically by post date
    #                  and then title.
    #   "pages"      - The Array of all Pages.
    #   "html_pages" - The Array of HTML Pages.
    #   "categories" - The Hash of category values and Posts.
    #                  See Site#post_attr_hash for type info.
    #   "tags"       - The Hash of tag values and Posts.
    #                  See Site#post_attr_hash for type info.
    def site_payload
      {"site" => self.config.merge({
          "time"       => self.time,
          "posts"      => self.posts.sort { |a, b| b <=> a },
          "pages"      => self.pages,
          "html_pages" => self.pages.reject { |page| !page.html? },
          "categories" => post_attr_hash('categories'),
          "tags"       => post_attr_hash('tags')})}
    end

    # Filter out any files/directories that are hidden or backup files (start
    # with "." or "#" or end with "~"), or contain site content (start with "_"),
    # or are excluded in the site configuration, unless they are web server
    # files such as '.htaccess'.
    #
    # entries - The Array of file/directory entries to filter.
    #
    # Returns the Array of filtered entries.
    def filter_entries(entries)
      entries.reject do |e|
        unless ['.htaccess'].include?(e)
          ['.', '_', '#'].include?(e[0..0]) ||
          e[-1..-1] == '~' ||
          self.exclude.include?(e) ||
          File.symlink?(e)
        end
      end
    end

    # Get the implementation class for the given Converter.
    #
    # klass - The Class of the Converter to fetch.
    #
    # Returns the Converter instance implementing the given Converter.
    def getConverterImpl(klass)
      matches = self.converters.select { |c| c.class == klass }
      if impl = matches.first
        impl
      else
        raise "Converter implementation not found for #{klass}"
      end
    end

    private

    # Collect safe plugins (or all plugins if Safe mode is off) and initialize
    # them with the Site config.
    #
    # Returns Array.
    def build_plugins(plugin_array)
      plugin_array.select do |c|
        !self.safe || c.safe
      end.map do |c|
        c.new(self.config)
      end
    end

    # Collect valid files/directories from supplied path and pass their names
    # with relative paths to the block.
    # Changes current directory inside the block to the given path.
    #
    # opt — hash, which can include
    # :pattern key (the same as Dir.glob pattern). Default pattern is "*.*".
    #
    # Returns nothing.
    def valid_filenames_from(path, opt = {})
      return unless File.exists?(path)

      pattern = opt[:pattern] || '*.*'

      Dir.chdir(path) do
        filter_entries(Dir[pattern]).each { |f| yield f }
      end
    end

    # Iterate through all given arguments and if they are array too,
    # pass each inner element to the block.
    #
    # Returns nothing.
    def inner_elements_of(*args)
      args.each do |el|
        el.is_a?(Array) && el.each { |innner| yield innner }
      end
    end
  end
end
