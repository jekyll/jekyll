$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

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
require 'yaml'

# 3rd party
require 'liquid'
require 'redcloth'

# internal requires
require 'jekyll/core_ext'
require 'jekyll/site'
require 'jekyll/convertible'
require 'jekyll/layout'
require 'jekyll/page'
require 'jekyll/post'
require 'jekyll/filters'
require 'jekyll/albino'
require 'jekyll/static_file'

#extensions
require 'jekyll/extension'
require 'jekyll/converter'
require 'jekyll/generator'
require_all 'jekyll/converters'
require_all 'jekyll/generators'
require_all 'jekyll/tags'

module Jekyll
  # Default options. Overriden by values in _config.yml or command-line opts.
  # (Strings rather symbols used for compatability with YAML)
  DEFAULTS = {
    'auto'         => false,
    'server'       => false,
    'server_port'  => 4000,

    'source'       => '.',
    'destination'  => File.join('.', '_site'),

    'future'       => true,
    'lsi'          => false,
    'pygments'     => false,
    'markdown'     => 'maruku',
    'permalink'    => 'date',

    'maruku'       => {
      'use_tex'    => false,
      'use_divs'   => false,
      'png_engine' => 'blahtex',
      'png_dir'    => 'images/latex',
      'png_url'    => '/images/latex'
    }
  }

  # Generate a Jekyll configuration Hash by merging the default options
  # with anything in _config.yml, and adding the given options on top
  #   +override+ is a Hash of config directives
  #
  # Returns Hash
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
      $stderr.puts "WARNING: Could not read configuration. Using defaults (and options)."
      $stderr.puts "\t" + err.to_s
      config = {}
    end

    # Merge DEFAULTS < _config.yml < override
    Jekyll::DEFAULTS.deep_merge(config).deep_merge(override)
  end

  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
end
