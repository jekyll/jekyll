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

# internal requires
require 'jekyll/version'
require 'jekyll/utils'
require 'jekyll/stevenson'
require 'jekyll/deprecator'
require 'jekyll/configuration'
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

# extensions
require 'jekyll/plugin'
require 'jekyll/converter'
require 'jekyll/generator'
require 'jekyll/command'

require_all 'jekyll/commands'
require_all 'jekyll/converters'
require_all 'jekyll/converters/markdown'
require_all 'jekyll/generators'
require_all 'jekyll/tags'

# plugins
require 'jekyll-coffeescript'
require 'jekyll-sass-converter'

SafeYAML::OPTIONS[:suppress_warnings] = true

module Jekyll
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
    @logger ||= Stevenson.new
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
