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
require 'safe_yaml/load'
require 'English'
require 'pathname'

# 3rd party
require 'liquid'
require 'maruku'
require 'colorator'
require 'toml'

SafeYAML::OPTIONS[:suppress_warnings] = true

module Jekyll
  autoload :Cleaner,           'jekyll/cleaner'
  autoload :Collection,        'jekyll/collection'
  autoload :CollectionsReader, 'jekyll/collections_reader'
  autoload :Command,           'jekyll/command'
  autoload :Converter,         'jekyll/converter'
  autoload :Configuration,     'jekyll/configuration'
  autoload :Convertible,       'jekyll/convertible'
  autoload :Deprecator,        'jekyll/deprecator'
  autoload :Document,          'jekyll/document'
  autoload :DocumentConverter, 'jekyll/document_converter'
  autoload :Draft,             'jekyll/draft'
  autoload :EntryFilter,       'jekyll/entry_filter'
  autoload :Excerpt,           'jekyll/excerpt'
  autoload :Filters,           'jekyll/filters'
  autoload :Generator,         'jekyll/generator'
  autoload :Layout,            'jekyll/layout'
  autoload :LayoutReader,      'jekyll/layout_reader'
  autoload :Page,              'jekyll/page'
  autoload :PageReader,        'jekyll/page_reader'
  autoload :Plugin,            'jekyll/plugin'
  autoload :PluginManager,     'jekyll/plugin_manager'
  autoload :Post,              'jekyll/post'
  autoload :RelatedPosts,      'jekyll/related_posts'
  autoload :Site,              'jekyll/site'
  autoload :StaticFile,        'jekyll/static_file'
  autoload :Stevenson,         'jekyll/stevenson'
  autoload :URL,               'jekyll/url'
  autoload :Utils,             'jekyll/utils'
  autoload :VERSION,           'jekyll/version'
  autoload :Writable,          'jekyll/writable'

  # Public: Generate a Jekyll configuration Hash by merging the default
  # options with anything in _config.yml, and adding the given options on top.
  #
  # override - A Hash of config directives that override any options in both
  #            the defaults and the config file. See Jekyll::Configuration::DEFAULTS for a
  #            list of option names and their defaults.
  #
  # Returns the final configuration Hash.
  def self.configuration(override)
    config   = Configuration[Configuration::DEFAULTS]
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
    @logger ||= Stevenson.new
  end

  # Public: File system root
  #
  # Returns the root of the filesystem as a Pathname
  def self.fs_root
    @fs_root ||= traverse_up(Pathname.new(Dir.pwd))
  end

  def self.sanitized_path(base_directory, questionable_path)
    clean_path = File.expand_path(questionable_path, fs_root)
    clean_path.sub(/\A[\w]:\\\\/, '')
    File.join(base_directory, clean_path)
  end

  private

  def self.traverse_up(pathname)
    return pathname if pathname.parent.eql?(pathname)
    traverse_up(pathname.parent)
  end
end

require 'jekyll/errors'

require_all 'jekyll/commands'
require_all 'jekyll/converters'
require_all 'jekyll/converters/markdown'
require_all 'jekyll/generators'
require_all 'jekyll/tags'

# plugins
require 'jekyll-coffeescript'
require 'jekyll-sass-converter'
