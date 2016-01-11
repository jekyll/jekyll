$LOAD_PATH.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

# Require all of the Ruby files in the given directory.
#
# path - The String relative path from here to the directory.
#
# Returns nothing.
def require_all(path)
  glob = File.join(File.dirname(__FILE__), path, '*.rb')
  Dir[glob].each do |f|
    require f
  end
end

# rubygems
require 'rubygems'

# stdlib
require 'forwardable'
require 'fileutils'
require 'time'
require 'English'
require 'pathname'
require 'logger'
require 'set'

# 3rd party
require 'safe_yaml/load'
require 'liquid'
require 'colorator'
<<<<<<< HEAD
=======
require 'toml'

# internal requires
require 'jekyll/version'
require 'jekyll/utils'
require 'jekyll/hooks'
require 'jekyll/log_adapter'
require 'jekyll/stevenson'
require 'jekyll/deprecator'
require 'jekyll/configuration'
require 'jekyll/document'
require 'jekyll/collection'
require 'jekyll/plugin_manager'
require 'jekyll/frontmatter_defaults'
require 'jekyll/site'
require 'jekyll/convertible'
require 'jekyll/url'
require 'jekyll/layout'
require 'jekyll/page'
require 'jekyll/post'
require 'jekyll/excerpt'
require 'jekyll/draft'
require 'jekyll/filters'
require 'jekyll/static_file'
require 'jekyll/errors'
require 'jekyll/related_posts'
require 'jekyll/cleaner'
require 'jekyll/entry_filter'
require 'jekyll/layout_reader'
require 'jekyll/publisher'
require 'jekyll/renderer'

# extensions
require 'jekyll/plugin'
require 'jekyll/converter'
require 'jekyll/generator'
require 'jekyll/command'
require 'jekyll/liquid_extensions'

require_all 'jekyll/commands'
require_all 'jekyll/converters'
require_all 'jekyll/converters/markdown'
require_all 'jekyll/generators'
require_all 'jekyll/tags'

# plugins
require 'jekyll-coffeescript'
require 'jekyll-sass-converter'
require 'jekyll-paginate'
require 'jekyll-gist'
>>>>>>> jekyll/hooks

SafeYAML::OPTIONS[:suppress_warnings] = true

module Jekyll
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

=======
>>>>>>> jekyll/master
=======
>>>>>>> jekyll/master
=======
>>>>>>> jekyll/master
  # internal requires
  autoload :Cleaner,             'jekyll/cleaner'
  autoload :Collection,          'jekyll/collection'
  autoload :Configuration,       'jekyll/configuration'
  autoload :Convertible,         'jekyll/convertible'
  autoload :Deprecator,          'jekyll/deprecator'
  autoload :Document,            'jekyll/document'
  autoload :Draft,               'jekyll/draft'
  autoload :EntryFilter,         'jekyll/entry_filter'
  autoload :Errors,              'jekyll/errors'
  autoload :Excerpt,             'jekyll/excerpt'
  autoload :External,            'jekyll/external'
  autoload :Filters,             'jekyll/filters'
  autoload :FrontmatterDefaults, 'jekyll/frontmatter_defaults'
  autoload :Hooks,               'jekyll/hooks'
  autoload :Layout,              'jekyll/layout'
  autoload :CollectionReader,    'jekyll/readers/collection_reader'
  autoload :DataReader,          'jekyll/readers/data_reader'
  autoload :LayoutReader,        'jekyll/readers/layout_reader'
  autoload :PostReader,          'jekyll/readers/post_reader'
  autoload :PageReader,          'jekyll/readers/page_reader'
  autoload :StaticFileReader,    'jekyll/readers/static_file_reader'
  autoload :LogAdapter,          'jekyll/log_adapter'
  autoload :Page,                'jekyll/page'
  autoload :PluginManager,       'jekyll/plugin_manager'
  autoload :Publisher,           'jekyll/publisher'
  autoload :Reader,              'jekyll/reader'
  autoload :Regenerator,         'jekyll/regenerator'
  autoload :RelatedPosts,        'jekyll/related_posts'
  autoload :Renderer,            'jekyll/renderer'
  autoload :LiquidRenderer,      'jekyll/liquid_renderer'
  autoload :Site,                'jekyll/site'
  autoload :StaticFile,          'jekyll/static_file'
  autoload :Stevenson,           'jekyll/stevenson'
  autoload :URL,                 'jekyll/url'
  autoload :Utils,               'jekyll/utils'
  autoload :VERSION,             'jekyll/version'

  # extensions
  require 'jekyll/plugin'
  require 'jekyll/converter'
  require 'jekyll/generator'
  require 'jekyll/command'
  require 'jekyll/liquid_extensions'

  class << self
    # Public: Tells you which Jekyll environment you are building in so you can skip tasks
    # if you need to.  This is useful when doing expensive compression tasks on css and
    # images and allows you to skip that when working in development.

    def env
      ENV["JEKYLL_ENV"] || "dev"
    end

    # Public: Generate a Jekyll configuration Hash by merging the default
    # options with anything in _config.yml, and adding the given options on top.
    #
    # override - A Hash of config directives that override any options in both
    #            the defaults and the config file. See Jekyll::Configuration::DEFAULTS for a
    #            list of option names and their defaults.
    #
    # Returns the final configuration Hash.
    def configuration(override = {})
      config = Configuration[Configuration::DEFAULTS]
      override = Configuration[override].stringify_keys
      unless override.delete('skip_config_files')
        config = config.read_config_files(config.config_files(override))
      end

      # Merge DEFAULTS < _config.yml < override
      config = Utils.deep_merge_hashes(config, override).stringify_keys
      set_timezone(config['timezone']) if config['timezone']

      config
    end

    # Public: Set the TZ environment variable to use the timezone specified
    #
    # timezone - the IANA Time Zone
    #
    # Returns nothing
    def set_timezone(timezone)
      ENV['TZ'] = timezone
=======
=======
>>>>>>> origin/0.12.1-release
=======
>>>>>>> jekyll/0.12.1-release
=======
>>>>>>> origin/0.12.1-release
  VERSION = '0.12.1'

  # Default options. Overriden by values in _config.yml or command-line opts.
  # Strings rather than symbols are used for compatability with YAML.
  DEFAULTS = {
    'safe'          => false,
    'auto'          => false,
    'server'        => false,
    'server_port'   => 4000,

    'source'        => Dir.pwd,
    'destination'   => File.join(Dir.pwd, '_site'),
    'plugins'       => File.join(Dir.pwd, '_plugins'),
    'layouts'       => '_layouts',

    'future'        => true,
    'lsi'           => false,
    'pygments'      => false,
    'markdown'      => 'maruku',
    'permalink'     => 'date',
    'include'       => ['.htaccess'],
    'paginate_path' => 'page:num',

    'markdown_ext'  => 'markdown,mkd,mkdn,md',
    'textile_ext'   => 'textile',

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
=======
  VERSION = '1.0.4'
>>>>>>> jekyll/1.0-branch
=======
  VERSION = '1.0.4'
>>>>>>> origin/1.0-branch
=======
  VERSION = '1.5.1'
>>>>>>> jekyll/v1-stable
=======
  VERSION = '1.5.1'
>>>>>>> origin/v1-stable

  # Public: Generate a Jekyll configuration Hash by merging the default
  # options with anything in _config.yml, and adding the given options on top.
  #
  # override - A Hash of config directives that override any options in both
  #            the defaults and the config file. See Jekyll::DEFAULTS for a
  #            list of option names and their defaults.
  #
  # Returns the final configuration Hash.
  def self.configuration(override)
    # _config.yml may override default source location, but until
    # then, we need to know where to look for _config.yml
    source = override['source'] || Jekyll::DEFAULTS['source']

    # Get configuration from <source>/_config.yml
    config_file = File.join(source, '_config.yml')
    begin
      config = YAML.load_file(config_file)
      raise "Invalid configuration - #{config_file}" if !config.is_a?(Hash)
      $stdout.puts "Configuration from #{config_file}"
    rescue => err
      $stderr.puts "WARNING: Could not read configuration. " +
                   "Using defaults (and options)."
      $stderr.puts "\t" + err.to_s
      config = {}
>>>>>>> jekyll/0.12.1-release
    end

    # Public: Fetch the logger instance for this Jekyll process.
    #
    # Returns the LogAdapter instance.
    def logger
      @logger ||= LogAdapter.new(Stevenson.new, (ENV["JEKYLL_LOG_LEVEL"] || :info).to_sym)
    end

    # Public: Set the log writer.
    #         New log writer must respond to the same methods
    #         as Ruby's interal Logger.
    #
    # writer - the new Logger-compatible log transport
    #
    # Returns the new logger.
    def logger=(writer)
      @logger = LogAdapter.new(writer, (ENV["JEKYLL_LOG_LEVEL"] || :info).to_sym)
    end

    # Public: An array of sites
    #
    # Returns the Jekyll sites created.
    def sites
      @sites ||= []
    end

    # Public: Ensures the questionable path is prefixed with the base directory
    #         and prepends the questionable path with the base directory if false.
    #
    # base_directory - the directory with which to prefix the questionable path
    # questionable_path - the path we're unsure about, and want prefixed
    #
    # Returns the sanitized path.
    def sanitized_path(base_directory, questionable_path)
      return base_directory if base_directory.eql?(questionable_path)

      clean_path = File.expand_path(questionable_path, "/")
      clean_path = clean_path.sub(/\A\w\:\//, '/')

      if clean_path.start_with?(base_directory.sub(/\A\w\:\//, '/'))
        clean_path
      else
        File.join(base_directory, clean_path)
      end
    end

    # Conditional optimizations
    Jekyll::External.require_if_present('liquid-c')
<<<<<<< HEAD
<<<<<<< HEAD
  end

  # Get a subpath without any of the traversal nonsense.
  #
  # Returns a pure and clean path
  def self.sanitized_path(base_directory, questionable_path)
    clean_path = File.expand_path(questionable_path, "/")
    clean_path.gsub!(/\A\w\:\//, '/')
    unless clean_path.start_with?(base_directory)
      File.join(base_directory, clean_path)
    else
      clean_path
    end
  end

  # Get a subpath without any of the traversal nonsense.
  #
  # Returns a pure and clean path
  def self.sanitized_path(base_directory, questionable_path)
    clean_path = File.expand_path(questionable_path, "/")
    clean_path.gsub!(/\A\w\:\//, '/')
    unless clean_path.start_with?(base_directory)
      File.join(base_directory, clean_path)
    else
      clean_path
    end
=======
>>>>>>> jekyll/master
=======
>>>>>>> jekyll/master
  end
end

require "jekyll/drops/drop"
require_all 'jekyll/commands'
require_all 'jekyll/converters'
require_all 'jekyll/converters/markdown'
require_all 'jekyll/drops'
require_all 'jekyll/generators'
require_all 'jekyll/tags'

require 'jekyll-sass-converter'
