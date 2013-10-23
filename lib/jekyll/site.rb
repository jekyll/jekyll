module Jekyll
  class Site
    attr_accessor :config, :layouts, :posts, :pages, :static_files,
                  :categories, :exclude, :include, :source, :dest, :lsi, :pygments,
                  :permalink_style, :tags, :time, :future, :safe, :plugins, :limit_posts,
                  :show_drafts, :keep_files, :baseurl, :data, :file_read_opts, :locale_active

    attr_accessor :converters, :generators

    # Public: Initialize a new Site.
    #
    # config - A Hash containing site configuration details.
    def initialize(config)
      self.config          = config.clone

      %w[safe lsi pygments baseurl exclude include future show_drafts limit_posts keep_files].each do |opt|
        self.send("#{opt}=", config[opt])
      end

      self.source          = File.expand_path(config['source'])
      self.dest            = File.expand_path(config['destination'])
      self.plugins         = plugins_path
      self.permalink_style = config['permalink'].to_sym

      self.file_read_opts = {}
      self.file_read_opts[:encoding] = config['encoding'] if config['encoding']

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
      self.data            = {}

      if self.limit_posts < 0
        raise ArgumentError, "limit_posts must be a non-negative number"
      end
    end

    # Load necessary libraries, plugins, converters, and generators.
    #
    # Returns nothing.
    def setup
      ensure_not_in_dest

      # If safe mode is off, load in any Ruby files under the plugins
      # directory.
      unless self.safe
        self.plugins.each do |plugins|
            Dir[File.join(plugins, "**/*.rb")].each do |f|
              require f
            end
        end
      end

      self.converters = instantiate_subclasses(Jekyll::Converter)
      self.generators = instantiate_subclasses(Jekyll::Generator)
    end

    # Check that the destination dir isn't the source dir or a directory
    # parent to the source dir.
    def ensure_not_in_dest
      dest = Pathname.new(self.dest)
      Pathname.new(self.source).ascend do |path|
        if path == dest
          raise FatalException.new "Destination directory cannot be or contain the Source directory."
        end
      end
    end

    # Internal: Setup the plugin search path
    #
    # Returns an Array of plugin search paths
    def plugins_path
      if (config['plugins'] == Jekyll::Configuration::DEFAULTS['plugins'])
        [File.join(self.source, config['plugins'])]
      else
        Array(config['plugins']).map { |d| File.expand_path(d) }
      end
    end

    # Read Site data from disk and load it into internal data structures.
    #
    # Returns nothing.
    def read
      self.read_layouts
      self.read_directories
      self.read_data(config['data_source'])
      self.read_locale
    end

    # Read all the files in <source>/<layouts> and create a new Layout object
    # with each one.
    #
    # Returns nothing.
    def read_layouts
      base = File.join(self.source, self.config['layouts'])
      return unless File.exists?(base)
      entries = []
      Dir.chdir(base) { entries = filter_entries(Dir['**/*.*']) }

      entries.each do |f|
        name = f.split(".")[0..-2].join(".")
        self.layouts[name] = Layout.new(self, base, f)
      end
    end

    # Recursively traverse directories to find posts, pages and static files
    # that will become part of the site according to the rules in
    # filter_entries.
    #
    # dir - The String relative path of the directory to read. Default: ''.
    #
    # Returns nothing.
    def read_directories(dir = '')
      base = File.join(self.source, dir)
      entries = Dir.chdir(base) { filter_entries(Dir.entries('.')) }

      self.read_posts(dir)
      self.read_drafts(dir) if self.show_drafts
      self.posts.sort!
      limit_posts! if limit_posts > 0 # limit the posts if :limit_posts option is set

      entries.each do |f|
        f_abs = File.join(base, f)
        if File.directory?(f_abs)
          f_rel = File.join(dir, f)
          read_directories(f_rel) unless self.dest.sub(/\/$/, '') == f_abs
        elsif has_yaml_header?(f_abs)
          pages << Page.new(self, self.source, dir, f)
        else
          static_files << StaticFile.new(self, self.source, dir, f)
        end
      end
    end

    # Read all the files in <source>/<dir>/_posts and create a new Post
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_posts(dir)
      entries = get_entries(dir, '_posts')

      # first pass processes, but does not yet render post content
      entries.each do |f|
        if Post.valid?(f)
          post = Post.new(self, self.source, dir, f)

          if post.published && (self.future || post.date <= self.time)
            aggregate_post_info(post)
          end
        end
      end
    end

    # Read all the files in <source>/<dir>/_drafts and create a new Post
    # object with each one.
    #
    # dir - The String relative path of the directory to read.
    #
    # Returns nothing.
    def read_drafts(dir)
      entries = get_entries(dir, '_drafts')

      # first pass processes, but does not yet render draft content
      entries.each do |f|
        if Draft.valid?(f)
          draft = Draft.new(self, self.source, dir, f)

          aggregate_post_info(draft)
        end
      end
    end

    # Read and parse all yaml files under <source>/<dir>
    #
    # Returns nothing
    def read_data(dir)
      base = File.join(self.source, dir)
      return unless File.directory?(base) && (!self.safe || !File.symlink?(base))

      entries = Dir.chdir(base) { Dir['*.{yaml,yml}'] }
      entries.delete_if { |e| File.directory?(File.join(base, e)) }

      entries.each do |entry|
        path = File.join(self.source, dir, entry)
        next if File.symlink?(path) && self.safe

        key = sanitize_filename(File.basename(entry, '.*'))
        self.data[key] = YAML.safe_load_file(path)
      end
    end

    # Read the locale from the translation path and set the r18n environment
    #
    # Returns nothing
    def read_locale
      locale_path = config['translation_path']
      @locale_active = File.exists? locale_path
      R18n.set(config['locale'], locale_path)
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
      relative_permalinks_deprecation_method

      payload = site_payload
      [self.posts, self.pages].flatten.each do |page_or_post|
        page_or_post.render(self.layouts, payload)
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
      site_cleaner.cleanup!
    end

    # Write static files, pages, and posts.
    #
    # Returns nothing.
    def write
      each_site_file { |item| item.write(self.dest) }
    end

    # Construct a Hash of Posts indexed by the specified Post attribute.
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

    # Prepare site data for site payload. The method maintains backward compatibility
    # if the key 'data' is already used in _config.yml.
    #
    # Returns the Hash to be hooked to site.data.
    def site_data
      self.config['data'] || self.data
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
      {"jekyll" => { "version" => Jekyll::VERSION },
       "site" => self.config.merge({
          "time"       => self.time,
          "posts"      => self.posts.sort { |a, b| b <=> a },
          "pages"      => self.pages,
          "html_pages" => self.pages.reject { |page| !page.html? },
          "categories" => post_attr_hash('categories'),
          "tags"       => post_attr_hash('tags'),
          "data"       => site_data})}
    end

    # Filter out any files/directories that are hidden or backup files (start
    # with "." or "#" or end with "~"), or contain site content (start with "_"),
    # or are excluded in the site configuration, unless they are web server
    # files such as '.htaccess'.
    #
    # entries - The Array of String file/directory entries to filter.
    #
    # Returns the Array of filtered entries.
    def filter_entries(entries)
      entries.reject do |e|
        unless self.include.glob_include?(e)
          ['.', '_', '#'].include?(e[0..0]) ||
          e[-1..-1] == '~' ||
          self.exclude.glob_include?(e) ||
          (File.symlink?(e) && self.safe)
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

    # Create array of instances of the subclasses of the class or module
    #   passed in as argument.
    #
    # klass - class or module containing the subclasses which should be
    #         instantiated
    #
    # Returns array of instances of subclasses of parameter
    def instantiate_subclasses(klass)
      klass.subclasses.select do |c|
        !self.safe || c.safe
      end.sort.map do |c|
        c.new(self.config)
      end
    end

    # Read the entries from a particular directory for processing
    #
    # dir - The String relative path of the directory to read
    # subfolder - The String directory to read
    #
    # Returns the list of entries to process
    def get_entries(dir, subfolder)
      base = File.join(self.source, dir, subfolder)
      return [] unless File.exists?(base)
      entries = Dir.chdir(base) { filter_entries(Dir['**/*']) }
      entries.delete_if { |e| File.directory?(File.join(base, e)) }
    end

    # Aggregate post information
    #
    # post - The Post object to aggregate information for
    #
    # Returns nothing
    def aggregate_post_info(post)
      self.posts << post
      post.categories.each { |c| self.categories[c] << post }
      post.tags.each { |c| self.tags[c] << post }
    end

    def relative_permalinks_deprecation_method
      if config['relative_permalinks'] && has_relative_page?
        $stderr.puts # Places newline after "Generating..."
        Jekyll.logger.warn "Deprecation:", "Starting in 1.1, permalinks for pages" +
                                            " in subfolders must be relative to the" +
                                            " site source directory, not the parent" +
                                            " directory. Check http://jekyllrb.com/docs/upgrading/"+
                                            " for more info."
        $stderr.print Jekyll.logger.formatted_topic("") + "..." # for "done."
      end
    end

    def each_site_file
      %w(posts pages static_files).each do |type|
        self.send(type).each do |item|
          yield item
        end
      end
    end

    private

    def has_relative_page?
      self.pages.any? { |page| page.uses_relative_permalinks }
    end

    def has_yaml_header?(file)
      "---" == File.open(file) { |fd| fd.read(3) }
    end

    def limit_posts!
      limit = self.posts.length < limit_posts ? self.posts.length : limit_posts
      self.posts = self.posts[-limit, limit]
    end

    def site_cleaner
      @site_cleaner ||= Cleaner.new(self)
    end

    def sanitize_filename(name)
      name = name.gsub(/[^\w\s_-]+/, '')
      name = name.gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
      name = name.gsub(/\s+/, '_')
    end
  end
end
