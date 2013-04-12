module Jekyll
  class Configuration < Hash

    # Default options. Overriden by values in _config.yml.
    # Strings rather than symbols are used for compatability with YAML.
    DEFAULTS = {
      'source'        => Dir.pwd,
      'destination'   => File.join(Dir.pwd, '_site'),
      'plugins'       => '_plugins',
      'layouts'       => '_layouts',
      'keep_files'   => ['.git','.svn'],

      'future'        => true,           # remove and make true just default
      'pygments'      => true,           # remove and make true just default

      'markdown'      => 'maruku',
      'permalink'     => 'date',
      'baseurl'       => '/',
      'include'       => ['.htaccess'],
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

    # Public: Generate list of configuration files from the override§
    def config_files(override)
      # _config.yml may override default source location, but until
      # then, we need to know where to look for _config.yml
      source = override['source'] || DEFAULTS['source']

      # Get configuration from <source>/_config.yml or <source>/<config_file>
      config_files = override.delete('config')
      config_files = File.join(source, "_config.yml") if config_files.to_s.empty?
      unless config_files.is_a? Array
        config_files = [config_files]
      end
      config_files
    end

    # Public: Read configuration and return merged Hash
    #
    # file - 
    def read_config_file(file)
      configuration = dup
      next_config = YAML.safe_load_file(file)
      raise "Configuration file: (INVALID) #{file}" if !next_config.is_a?(Hash)
      $stdout.puts "Configuration file: #{file}"
      configuration.deep_merge(next_config)
    end
    
    def read_config_files(files)
      configuration = dup

      begin
        files.each do |config_file|
          configuration = read_config_file(config_file)
        end
      rescue SystemCallError
        # Errno:ENOENT = file not found
        $stderr.puts "Configuration file: none"
      rescue => err
        $stderr.puts "           " +
                     "WARNING: Error reading configuration. " +
                     "Using defaults (and options)."
        $stderr.puts "#{err}"
      end
      
      configuration
    end
    
    def backwards_compatibilize
      config = dup
      # Provide backwards-compatibility
      if config['auto']
        $stderr.puts "Deprecation: ".rjust(20) + "'auto' has been changed to " +
                   "'watch'. Please update your configuration to use 'watch'."
        config['watch'] = config['auto']
      end

      config
    end

  end
end
