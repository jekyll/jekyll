# encoding: UTF-8
# frozen_string_literal: true

require "csv"

module Jekyll
  class Site
    attr_reader   :source, :dest, :config
    attr_accessor :layouts, :pages, :static_files, :drafts,
                  :exclude, :include, :lsi, :highlighter, :permalink_style,
                  :time, :future, :unpublished, :safe, :plugins, :limit_posts,
                  :show_drafts, :keep_files, :baseurl, :data, :file_read_opts,
                  :gems, :plugin_manager, :theme

    attr_accessor :converters, :generators, :reader
    attr_reader   :regenerator, :liquid_renderer, :includes_load_paths

    # Public: Initialize a new Site.
    #
    # config - A Hash containing site configuration details.
    def initialize(config)
      # Source and destination may not be changed after the site has been created.
      @source          = File.expand_path(config["source"]).freeze
      @dest            = File.expand_path(config["destination"]).freeze

      self.config = config

      @reader          = Reader.new(self)
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
        self.send("#{opt}=", config[opt])
      end

      # keep using `gems` to avoid breaking change
      self.gems = config["plugins"]

      configure_plugins
      configure_theme
      configure_include_paths
      configure_file_read_opts

      self.permalink_style = config["permalink"].to_sym

      @config
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
      print_stats if config["profile"]
    end

    def print_stats
      puts @liquid_renderer.stats_table
    end

    # Reset Site details.
    #
    # Returns nothing
    def reset
      if config["time"]
        self.time = Utils.parse_date(config["time"].to_s, "Invalid time in _config.yml.")
      else
        self.time = Time.now
      end
      self.layouts = {}
      self.pages = []
      self.static_files = []
      self.data = {}
      @collections = nil
      @regenerator.clear_cache
      @liquid_renderer.reset

      if limit_posts < 0
        raise ArgumentError, "limit_posts must be a non-negative number"
      end

      Jekyll::Hooks.trigger :site, :after_reset, self
    end

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
          raise(
            Errors::FatalException,
            "Destination directory cannot be or contain the Source directory."
          )
        end
      end
    end

    # The list of collections and their corresponding Jekyll::Collection instances.
    # If config['collections'] is set, a new instance is created
    # for each item in the collection, a new hash is returned otherwise.
    #
    # Returns a Hash containing collection name-to-instance pairs.
    def collections
      @collections ||= Hash[collection_names.map do |coll|
        [coll, Jekyll::Collection.new(self, coll)]
      end]
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
      each_site_file do |item|
        item.write(dest) if regenerator.regenerate?(item)
      end
      regenerator.write_metadata
      Jekyll::Hooks.trigger :site, :post_write, self
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
      hash = Hash.new { |h, key| h[key] = [] }
      posts.docs.each do |p|
        p.data[post_attr].each { |t| hash[t] << p } if p.data[post_attr]
      end
      hash.values.each { |posts| posts.sort!.reverse! }
      hash
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
      config["data"] || data
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
      converters.find { |klass_| klass_.instance_of?(klass) } || \
        raise("No Converters found for #{klass}")
    end

    # klass - class or module containing the subclasses.
    # Returns array of instances of subclasses of parameter.
    # Create array of instances of the subclasses of the class or module
    # passed in as argument.

    def instantiate_subclasses(klass)
      klass.descendants.select { |c| !safe || c.safe }.sort.map do |c|
        c.new(config)
      end
    end

    # Warns the user if permanent links are relative to the parent
    # directory. As this is a deprecated function of Jekyll.
    #
    # Returns
    def relative_permalinks_are_deprecated
      if config["relative_permalinks"]
        Jekyll.logger.abort_with "Since v3.0, permalinks for pages" \
                                " in subfolders must be relative to the" \
                                " site source directory, not the parent" \
                                " directory. Check https://jekyllrb.com/docs/upgrading/"\
                                " for more info."
      end
    end

    # Get the to be written documents
    #
    # Returns an Array of Documents which should be written
    def docs_to_write
      documents.select(&:write?)
    end

    # Get all the documents
    #
    # Returns an Array of all Documents
    def documents
      collections.reduce(Set.new) do |docs, (_, collection)|
        docs + collection.docs + collection.files
      end.to_a
    end

    def each_site_file
      %w(pages static_files docs_to_write).each do |type|
        send(type).each do |item|
          yield item
        end
      end
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

    # Limits the current posts; removes the posts which exceed the limit_posts
    #
    # Returns nothing
    private
    def limit_posts!
      if limit_posts > 0
        limit = posts.docs.length < limit_posts ? posts.docs.length : limit_posts
        self.posts.docs = posts.docs[-limit, limit]
      end
    end

    # Returns the Cleaner or creates a new Cleaner if it doesn't
    # already exist.
    #
    # Returns The Cleaner
    private
    def site_cleaner
      @site_cleaner ||= Cleaner.new(self)
    end

    private
    def configure_plugins
      self.plugin_manager = Jekyll::PluginManager.new(self)
      self.plugins        = plugin_manager.plugins_path
    end

    private
    def configure_theme
      self.theme = nil
      return if config["theme"].nil?

      self.theme =
        if config["theme"].is_a?(String)
          Jekyll::Theme.new(config["theme"])
        else
          Jekyll.logger.warn "Theme:", "value of 'theme' in config should be " \
          "String to use gem-based themes, but got #{config["theme"].class}"
          nil
        end
    end

    private
    def configure_include_paths
      @includes_load_paths = Array(in_source_dir(config["includes_dir"].to_s))
      @includes_load_paths << theme.includes_path if theme && theme.includes_path
    end

    private
    def configure_file_read_opts
      self.file_read_opts = {}
      self.file_read_opts[:encoding] = config["encoding"] if config["encoding"]
    end

    private
    def render_docs(payload)
      collections.each do |_, collection|
        collection.docs.each do |document|
          if regenerator.regenerate?(document)
            document.output = Jekyll::Renderer.new(self, document, payload).run
            document.trigger_hooks(:post_render)
          end
        end
      end
    end

    private
    def render_pages(payload)
      pages.flatten.each do |page|
        if regenerator.regenerate?(page)
          page.output = Jekyll::Renderer.new(self, page, payload).run
          page.trigger_hooks(:post_render)
        end
      end
    end
  end
end
