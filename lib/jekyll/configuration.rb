module Jekyll
  # Default options. Overriden by values in _config.yml or command-line opts.
  # Strings rather than symbols are used for compatability with YAML.
  DEFAULTS = {
    'source'        => Dir.pwd,
    'destination'   => File.join(Dir.pwd, '_site'),
    'plugins'       => '_plugins',
    'layouts'       => '_layouts',
    'keep_files'   => ['.git','.svn'],

    'future'        => true,           # remove and make true just default
    'pygments'      => true,          # remove and make true just default

    'markdown'      => 'maruku',
    'permalink'     => 'date',
    'baseurl'       => '',
    'include'       => ['.htaccess'],
    'paginate_path' => 'page:num',

    'markdown_ext'  => 'markdown,mkd,mkdn,md',
    'textile_ext'   => 'textile',

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

  class Configuration

    def initialize
      # Keeps the config for further use
      @merged_config_hash = {}.deep_merge(Jekyll::DEFAULTS)

      # Remember all parsed paths to prevent circular inclusion
      @parsed_paths = []
    end

    def configuration(override)
      # Convert any symbol keys to strings and remove the old key/values
      override = override.reduce({}) { |hsh,(k,v)| hsh.merge(k.to_s => v) }

      # _config.yml may override default source location, but until
      # then, we need to know where to look for _config.yml
      source = override['source'] || Jekyll::DEFAULTS['source']

      # Might not be the best idea, needs discussion.
      @merged_config_hash['source'] = source


      # Get configuration from <source>/_config.yml or <source>/<config_file>
      config_file = override.delete('config')
      config_file = File.join(source, "_config.yml") if config_file.to_s.empty?
      self.read_and_merge(config_file)

      # finally merge merged_config and override
      @merged_config_hash = @merged_config_hash.deep_merge(override)
    end

    # Reads a configuration from a file and merges it into the instance variable.
    #
    # @param [String] config_file
    # @return [Hash]
    def read_and_merge(config_file)
      begin
        config = YAML.safe_load_file(config_file)
        raise "Configuration file: (INVALID) #{config_file}" if !config.is_a?(Hash)
        $stdout.puts "Configuration file: #{config_file}"

        if config.has_key? 'configs' and config['configs'].is_a? Array
          self.process_inclusions(config['configs'], config_file)
        end
      rescue SystemCallError
        # Errno:ENOENT = file not found
        $stderr.puts "Configuration file: none"
        config = {}
      rescue => err
        $stderr.puts "           " +
                     "WARNING: Error reading configuration. " +
                     "Using defaults (and options)."
        $stderr.puts "#{err}"
        config = {}
      end
      @merged_config_hash = @merged_config_hash.deep_merge(config)
    end

    # Expands a glob to an array of full qualified paths to each config file.
    #
    # @param [String] pattern
    # @return [Array]
    def glob_to_file_list(pattern, basedir = '')
      basedir = @merged_config_hash['source'] unless (pattern[0] == '/' or basedir != '')
      Dir[File.join(basedir, pattern)].sort
    end

    # Processes included files.
    # the parent_file is just as a debug helper for detecting and solving circular references.
    #
    # @param [Array] list_of_inclusions
    # @param [String] parent_file
    def process_inclusions(list_of_inclusions, parent_file = '')
      # This is a bit tricky: We want to prevent infinite inclusion loops.
      # If we add it to the "parsed_path" list right at the top, we do not reflect the true state of the program.
      # On the other hand, we cannot add it afterwards as the recursion could already happen in the path itself.
      # Any better ideas than to add it at the start of the processing?
      list_of_inclusions.each do |path_or_glob|
        paths = self.glob_to_file_list(path_or_glob)
        paths.each do |path|
          if @parsed_paths.include? path
            $stderr.puts "WARNING: Circular inclusion detected for #{path} in #{parent_file}. Skipping it."
            next
          end
          @parsed_paths << path
          self.read_and_merge(path)
        end
      end
    end
  end
end