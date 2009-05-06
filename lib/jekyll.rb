$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

# rubygems
require 'rubygems'

# core
require 'fileutils'
require 'time'
require 'yaml'

# stdlib

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
require 'jekyll/tags/highlight'
require 'jekyll/tags/include'
require 'jekyll/albino'

module Jekyll
  # Default options. Overriden by values in _config.yml or command-line opts.
  # (Strings rather symbols used for compatability with YAML)
  DEFAULTS = {
    'auto'         => false,
    'server'       => false,
    'server_port'  => 4000,

    'source'       => '.',
    'destination'  => File.join('.', '_site'),

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
    config = {}
    config_file = File.join(source, '_config.yml')
    begin
      config = YAML.load_file(config_file)
      puts "Configuration from #{config_file}"
    rescue => err
      puts "WARNING: Could not read configuration. Using defaults (and options)."
      puts "\t" + err
    end

    # Merge DEFAULTS < _config.yml < override
    Jekyll::DEFAULTS.deep_merge(config).deep_merge(override)
  end

  def self.version
    yml = YAML.load(File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION.yml])))
    "#{yml[:major]}.#{yml[:minor]}.#{yml[:patch]}"
  end
end
