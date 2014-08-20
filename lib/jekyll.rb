$:.unshift File.dirname(__FILE__) # For use/testing when no gem is installed

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
require 'fileutils'
require 'time'
require 'English'
require 'pathname'
require 'logger'

# 3rd party
require 'safe_yaml/load'
require 'liquid'
require 'kramdown'
require 'colorator'

SafeYAML::OPTIONS[:suppress_warnings] = true

module Jekyll

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
  autoload :Filters,             'jekyll/filters'
  autoload :FrontmatterDefaults, 'jekyll/frontmatter_defaults'
  autoload :Layout,              'jekyll/layout'
  autoload :LayoutReader,        'jekyll/layout_reader'
  autoload :LogAdapter,          'jekyll/log_adapter'
  autoload :Page,                'jekyll/page'
  autoload :PluginManager,       'jekyll/plugin_manager'
  autoload :Post,                'jekyll/post'
  autoload :Publisher,           'jekyll/publisher'
  autoload :RelatedPosts,        'jekyll/related_posts'
  autoload :Renderer,            'jekyll/renderer'
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

  # Public: Tells you which Jekyll environment you are building in so you can skip tasks
  # if you need to.  This is useful when doing expensive compression tasks on css and
  # images and allows you to skip that when working in development.

  def self.env
    ENV["JEKYLL_ENV"] || "development"
  end

  # Public: Generate a Jekyll configuration Hash by merging the default
  # options with anything in _config.yml, and adding the given options on top.
  #
  # override - A Hash of config directives that override any options in both
  #            the defaults and the config file. See Jekyll::Configuration::DEFAULTS for a
  #            list of option names and their defaults.
  #
  # Returns the final configuration Hash.
  def self.configuration(override)
    config = Configuration[Configuration::DEFAULTS]
    override = Configuration[override].stringify_keys
    config = config.read_config_files(config.config_files(override))

    # Merge DEFAULTS < _config.yml < override
    config = Utils.deep_merge_hashes(config, override).stringify_keys
    set_timezone(config['timezone']) if config['timezone']

    config
  end

  # Static: Set the TZ environment variable to use the timezone specified
  #
  # timezone - the IANA Time Zone
  #
  # Returns nothing
  def self.set_timezone(timezone)
    ENV['TZ'] = timezone
  end

  def self.logger
    @logger ||= LogAdapter.new(Stevenson.new)
  end

  def self.logger=(writer)
    @logger = LogAdapter.new(writer)
  end

  # Public: File system root
  #
  # Returns the root of the filesystem as a Pathname
  def self.fs_root
    @fs_root ||= "/"
  end

  def self.sanitized_path(base_directory, questionable_path)
    clean_path = File.expand_path(questionable_path, fs_root)
    clean_path.gsub!(/\A\w\:\//, '/')
    unless clean_path.start_with?(base_directory)
      File.join(base_directory, clean_path)
    else
      clean_path
    end
  end
end

require_all 'jekyll/commands'
require_all 'jekyll/converters'
require_all 'jekyll/converters/markdown'
require_all 'jekyll/generators'
require_all 'jekyll/tags'

# Eventually remove these for 3.0 as non-core
Jekyll::Deprecator.gracefully_require(%w[
  toml
  jekyll-paginate
  jekyll-gist
  jekyll-coffeescript
  jekyll-sass-converter
])
