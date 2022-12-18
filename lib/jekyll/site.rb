# frozen_string_literal: true

module Jekyll
  class Site
    attr_accessor :baseurl, :converters, :data, :drafts, :exclude,
                  :file_read_opts, :future, :gems, :generators, :highlighter,
                  :include, :inclusions, :keep_files, :layouts, :limit_posts,
                  :lsi, :pages, :permalink_style, :plugin_manager, :plugins,
                  :reader, :safe, :show_drafts, :static_files, :theme, :time,
                  :unpublished

    attr_reader :cache_dir, :config, :dest, :filter_cache, :includes_load_paths,
                :liquid_renderer, :profiler, :regenerator, :source

    # Public: Initialize a new Site.
    #
    # config - A Hash containing site configuration details.
    def initialize(config)
      # Source and destination may not be changed after the site has been created.
      @source          = File.expand_path(config["source"]).freeze
      @dest            = File.expand_path(config["destination"]).freeze

      self.config = config

      @cache_dir       = in_source_dir(config["cache_dir"])
      @filter_cache    = {}

      @reader          = Reader.new(self)
      @profiler        = Profiler.new(self)
      @regenerator     = Regenerator.new(self)
      @liquid_renderer = LiquidRenderer.new(self)

      Jekyll.sites << self

      reset
      setup

      Jekyll::Hooks.trigger :site, :after_init, self
    end

    # Public: Set the site's configuration. This handles side-effects caused by
    # changing values in the configuration.
    #
    # config - a Jekyll::Configuration, containing the new configuration.
    #
    # Returns the new configuration.
    def config=(config)
      @config = config.clone

      %w(safe lsi highlighter baseurl exclude include future unpublished
         show_drafts limit_posts keep_files).each do |opt|
        send("#{opt}=", config[opt])
      end

      # keep using `gems` to avoid breaking change
      self.gems = config["plugins"]

      configure_cache
      configure_plugins
      configure_theme
      configure_include_paths
      configure_file_read_opts

      self.permalink_style = config["permalink"].to_sym

      # Read in a _config.yml from the current theme-gem at the very end.
      @config = load_theme_configuration(config) if theme
      @config
    end

    # Public: Read, process, and write this Site to output.
    #
    # Returns nothing.
    def process
      return profiler.profile_process if config["profile"]

      reset
      read
      generate
      render
      cleanup
      write
    end

    def print_stats
      Jekyll.logger.info @liquid_renderer.stats_table
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    #
    # Reset Site details.
    #
    # Returns nothing
    def reset
      self.time = if config["time"]
                    Utils.parse_date(config["time"].to_s, "Invalid time in _config.yml.")
                  else
                    Time.now
                  end
      self.layouts = {}
      self.inclusions = {}
      self.pages = []
      self.static_files = []
      self.data = {}
      @post_attr_hash = {}
      @site_data = nil
      @collections = nil
      @documents = nil
      @docs_to_write = nil
      @regenerator.clear_cache
      @liquid_renderer.reset
      @site_cleaner = nil
      frontmatter_defaults.reset

      raise ArgumentError, "limit_posts must be a non-negative number" if limit_posts.negative?

      Jekyll::Cache.clear_if_config_changed config
      Jekyll::Hooks.trigger :site, :after_reset, self
      nil
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    # Load necessary libraries, plugins, converters, and generators.
    #
    # Returns nothing.
    def setup
      ensure_not_in_dest

      plugin_manager.conscientious_require

      self.converters = instantiate_subclasses(Jekyll::Converter)
      self.generators = instantiate_subclasses(Jekyll::Generator)
    end

    # Check that the destination dir isn't the source dir or a directory
    # parent to the source dir.
    def ensure_not_in_dest
      dest_pathname = Pathname.new(dest)
      Pathname.new(source).ascend do |path|
        if path == dest_pathname
          raise Errors::FatalException,
                "Destination directory cannot be or contain the Source directory."
        end
      end
    end

    # The list of collections and their corresponding Jekyll::Collection instances.
    # If config['collections'] is set, a new instance is created
    # for each item in the collection, a new hash is returned otherwise.
    #
    # Returns a Hash containing collection name-to-instance pairs.
    def collections
      @collections ||= collection_names.each_with_object({}) do |name, hsh|
        hsh[name] = Jekyll::Collection.new(self, name)
      end
    end

    # The list of collection names.
    #
    # Returns an array of collection names from the configuration,
    #   or an empty array if the `collections` key is not set.
    def collection_names
      case config["collections"]
      when Hash
        config["collections"].keys
      when Array
        config["collections"]
      when nil
        []
      else
        raise ArgumentError, "Your `collections` key must be a hash or an array."
      end
    end

    # Read Site data from disk and load it into internal data structures.
    #
    # Returns nothing.
    def read
      reader.read
      limit_posts!
      Jekyll::Hooks.trigger :site, :post_read, self
      nil
    end

    # Run each of the Generators.
    #
    # Returns nothing.
    def generate
      generators.each do |generator|
        start = Time.now
        generator.generate(self)
        Jekyll.logger.debug "Generating:",
                            "#{generator.class} finished in #{Time.now - start} seconds."
      end
      nil
    end

    # Render the site to the destination.
    #
    # Returns nothing.
    def render
      relative_permalinks_are_deprecated

      payload = site_payload

      Jekyll::Hooks.trigger :site, :pre_render, self, payload

      render_docs(payload)
      render_pages(payload)

      Jekyll::Hooks.trigger :site, :post_render, self, payload
      nil
    end

    # Remove orphaned files and empty directories in destination.
    #
    # Returns nothing.
    def cleanup
      site_cleaner.cleanup!
      nil
    end

    # Write static files, pages, and posts.
    #
    # Returns nothing.
    def write
      Jekyll::Commands::Doctor.conflicting_urls(self)
      each_site_file do |item|
        item.write(dest) if regenerator.regenerate?(item)
      end
      regenerator.write_metadata
      Jekyll::Hooks.trigger :site, :post_write, self
      nil
    end

    def posts
      collections["posts"] ||= Collection.new(self, "posts")
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
      @post_attr_hash[post_attr] ||= begin
        hash = Hash.new { |h, key| h[key] = [] }
        posts.docs.each do |p|
          p.data[post_attr]&.each { |t| hash[t] << p }
        end
        hash.each_value { |posts| posts.sort!.reverse! }
        hash
      end
    end

    def tags
      post_attr_hash("tags")
    end

    def categories
      post_attr_hash("categories")
    end

    # Prepare site data for site payload. The method maintains backward compatibility
    # if the key 'data' is already used in _config.yml.
    #
    # Returns the Hash to be hooked to site.data.
    def site_data
      @site_data ||= (config["data"] || data)
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
      Drops::UnifiedPayloadDrop.new self
    end
    alias_method :to_liquid, :site_payload

    # Get the implementation class for the given Converter.
    # Returns the Converter instance implementing the given Converter.
    # klass - The Class of the Converter to fetch.
    def find_converter_instance(klass)
      @find_converter_instance ||= {}
      @find_converter_instance[klass] ||= converters.find do |converter|
        converter.instance_of?(klass)
      end || \
        raise("No Converters found for #{klass}")
    end

    # klass - class or module containing the subclasses.
    # Returns array of instances of subclasses of parameter.
    # Create array of instances of the subclasses of the class or module
    # passed in as argument.

    def instantiate_subclasses(klass)
      klass.descendants.select { |c| !safe || c.safe }.tap do |result|
        result.sort!
        result.map! { |c| c.new(config) }
      end
    end

    # Warns the user if permanent links are relative to the parent
    # directory. As this is a deprecated function of Jekyll.
    #
    # Returns
    def relative_permalinks_are_deprecated
      if config["relative_permalinks"]
        Jekyll.logger.abort_with "Since v3.0, permalinks for pages " \
                                 "in subfolders must be relative to the " \
                                 "site source directory, not the parent " \
                                 "directory. Check https://jekyllrb.com/docs/upgrading/ " \
                                 "for more info."
      end
    end

    # Get the to be written documents
    #
    # Returns an Array of Documents which should be written
    def docs_to_write
      documents.select(&:write?)
    end

    # Get the to be written static files
    #
    # Returns an Array of StaticFiles which should be written
    def static_files_to_write
      static_files.select(&:write?)
    end

    # Get all the documents
    #
    # Returns an Array of all Documents
    def documents
      collections.each_with_object(Set.new) do |(_, collection), set|
        set.merge(collection.docs).merge(collection.files)
      end.to_a
    end

    def each_site_file
      pages.each { |page| yield page }
      static_files.each { |file| yield(file) if file.write? }
      collections.each_value { |coll| coll.docs.each { |doc| yield(doc) if doc.write? } }
    end

    # Returns the FrontmatterDefaults or creates a new FrontmatterDefaults
    # if it doesn't already exist.
    #
    # Returns The FrontmatterDefaults
    def frontmatter_defaults
      @frontmatter_defaults ||= FrontmatterDefaults.new(self)
    end

    # Whether to perform a full rebuild without incremental regeneration
    #
    # Returns a Boolean: true for a full rebuild, false for normal build
    def incremental?(override = {})
      override["incremental"] || config["incremental"]
    end

    # Returns the publisher or creates a new publisher if it doesn't
    # already exist.
    #
    # Returns The Publisher
    def publisher
      @publisher ||= Publisher.new(self)
    end

    # Public: Prefix a given path with the source directory.
    #
    # paths - (optional) path elements to a file or directory within the
    #         source directory
    #
    # Returns a path which is prefixed with the source directory.
    def in_source_dir(*paths)
      paths.reduce(source) do |base, path|
        Jekyll.sanitized_path(base, path)
      end
    end

    # Public: Prefix a given path with the theme directory.
    #
    # paths - (optional) path elements to a file or directory within the
    #         theme directory
    #
    # Returns a path which is prefixed with the theme root directory.
    def in_theme_dir(*paths)
      return nil unless theme

      paths.reduce(theme.root) do |base, path|
        Jekyll.sanitized_path(base, path)
      end
    end

    # Public: Prefix a given path with the destination directory.
    #
    # paths - (optional) path elements to a file or directory within the
    #         destination directory
    #
    # Returns a path which is prefixed with the destination directory.
    def in_dest_dir(*paths)
      paths.reduce(dest) do |base, path|
        Jekyll.sanitized_path(base, path)
      end
    end

    # Public: Prefix a given path with the cache directory.
    #
    # paths - (optional) path elements to a file or directory within the
    #         cache directory
    #
    # Returns a path which is prefixed with the cache directory.
    def in_cache_dir(*paths)
      paths.reduce(cache_dir) do |base, path|
        Jekyll.sanitized_path(base, path)
      end
    end

    # Public: The full path to the directory that houses all the collections registered
    # with the current site.
    #
    # Returns the source directory or the absolute path to the custom collections_dir
    def collections_path
      dir_str = config["collections_dir"]
      @collections_path ||= dir_str.empty? ? source : in_source_dir(dir_str)
    end

    # Public
    #
    # Returns the object as a debug String.
    def inspect
      "#<#{self.class} @source=#{@source}>"
    end

    private

    def load_theme_configuration(config)
      return config if config["ignore_theme_config"] == true

      theme_config_file = in_theme_dir("_config.yml")
      return config unless File.exist?(theme_config_file)

      # Bail out if the theme_config_file is a symlink file irrespective of safe mode
      return config if File.symlink?(theme_config_file)

      theme_config = SafeYAML.load_file(theme_config_file)
      return config unless theme_config.is_a?(Hash)

      Jekyll.logger.info "Theme Config file:", theme_config_file

      # theme_config should not be overriding Jekyll's defaults
      theme_config.delete_if { |key, _| Configuration::DEFAULTS.key?(key) }

      # Override theme_config with existing config and return the result.
      # Additionally ensure we return a `Jekyll::Configuration` instance instead of a Hash.
      Utils.deep_merge_hashes(theme_config, config)
        .each_with_object(Jekyll::Configuration.new) do |(key, value), conf|
          conf[key] = value
        end
    end

    # Limits the current posts; removes the posts which exceed the limit_posts
    #
    # Returns nothing
    def limit_posts!
      if limit_posts.positive?
        limit = posts.docs.length < limit_posts ? posts.docs.length : limit_posts
        posts.docs = posts.docs[-limit, limit]
      end
    end

    # Returns the Cleaner or creates a new Cleaner if it doesn't
    # already exist.
    #
    # Returns The Cleaner
    def site_cleaner
      @site_cleaner ||= Cleaner.new(self)
    end

    def hide_cache_dir_from_git
      @cache_gitignore_path ||= in_source_dir(config["cache_dir"], ".gitignore")
      return if File.exist?(@cache_gitignore_path)

      cache_dir_path = in_source_dir(config["cache_dir"])
      FileUtils.mkdir_p(cache_dir_path) unless File.directory?(cache_dir_path)

      File.open(@cache_gitignore_path, "wb") do |file|
        file.puts("# ignore everything in this directory\n*")
      end
    end

    # Disable Marshaling cache to disk in Safe Mode
    def configure_cache
      Jekyll::Cache.cache_dir = in_source_dir(config["cache_dir"], "Jekyll/Cache")
      if safe || config["disable_disk_cache"]
        Jekyll::Cache.disable_disk_cache!
      else
        hide_cache_dir_from_git
      end
    end

    def configure_plugins
      self.plugin_manager = Jekyll::PluginManager.new(self)
      self.plugins        = plugin_manager.plugins_path
    end

    def configure_theme
      self.theme = nil
      return if config["theme"].nil?

      self.theme =
        if config["theme"].is_a?(String)
          Jekyll::Theme.new(config["theme"])
        else
          Jekyll.logger.warn "Theme:", "value of 'theme' in config should be String to use " \
                                       "gem-based themes, but got #{config["theme"].class}"
          nil
        end
    end

    def configure_include_paths
      @includes_load_paths = Array(in_source_dir(config["includes_dir"].to_s))
      @includes_load_paths << theme.includes_path if theme&.includes_path
    end

    def configure_file_read_opts
      self.file_read_opts = {}
      file_read_opts[:encoding] = config["encoding"] if config["encoding"]
      self.file_read_opts = Jekyll::Utils.merged_file_read_opts(self, {})
    end

    def render_docs(payload)
      collections.each_value do |collection|
        collection.docs.each do |document|
          render_regenerated(document, payload)
        end
      end
    end

    def render_pages(payload)
      pages.each do |page|
        render_regenerated(page, payload)
      end
    end

    def render_regenerated(document, payload)
      return unless regenerator.regenerate?(document)

      document.renderer.payload = payload
      document.output = document.renderer.run
      document.trigger_hooks(:post_render)
    end
  end
end
