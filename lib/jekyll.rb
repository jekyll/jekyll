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
require 'yaml'
require 'English'

# 3rd party
require 'liquid'
require 'maruku'
require 'pygments'

# internal requires
require 'jekyll/core_ext'
require 'jekyll/site'
require 'jekyll/convertible'
require 'jekyll/layout'
require 'jekyll/page'
require 'jekyll/post'
require 'jekyll/filters'
require 'jekyll/static_file'
require 'jekyll/errors'

# extensions
require 'jekyll/plugin'
require 'jekyll/converter'
require 'jekyll/generator'
require 'jekyll/command'

require_all 'jekyll/commands'
require_all 'jekyll/converters'
require_all 'jekyll/generators'
require_all 'jekyll/tags'

module Jekyll
  VERSION = '0.12.0'

  # Default options. Overriden by values in _config.yml.
  # Strings rather than symbols are used for compatability with YAML.
  DEFAULTS = {
    'source'        => Dir.pwd,
    'destination'   => File.join(Dir.pwd, '_site'),

    'plugins'       => File.join(Dir.pwd, '_plugins'),
    'layouts'       => '_layouts',
    'keep_files'   => ['.git','.svn'],

    'future'        => true,           # remove and make true just default
    'pygments'      => false,          # remove and make true just default

    'markdown'      => 'maruku',       # no longer a command option
    'permalink'     => 'date',         # no longer a command option
    'include'       => ['.htaccess'],  # no longer a command option
    'paginate_path' => 'page:num',     # no longer a command option

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

  # Public: Generate a Jekyll configuration Hash by merging the default
  # options with anything in _config.yml, and adding the given options on top.
  #
  # override - A Hash of config directives that override any options in both
  #            the defaults and the config file. See Jekyll::DEFAULTS for a
  #            list of option names and their defaults.
  #
  # Returns the final configuration Hash.
  def self.configuration(override)
    # Convert any symbol keys to strings and remove the old key/values
    override = override.reduce({}) { |hsh,(k,v)| hsh.merge(k.to_s => v) }

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
    end

    # Merge DEFAULTS < _config.yml < override
    Jekyll::DEFAULTS.deep_merge(config).deep_merge(override)
  end
end
