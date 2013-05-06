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

      'timezone'      => nil,           # use the local timezone

      'safe'          => false,
      'show_drafts'   => nil,
      'limit_posts'   => 0,
      'lsi'           => false,
      'future'        => true,           # remove and make true just default
      'pygments'      => true,           # remove and make true just default

      'markdown'      => 'maruku',
      'permalink'     => 'date',
      'baseurl'       => '/',
      'include'       => ['.htaccess'],
      'exclude'       => [],
      'paginate_path' => 'page:num',

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
      config_files = File.join(source(override), "_config.yml") if config_files.to_s.empty?
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
      raise "Configuration file: (INVALID) #{file}".yellow if !next_config.is_a?(Hash)
      Jekyll::Logger.info "Configuration file:", file
      next_config
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
      rescue SystemCallError
        # Errno:ENOENT = file not found
        Jekyll::Logger.warn "Configuration file:", "none"
      rescue => err
        Jekyll::Logger.warn "WARNING:", "Error reading configuration. " +
                     "Using defaults (and options)."
        $stderr.puts "#{err}"
      end

      configuration.backwards_compatibilize
    end

    # Public: Ensure the proper options are set in the configuration to allow for
    # backwards-compatibility with Jekyll pre-1.0
    #
    # Returns the backwards-compatible configuration
    def backwards_compatibilize
      config = clone
      # Provide backwards-compatibility
      if config.has_key?('auto') || config.has_key?('watch')
        Jekyll::Logger.warn "Deprecation:", "Auto-regeneration can no longer" +
                            " be set from your configuration file(s). Use the"+
                            " --watch/-w command-line option instead."
        config.delete('auto')
        config.delete('watch')
      end

      if config.has_key? 'server'
        Jekyll::Logger.warn "Deprecation:", "The 'server' configuration option" +
                            " is no longer accepted. Use the 'jekyll serve'" +
                            " subcommand to serve your site with WEBrick."
        config.delete('server')
      end

      config
    end

  end
end
