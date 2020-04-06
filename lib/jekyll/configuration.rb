# frozen_string_literal: true

module Jekyll
  class Configuration < Hash
    # Default options. Overridden by values in _config.yml.
    # Strings rather than symbols are used for compatibility with YAML.
    DEFAULTS = {
      # Where things are
      "source"              => Dir.pwd,
      "destination"         => File.join(Dir.pwd, "_site"),
      "collections_dir"     => "",
      "cache_dir"           => ".jekyll-cache",
      "plugins_dir"         => "_plugins",
      "layouts_dir"         => "_layouts",
      "data_dir"            => "_data",
      "includes_dir"        => "_includes",
      "collections"         => {},

      # Handling Reading
      "safe"                => false,
      "include"             => [".htaccess"],
      "exclude"             => [],
      "keep_files"          => [".git", ".svn"],
      "encoding"            => "utf-8",
      "markdown_ext"        => "markdown,mkdown,mkdn,mkd,md",
      "strict_front_matter" => false,

      # Filtering Content
      "show_drafts"         => nil,
      "limit_posts"         => 0,
      "future"              => false,
      "unpublished"         => false,

      # Plugins
      "whitelist"           => [],
      "plugins"             => [],

      # Conversion
      "markdown"            => "kramdown",
      "highlighter"         => "rouge",
      "lsi"                 => false,
      "excerpt_separator"   => "\n\n",
      "incremental"         => false,

      # Serving
      "detach"              => false, # default to not detaching the server
      "port"                => "4000",
      "host"                => "127.0.0.1",
      "baseurl"             => nil, # this mounts at /, i.e. no subdirectory
      "show_dir_listing"    => false,

      # Output Configuration
      "permalink"           => "date",
      "paginate_path"       => "/page:num",
      "timezone"            => nil, # use the local timezone

      "quiet"               => false,
      "verbose"             => false,
      "defaults"            => [],

      "liquid"              => {
        "error_mode"       => "warn",
        "strict_filters"   => false,
        "strict_variables" => false,
      },

      "kramdown"            => {
        "auto_ids"      => true,
        "toc_levels"    => (1..6).to_a,
        "entity_output" => "as_char",
        "smart_quotes"  => "lsquo,rsquo,ldquo,rdquo",
        "input"         => "GFM",
        "hard_wrap"     => false,
        "guess_lang"    => true,
        "footnote_nr"   => 1,
        "show_warnings" => false,
      },
    }.each_with_object(Configuration.new) { |(k, v), hsh| hsh[k] = v.freeze }.freeze

    class << self
      # Static: Produce a Configuration ready for use in a Site.
      # It takes the input, fills in the defaults where values do not exist.
      #
      # user_config - a Hash or Configuration of overrides.
      #
      # Returns a Configuration filled with defaults.
      def from(user_config)
        Utils.deep_merge_hashes(DEFAULTS, Configuration[user_config].stringify_keys)
          .add_default_collections.add_default_excludes
      end
    end

    # Public: Turn all keys into string
    #
    # Return a copy of the hash where all its keys are strings
    def stringify_keys
      each_with_object({}) { |(k, v), hsh| hsh[k.to_s] = v }
    end

    def get_config_value_with_override(config_key, override)
      override[config_key] || self[config_key] || DEFAULTS[config_key]
    end

    # Public: Directory of the Jekyll source folder
    #
    # override - the command-line options hash
    #
    # Returns the path to the Jekyll source directory
    def source(override)
      get_config_value_with_override("source", override)
    end

    def quiet(override = {})
      get_config_value_with_override("quiet", override)
    end
    alias_method :quiet?, :quiet

    def verbose(override = {})
      get_config_value_with_override("verbose", override)
    end
    alias_method :verbose?, :verbose

    def safe_load_file(filename)
      case File.extname(filename)
      when %r!\.toml!i
        Jekyll::External.require_with_graceful_fail("tomlrb") unless defined?(Tomlrb)
        Tomlrb.load_file(filename)
      when %r!\.ya?ml!i
        SafeYAML.load_file(filename) || {}
      else
        raise ArgumentError,
              "No parser for '#{filename}' is available. Use a .y(a)ml or .toml file instead."
      end
    end

    # Public: Generate list of configuration files from the override
    #
    # override - the command-line options hash
    #
    # Returns an Array of config files
    def config_files(override)
      # Adjust verbosity quickly
      Jekyll.logger.adjust_verbosity(
        :quiet   => quiet?(override),
        :verbose => verbose?(override)
      )

      # Get configuration from <source>/_config.yml or <source>/<config_file>
      config_files = override["config"]
      if config_files.to_s.empty?
        default = %w(yml yaml toml).find(-> { "yml" }) do |ext|
          File.exist?(Jekyll.sanitized_path(source(override), "_config.#{ext}"))
        end
        config_files = Jekyll.sanitized_path(source(override), "_config.#{default}")
        @default_config_file = true
      end
      Array(config_files)
    end

    # Public: Read configuration and return merged Hash
    #
    # file - the path to the YAML file to be read in
    #
    # Returns this configuration, overridden by the values in the file
    def read_config_file(file)
      file = File.expand_path(file)
      next_config = safe_load_file(file)

      unless next_config.is_a?(Hash)
        raise ArgumentError, "Configuration file: (INVALID) #{file}".yellow
      end

      Jekyll.logger.info "Configuration file:", file
      next_config
    rescue SystemCallError
      if @default_config_file ||= nil
        Jekyll.logger.warn "Configuration file:", "none"
        {}
      else
        Jekyll.logger.error "Fatal:", "The configuration file '#{file}' could not be found."
        raise LoadError, "The Configuration file '#{file}' could not be found."
      end
    end

    # Public: Read in a list of configuration files and merge with this hash
    #
    # files - the list of configuration file paths
    #
    # Returns the full configuration, with the defaults overridden by the values in the
    # configuration files
    def read_config_files(files)
      configuration = clone

      begin
        files.each do |config_file|
          next if config_file.nil? || config_file.empty?

          new_config = read_config_file(config_file)
          configuration = Utils.deep_merge_hashes(configuration, new_config)
        end
      rescue ArgumentError => e
        Jekyll.logger.warn "WARNING:", "Error reading configuration. Using defaults (and options)."
        warn e
      end

      configuration.validate.add_default_collections
    end

    # Public: Split a CSV string into an array containing its values
    #
    # csv - the string of comma-separated values
    #
    # Returns an array of the values contained in the CSV
    def csv_to_array(csv)
      csv.split(",").map(&:strip)
    end

    # Public: Ensure the proper options are set in the configuration
    #
    # Returns the configuration Hash
    def validate
      config = clone

      check_plugins(config)
      check_include_exclude(config)

      config
    end

    def add_default_collections
      config = clone

      # It defaults to `{}`, so this is only if someone sets it to null manually.
      return config if config["collections"].nil?

      # Ensure we have a hash.
      if config["collections"].is_a?(Array)
        config["collections"] = config["collections"].each_with_object({}) do |collection, hash|
          hash[collection] = {}
        end
      end

      config["collections"] = Utils.deep_merge_hashes(
        { "posts" => {} }, config["collections"]
      ).tap do |collections|
        collections["posts"]["output"] = true
        if config["permalink"]
          collections["posts"]["permalink"] ||= style_to_permalink(config["permalink"])
        end
      end

      config
    end

    DEFAULT_EXCLUDES = %w(
      .sass-cache .jekyll-cache
      gemfiles Gemfile Gemfile.lock
      node_modules
      vendor/bundle/ vendor/cache/ vendor/gems/ vendor/ruby/
    ).freeze

    def add_default_excludes
      config = clone
      return config if config["exclude"].nil?

      config["exclude"].concat(DEFAULT_EXCLUDES).uniq!
      config
    end

    private

    def style_to_permalink(permalink_style)
      case permalink_style.to_sym
      when :pretty
        "/:categories/:year/:month/:day/:title/"
      when :none
        "/:categories/:title:output_ext"
      when :date
        "/:categories/:year/:month/:day/:title:output_ext"
      when :ordinal
        "/:categories/:year/:y_day/:title:output_ext"
      when :weekdate
        "/:categories/:year/W:week/:short_day/:title:output_ext"
      else
        permalink_style.to_s
      end
    end

    def check_include_exclude(config)
      %w(include exclude).each do |option|
        next unless config.key?(option)
        next if config[option].is_a?(Array)

        raise Jekyll::Errors::InvalidConfigurationError,
              "'#{option}' should be set as an array, but was: #{config[option].inspect}."
      end
    end

    # Private: Checks if the `plugins` config is a String
    #
    # config - the config hash
    #
    # Raises a Jekyll::Errors::InvalidConfigurationError if the config `plugins`
    # is not an Array.
    def check_plugins(config)
      return unless config.key?("plugins")
      return if config["plugins"].is_a?(Array)

      Jekyll.logger.error "'plugins' should be set as an array of gem-names, but was: " \
        "#{config["plugins"].inspect}. Use 'plugins_dir' instead to set the directory " \
        "for your non-gemified Ruby plugins."
      raise Jekyll::Errors::InvalidConfigurationError,
            "'plugins' should be set as an array, but was: #{config["plugins"].inspect}."
    end
  end
end
