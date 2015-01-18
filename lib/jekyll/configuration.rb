# encoding: UTF-8

module Jekyll
  class Configuration < Hash

    # Default options. Overridden by values in _config.yml.
    # Strings rather than symbols are used for compatibility with YAML.
    DEFAULTS = {
      # Where things are
      'source'        => Dir.pwd,
      'destination'   => File.join(Dir.pwd, '_site'),
      'plugins'       => '_plugins',
      'layouts'       => '_layouts',
      'data_source'   =>  '_data',
      'collections'   => nil,

      # Handling Reading
      'safe'          => false,
      'include'       => ['.htaccess'],
      'exclude'       => [],
      'keep_files'    => ['.git','.svn'],
      'encoding'      => 'utf-8',
      'markdown_ext'  => 'markdown,mkdown,mkdn,mkd,md',
      'full_rebuild'  => false,

      # Filtering Content
      'show_drafts'   => nil,
      'limit_posts'   => 0,
      'future'        => true,           # remove and make true just default
      'unpublished'   => false,

      # Plugins
      'whitelist'     => [],
      'gems'          => [],

      # Conversion
      'markdown'      => 'kramdown',
      'highlighter'   => 'pygments',
      'lsi'           => false,
      'excerpt_separator' => "\n\n",

      # Serving
      'detach'        => false,          # default to not detaching the server
      'port'          => '4000',
      'host'          => '127.0.0.1',
      'baseurl'       => '',

      # Backwards-compatibility options
      'relative_permalinks' => false,

      # Output Configuration
      'permalink'     => 'date',
      'paginate_path' => '/page:num',
      'timezone'      => nil,           # use the local timezone

      'quiet'         => false,
      'defaults'      => [],

      'maruku' => {
        'use_tex'    => false,
        'use_divs'   => false,
        'png_engine' => 'blahtex',
        'png_dir'    => 'images/latex',
        'png_url'    => '/images/latex',
        'fenced_code_blocks' => true
      },

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
    }

    # Public: Turn all keys into string
    #
    # Return a copy of the hash where all its keys are strings
    def stringify_keys
      reduce({}) { |hsh,(k,v)| hsh.merge(k.to_s => v) }
    end

    # Public: Directory of the Jekyll source folder
    #
    # override - the command-line options hash
    #
    # Returns the path to the Jekyll source directory
    def source(override)
      override['source'] || self['source'] || DEFAULTS['source']
    end

    def quiet?(override = {})
      override['quiet'] || self['quiet'] || DEFAULTS['quiet']
    end

    def safe_load_file(filename)
      case File.extname(filename)
      when /\.toml/i
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
      # Be quiet quickly.
      Jekyll.logger.log_level = :error if quiet?(override)

      # Get configuration from <source>/_config.yml or <source>/<config_file>
      config_files = override.delete('config')
      if config_files.to_s.empty?
        default = %w[yml yaml].find(Proc.new { 'yml' }) do |ext|
          File.exists? Jekyll.sanitized_path(source(override), "_config.#{ext}")
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
          new_config = read_config_file(config_file)
          configuration = Utils.deep_merge_hashes(configuration, new_config)
        end
      rescue ArgumentError => err
        Jekyll.logger.warn "WARNING:", "Error reading configuration. " +
                     "Using defaults (and options)."
        $stderr.puts "#{err}"
      end

      configuration.fix_common_issues.backwards_compatibilize
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
        Jekyll.logger.warn "Deprecation:", "Auto-regeneration can no longer" +
                            " be set from your configuration file(s). Use the"+
                            " --[no-]watch/-w command-line option instead."
        config.delete('auto')
        config.delete('watch')
      end

      if config.key? 'server'
        Jekyll.logger.warn "Deprecation:", "The 'server' configuration option" +
                            " is no longer accepted. Use the 'jekyll serve'" +
                            " subcommand to serve your site with WEBrick."
        config.delete('server')
      end

      if config.key? 'server_port'
        Jekyll.logger.warn "Deprecation:", "The 'server_port' configuration option" +
                            " has been renamed to 'port'. Please update your config" +
                            " file accordingly."
        # copy but don't overwrite:
        config['port'] = config['server_port'] unless config.key?('port')
        config.delete('server_port')
      end

      if config.key? 'pygments'
        Jekyll.logger.warn "Deprecation:", "The 'pygments' configuration option" +
                            " has been renamed to 'highlighter'. Please update your" +
                            " config file accordingly. The allowed values are 'rouge', " +
                            "'pygments' or null."

        config['highlighter'] = 'pygments' if config['pygments']
        config.delete('pygments')
      end

      %w[include exclude].each do |option|
        if config.fetch(option, []).is_a?(String)
          Jekyll.logger.warn "Deprecation:", "The '#{option}' configuration option" +
            " must now be specified as an array, but you specified" +
            " a string. For now, we've treated the string you provided" +
            " as a list of comma-separated values."
          config[option] = csv_to_array(config[option])
        end
        config[option].map!(&:to_s)
      end

      if (config['kramdown'] || {}).key?('use_coderay')
        Jekyll::Deprecator.deprecation_message "Please change 'use_coderay'" +
          " to 'enable_coderay' in your configuration file."
        config['kramdown']['use_coderay'] = config['kramdown'].delete('enable_coderay')
      end

      if config.fetch('markdown', 'kramdown').to_s.downcase.eql?("maruku")
        Jekyll::Deprecator.deprecation_message "You're using the 'maruku' " +
          "Markdown processor. Maruku support has been deprecated and will " +
          "be removed in 3.0.0. We recommend you switch to Kramdown."
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
  end
end
