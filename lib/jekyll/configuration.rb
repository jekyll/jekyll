# encoding: UTF-8

module Jekyll
  class Configuration < Hash

    # Default options. Overridden by values in _config.yml.
    # Strings rather than symbols are used for compatibility with YAML.
    DEFAULTS = Configuration[{
      # Where things are
      'source'        => Dir.pwd,
      'destination'   => File.join(Dir.pwd, '_site'),
      'plugins_dir'   => '_plugins',
      'layouts_dir'   => '_layouts',
      'data_dir'      => '_data',
      'includes_dir'  => '_includes',
      'collections'   => {},

      # Handling Reading
      'safe'          => false,
      'include'       => ['.htaccess'],
      'exclude'       => [],
      'keep_files'    => ['.git','.svn'],
      'encoding'      => 'utf-8',
      'markdown_ext'  => 'markdown,mkdown,mkdn,mkd,md',

      # Filtering Content
      'show_drafts'   => nil,
      'limit_posts'   => 0,
      'future'        => false,
      'unpublished'   => false,

      # Plugins
      'whitelist'     => [],
      'gems'          => [],

      # Conversion
      'markdown'      => 'kramdown',
      'highlighter'   => 'rouge',
      'lsi'           => false,
      'excerpt_separator' => "\n\n",
      'incremental'   => false,

      # Serving
      'detach'        => false,          # default to not detaching the server
      'port'          => '4000',
      'host'          => '127.0.0.1',
      'baseurl'       => '',

      # Output Configuration
      'permalink'     => 'date',
      'paginate_path' => '/page:num',
      'timezone'      => nil,           # use the local timezone

      'quiet'         => false,
      'verbose'       => false,
      'defaults'      => [],

      'rdiscount' => {
        'extensions' => []
      },

      'redcarpet' => {
        'extensions' => []
      },

      'kramdown' => {
        'auto_ids'       => true,
        'footnote_nr'    => 1,
        'entity_output'  => 'as_char',
        'toc_levels'     => '1..6',
        'smart_quotes'   => 'lsquo,rsquo,ldquo,rdquo',
        'enable_coderay' => false,

        'coderay' => {
          'coderay_wrap'              => 'div',
          'coderay_line_numbers'      => 'inline',
          'coderay_line_number_start' => 1,
          'coderay_tab_width'         => 4,
          'coderay_bold_every'        => 10,
          'coderay_css'               => 'style'
        }
      }
    }].freeze

    class << self
      # Static: Produce a Configuration ready for use in a Site.
      # It takes the input, fills in the defaults where values do not
      # exist, and patches common issues including migrating options for
      # backwards compatiblity. Except where a key or value is being fixed,
      # the user configuration will override the defaults.
      #
      # user_config - a Hash or Configuration of overrides.
      #
      # Returns a Configuration filled with defaults and fixed for common
      # problems and backwards-compatibility.
      def from(user_config)
        Utils.deep_merge_hashes(DEFAULTS, Configuration[user_config].stringify_keys).
          fix_common_issues.add_default_collections
      end
    end

    # Public: Turn all keys into string
    #
    # Return a copy of the hash where all its keys are strings
    def stringify_keys
      reduce({}) { |hsh,(k,v)| hsh.merge(k.to_s => v) }
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
      get_config_value_with_override('source', override)
    end

    def quiet(override = {})
      get_config_value_with_override('quiet', override)
    end
    alias_method :quiet?, :quiet

    def verbose(override = {})
      get_config_value_with_override('verbose', override)
    end
    alias_method :verbose?, :verbose

    def safe_load_file(filename)
      case File.extname(filename)
      when /\.toml/i
        Jekyll::External.require_with_graceful_fail('toml') unless defined?(TOML)
        TOML.load_file(filename)
      when /\.ya?ml/i
        SafeYAML.load_file(filename)
      else
        raise ArgumentError, "No parser for '#{filename}' is available. Use a .toml or .y(a)ml file instead."
      end
    end

    # Public: Generate list of configuration files from the override
    #
    # override - the command-line options hash
    #
    # Returns an Array of config files
    def config_files(override)
      # Adjust verbosity quickly
      Jekyll.logger.adjust_verbosity(:quiet => quiet?(override), :verbose => verbose?(override))

      # Get configuration from <source>/_config.yml or <source>/<config_file>
      config_files = override.delete('config')
      if config_files.to_s.empty?
        default = %w[yml yaml].find(Proc.new { 'yml' }) do |ext|
          File.exist?(Jekyll.sanitized_path(source(override), "_config.#{ext}"))
        end
        config_files = Jekyll.sanitized_path(source(override), "_config.#{default}")
        @default_config_file = true
      end
      config_files = [config_files] unless config_files.is_a? Array
      config_files
    end

    # Public: Read configuration and return merged Hash
    #
    # file - the path to the YAML file to be read in
    #
    # Returns this configuration, overridden by the values in the file
    def read_config_file(file)
      next_config = safe_load_file(file)
      raise ArgumentError.new("Configuration file: (INVALID) #{file}".yellow) unless next_config.is_a?(Hash)
      Jekyll.logger.info "Configuration file:", file
      next_config
    rescue SystemCallError
      if @default_config_file
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
          next if config_file.nil? or config_file.empty?
          new_config = read_config_file(config_file)
          configuration = Utils.deep_merge_hashes(configuration, new_config)
        end
      rescue ArgumentError => err
        Jekyll.logger.warn "WARNING:", "Error reading configuration. " +
                     "Using defaults (and options)."
        $stderr.puts "#{err}"
      end

      configuration.fix_common_issues.backwards_compatibilize.add_default_collections
    end

    # Public: Split a CSV string into an array containing its values
    #
    # csv - the string of comma-separated values
    #
    # Returns an array of the values contained in the CSV
    def csv_to_array(csv)
      csv.split(",").map(&:strip)
    end

    # Public: Ensure the proper options are set in the configuration to allow for
    # backwards-compatibility with Jekyll pre-1.0
    #
    # Returns the backwards-compatible configuration
    def backwards_compatibilize
      config = clone
      # Provide backwards-compatibility
      if config.key?('auto') || config.key?('watch')
        Jekyll::Deprecator.deprecation_message "Auto-regeneration can no longer" +
                            " be set from your configuration file(s). Use the"+
                            " --[no-]watch/-w command-line option instead."
        config.delete('auto')
        config.delete('watch')
      end

      if config.key? 'server'
        Jekyll::Deprecator.deprecation_message "The 'server' configuration option" +
                            " is no longer accepted. Use the 'jekyll serve'" +
                            " subcommand to serve your site with WEBrick."
        config.delete('server')
      end

      renamed_key 'server_port', 'port', config
      renamed_key 'plugins', 'plugins_dir', config
      renamed_key 'layouts', 'layouts_dir', config
      renamed_key 'data_source', 'data_dir', config

      if config.key? 'pygments'
        Jekyll::Deprecator.deprecation_message "The 'pygments' configuration option" +
                            " has been renamed to 'highlighter'. Please update your" +
                            " config file accordingly. The allowed values are 'rouge', " +
                            "'pygments' or null."

        config['highlighter'] = 'pygments' if config['pygments']
        config.delete('pygments')
      end

      %w[include exclude].each do |option|
        if config.fetch(option, []).is_a?(String)
          Jekyll::Deprecator.deprecation_message "The '#{option}' configuration option" +
            " must now be specified as an array, but you specified" +
            " a string. For now, we've treated the string you provided" +
            " as a list of comma-separated values."
          config[option] = csv_to_array(config[option])
        end
        config[option].map!(&:to_s) if config[option]
      end

      if (config['kramdown'] || {}).key?('use_coderay')
        Jekyll::Deprecator.deprecation_message "Please change 'use_coderay'" +
          " to 'enable_coderay' in your configuration file."
        config['kramdown']['use_coderay'] = config['kramdown'].delete('enable_coderay')
      end

      if config.fetch('markdown', 'kramdown').to_s.downcase.eql?("maruku")
        Jekyll.logger.abort_with "Error:", "You're using the 'maruku' " +
          "Markdown processor, which has been removed as of 3.0.0. " +
          "We recommend you switch to Kramdown. To do this, replace " +
          "`markdown: maruku` with `markdown: kramdown` in your " +
          "`_config.yml` file."
      end

      config
    end

    def fix_common_issues
      config = clone

      if config.key?('paginate') && (!config['paginate'].is_a?(Integer) || config['paginate'] < 1)
        Jekyll.logger.warn "Config Warning:", "The `paginate` key must be a" +
          " positive integer or nil. It's currently set to '#{config['paginate'].inspect}'."
        config['paginate'] = nil
      end

      config
    end

    def add_default_collections
      config = clone

      # It defaults to `{}`, so this is only if someone sets it to null manually.
      return config if config['collections'].nil?

      # Ensure we have a hash.
      if config['collections'].is_a?(Array)
        config['collections'] = Hash[config['collections'].map{|c| [c, {}]}]
      end

      config['collections'] = Utils.deep_merge_hashes(
        { 'posts' => {} }, config['collections']
      ).tap do |collections|
        collections['posts']['output'] = true
        if config['permalink']
          collections['posts']['permalink'] ||= style_to_permalink(config['permalink'])
        end
      end

      config
    end

    def renamed_key(old, new, config, allowed_values = nil)
      if config.key?(old)
        Jekyll::Deprecator.deprecation_message "The '#{old}' configuration" +
          "option has been renamed to '#{new}'. Please update your config " +
          "file accordingly."
        config[new] = config.delete(old)
      end
    end

    private
    def style_to_permalink(permalink_style)
      case permalink_style.to_sym
      when :pretty
        "/:categories/:year/:month/:day/:title/"
      when :none
        "/:categories/:title.html"
      when :date
        "/:categories/:year/:month/:day/:title.html"
      when :ordinal
        "/:categories/:year/:y_day/:title.html"
      else
        permalink_style.to_s
      end
    end
  end
end
