# encoding: UTF-8

module Jekyll
  class Configuration < Hash

    # Default options. Overridden by values in _config.yml.
    # Strings rather than symbols are used for compatibility with YAML.
    DEFAULTS = {
      'source'        => Dir.pwd,
      'destination'   => File.join(Dir.pwd, '_site'),
      'plugins'       => '_plugins',
      'layouts'       => '_layouts',
      'keep_files'    => ['.git','.svn'],
      'encoding'      => nil,

      'timezone'      => nil,           # use the local timezone

      'safe'          => false,
      'detach'        => false,          # default to not detaching the server
      'show_drafts'   => nil,
      'limit_posts'   => 0,
      'lsi'           => false,
      'future'        => true,           # remove and make true just default
      'pygments'      => true,

      'relative_permalinks' => true,     # backwards-compatibility with < 1.0
                                         # will be set to false once 1.1 hits

      'markdown'      => 'maruku',
      'permalink'     => 'date',
      'baseurl'       => '/',
      'include'       => ['.htaccess'],
      'exclude'       => [],
      'paginate_path' => '/page:num',

      'markdown_ext'  => 'markdown,mkd,mkdn,md',
      'textile_ext'   => 'textile',

      'port'          => '4000',
      'host'          => '0.0.0.0',

      'excerpt_separator' => "\n\n",

      'maruku' => {
        'use_tex'    => false,
        'use_divs'   => false,
        'png_engine' => 'blahtex',
        'png_dir'    => 'images/latex',
        'png_url'    => '/images/latex'
      },

      'rdiscount' => {
        'extensions' => []
      },

      'redcarpet' => {
        'extensions' => []
      },

      'kramdown' => {
        'auto_ids'      => true,
        'footnote_nr'   => 1,
        'entity_output' => 'as_char',
        'toc_levels'    => '1..6',
        'smart_quotes'  => 'lsquo,rsquo,ldquo,rdquo',
        'use_coderay'   => false,

        'coderay' => {
          'coderay_wrap'              => 'div',
          'coderay_line_numbers'      => 'inline',
          'coderay_line_number_start' => 1,
          'coderay_tab_width'         => 4,
          'coderay_bold_every'        => 10,
          'coderay_css'               => 'style'
        }
      },

      'redcloth' => {
        'hard_breaks' => true
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

    # Public: Generate list of configuration files from the override
    #
    # override - the command-line options hash
    #
    # Returns an Array of config files
    def config_files(override)
      # Get configuration from <source>/_config.yml or <source>/<config_file>
      config_files = override.delete('config')
      if config_files.to_s.empty?
        config_files = File.join(source(override), "_config.yml")
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
      next_config = YAML.safe_load_file(file)
      raise ArgumentError.new("Configuration file: (INVALID) #{file}".yellow) if !next_config.is_a?(Hash)
      Jekyll.logger.info "Configuration file:", file
      next_config
    rescue SystemCallError
      if @default_config_file
        Jekyll.logger.warn "Configuration file:", "none"
        {}
      else
        Jekyll.logger.error "Fatal:", "The configuration file '#{file}' could not be found."
        raise LoadError
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
          configuration = configuration.deep_merge(new_config)
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
      if config.has_key?('auto') || config.has_key?('watch')
        Jekyll.logger.warn "Deprecation:", "Auto-regeneration can no longer" +
                            " be set from your configuration file(s). Use the"+
                            " --watch/-w command-line option instead."
        config.delete('auto')
        config.delete('watch')
      end

      if config.has_key? 'server'
        Jekyll.logger.warn "Deprecation:", "The 'server' configuration option" +
                            " is no longer accepted. Use the 'jekyll serve'" +
                            " subcommand to serve your site with WEBrick."
        config.delete('server')
      end

      if config.has_key? 'server_port'
        Jekyll.logger.warn "Deprecation:", "The 'server_port' configuration option" +
                            " has been renamed to 'port'. Please update your config" +
                            " file accordingly."
        # copy but don't overwrite:
        config['port'] = config['server_port'] unless config.has_key?('port')
        config.delete('server_port')
      end

      %w[include exclude].each do |option|
        if config.fetch(option, []).is_a?(String)
          Jekyll.logger.warn "Deprecation:", "The '#{option}' configuration option" +
            " must now be specified as an array, but you specified" +
            " a string. For now, we've treated the string you provided" +
            " as a list of comma-separated values."
          config[option] = csv_to_array(config[option])
        end
      end
      config
    end

    def fix_common_issues
      config = clone

      if config.has_key?('paginate') && (!config['paginate'].is_a?(Integer) || config['paginate'] < 1)
        Jekyll.logger.warn "Config Warning:", "The `paginate` key must be a" +
          " positive integer or nil. It's currently set to '#{config['paginate'].inspect}'."
        config['paginate'] = nil
      end

      config
    end

  end
end
