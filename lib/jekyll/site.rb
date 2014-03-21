module Jekyll
  class Site
    attr_accessor :config, :layouts, :posts, :pages, :static_files,
                  :categories, :exclude, :include, :source, :destination, :lsi, :highlighter,
                  :permalink_style, :tags, :time, :future, :safe, :plugins, :limit_posts,
                  :show_drafts, :keep_files, :baseurl, :data, :file_read_opts, :gems

    attr_accessor :converters, :generators

    # Public: Initialize a new Site.
    #
    # config - A Hash containing site configuration details.
    def initialize(config)
      self.config = config.clone

      %w[safe lsi highlighter baseurl exclude include future show_drafts limit_posts keep_files gems].each do |opt|
        self.send("#{opt}=", config[opt])
      end

      self.source = File.expand_path(config['source'])
      self.destination = File.expand_path(config['destination'])
      self.plugins = plugins_path

      self.file_read_opts = {}
      self.file_read_opts[:encoding] = config['encoding'] if config['encoding']

      if limit_posts < 0
        raise ArgumentError, "limit_posts must be a non-negative number"
      end

      ensure_not_in_dest
      reset
      setup
    end

    # Public: Read, process, and write this Site to output.
    #
    # Returns nothing.
    def process
      reset
      read
      generate
      render
      cleanup
      write
    end

    # Reset Site details.
    #
    # Returns nothing
    def reset
      self.time = (config['time'] ? Time.parse(config['time'].to_s) : Time.now)
      self.layouts = {}
      self.files = []
      self.static_files = []
      self.categories = Hash.new { |hash, key| hash[key] = [] }
      self.tags = Hash.new { |hash, key| hash[key] = [] }
      self.data = {}
    end

    # Load necessary libraries, plugins, converters, and generators.
    #
    # Returns nothing.
    def setup
      # If safe mode is off, load in any Ruby files under the plugins
      # directory.
      unless safe
        plugins.each do |plugins|
          Dir[File.join(plugins, "**/*.rb")].sort.each do |f|
            require f
          end
        end
      end

      require_gems

      self.converters = instantiate_subclasses(Jekyll::Converter)
      self.generators = instantiate_subclasses(Jekyll::Generator)
    end

    # Check that the destination dir isn't the source dir or a directory
    # parent to the source dir.
    def ensure_not_in_dest
      dest_pathname = Pathname.new(destination)
      Pathname.new(source).ascend do |path|
        if path == dest_pathname
          raise FatalException.new "Destination directory cannot be or contain the Source directory."
        end
      end
    end

    def require_gems
      gems.each do |gem|
        if plugin_allowed?(gem)
          require gem
        end
      end
    end

    def plugin_allowed?(gem_name)
      whitelist.include?(gem_name) || !safe
    end

    def whitelist
      @whitelist ||= Array[config['whitelist']].flatten
    end

    # Internal: Setup the plugin search path
    #
    # Returns an Array of plugin search paths
    def plugins_path
      if (config['plugins'] == Jekyll::Configuration::DEFAULTS['plugins'])
        [File.join(source, config['plugins'])]
      else
        Array(config['plugins']).map { |d| File.expand_path(d) }
      end
    end

    # Recursively traverse source directory to find posts, pages, layouts 
    # and static filesthat will become part of the site according to the rules
    # in filter_entries.
    #
    # Returns nothing.
    def read
      filter_entries(Dir["#{source}/**/{*,.*}"]).each do |path|
        begin
          klass = if File.directory?(path)
            nil
          elsif path =~ /#{config['layouts']}/
            ext = File.extname(path)
            name = File.basename(path, ext)
            layouts[name] = Layout.new(self, path)
            nil
          elsif path =~ /_posts/
            Post
          elsif path =~ /_drafts/ && show_drafts
            Draft
          elsif path.sub(source, '') =~ /\/_/
            nil
          elsif has_yaml_header?(path)
            Page
          else
            StaticFile
          end
          files << klass.new(self, path) if klass
        rescue NameError
          Jekyll.logger.warn "Warning:", "Invalid filename on #{path}"
        rescue RangeError
        end
      end
      posts.sort!
      limit_posts! if limit_posts > 0 # limit the posts if :limit_posts option is set
    end

    def posts
      files.select { |file| file.is_a?Post }.sort
    end

    def posts=(posts)
      files.delete_if { |file| file.is_a?Post }
      files.concat(posts)
    end

    def pages
      files.select { |file| file.is_a?Page }
    end

    def static_files
      files.select { |file| file.is_a?StaticFile }
    end

    # Run each of the Generators.
    #
    # Returns nothing.
    def generate
      generators.each do |generator|
        generator.generate(self)
      end
    end

    # Render the site to the destination.
    #
    # Returns nothing.
    def render
      relative_permalinks_deprecation_method

      payload = site_payload
      [posts, pages].flatten.each do |page_or_post|
        page_or_post.render(layouts, payload)
      end

      categories.values.map { |ps| ps.sort! { |a, b| b <=> a } }
      tags.values.map { |ps| ps.sort! { |a, b| b <=> a } }
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
      files.each { |item| item.write(destination) }
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
      hash = Hash.new { |hash, key| hash[key] = [] }
      posts.each { |p| p.send(post_attr.to_sym).each { |t| hash[t] << p } }
      hash.values.map { |sortme| sortme.sort! { |a, b| b <=> a } }
      hash
    end

    # Prepare site data for site payload. The method maintains backward compatibility
    # if the key 'data' is already used in _config.yml.
    #
    # Returns the Hash to be hooked to site.data.
    def site_data
      config['data'] || data
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
       "site" => config.merge({
          "time"         => time,
          "posts"        => posts.sort { |a, b| b <=> a },
          "pages"        => pages,
          "static_files" => static_files.sort { |a, b| a.relative_path <=> b.relative_path },
          "html_pages"   => pages.reject { |page| !page.html? },
          "categories"   => post_attr_hash('categories'),
          "tags"         => post_attr_hash('tags'),
          "data"         => site_data})}
    end

    # Filter out any files/directories that are hidden or backup files (start
    # with "." or "#" or end with "~"), or contain site content (start with "_"),
    # or are excluded in the site configuration, unless they are web server
    # files such as '.htaccess'.
    #
    # entries - The Array of String file/directory entries to filter.
    #
    # Returns the Array of filtered entries.
    def filter_entries(entries, base_directory = nil)
      EntryFilter.new(self, base_directory).filter(entries)
    end

    def filter_exclude?(entry)
      exclude.glob_include?(entry.sub("#{source}/", ''))
    end

    def filter_include?(entry)
      include.glob_include?(entry.sub("#{source}/", ''))
    end

    # Get the implementation class for the given Converter.
    #
    # klass - The Class of the Converter to fetch.
    #
    # Returns the Converter instance implementing the given Converter.
    def getConverterImpl(klass)
      matches = converters.select { |c| c.class == klass }
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
        !safe || c.safe
      end.sort.map do |c|
        c.new(config)
      end
    end

    # Read the entries from a particular directory for processing
    #
    # dir - The String relative path of the directory to read
    # subfolder - The String directory to read
    #
    # Returns the list of entries to process
    def get_entries(dir, subfolder)
      base = File.join(source, dir, subfolder)
      return [] unless File.exists?(base)
      entries = Dir.chdir(base) { filter_entries(Dir['**/*'], base) }
      entries.delete_if { |e| File.directory?(File.join(base, e)) }
    end

    # Aggregate post information
    #
    # post - The Post object to aggregate information for
    #
    # Returns nothing
    def aggregate_post_info(post)
      posts << post
      post.categories.each { |c| categories[c] << post }
      post.tags.each { |c| tags[c] << post }
    end

    def each_site_file
      %w(posts pages static_files).each do |type|
        send(type).each do |item|
          yield item
        end
      end
    end

    private

    def has_relative_page?
      pages.any? { |page| page.uses_relative_permalinks }
    end

    def has_yaml_header?(file)
      "---" == File.open(file) { |fd| fd.read(3) }
    end

    def limit_posts!
      limit = posts.length < limit_posts ? posts.length : limit_posts
      self.posts = posts[-limit, limit]
    end

    def site_cleaner
      @site_cleaner ||= Cleaner.new(self)
    end

    def sanitize_filename(name)
      name.gsub!(/[^\w\s_-]+/, '')
      name.gsub!(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
      name.gsub(/\s+/, '_')
    end
  end
end
