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
  VERSION = '0.3.0'
  
  # Default options. Overriden by values in _config.yaml or command-line opts.
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
  
  class << self
    attr_accessor :source,:dest,:lsi,:pygments,:permalink_style
  end

  # Initializes some global Jekyll parameters
  def self.configure(options)
    # Interpret the simple options and configure Jekyll appropriately
    Jekyll.lsi             = options['lsi']
    Jekyll.pygments        = options['pygments']
    Jekyll.permalink_style = options['permalink'].to_sym

    # Check to see if LSI is enabled.
    require 'classifier' if Jekyll.lsi

    # Set the Markdown interpreter (and Maruku options, if necessary)
    case options['markdown']

      when 'rdiscount'
        begin
          require 'rdiscount'

          def self.markdown(content) 
            RDiscount.new(content).to_html
          end

          puts 'Using rdiscount for Markdown'
        rescue LoadError
          puts 'You must have the rdiscount gem installed first'
        end

      when 'maruku'
        begin
          require 'maruku'

          def self.markdown(content) 
            Maruku.new(content).to_html
          end

          if options['maruku']['use_divs']
            require 'maruku/ext/div' 
            puts 'Maruku: Using extended syntax for div elements.'
          end

          if options['maruku']['use_tex']
            require 'maruku/ext/math' 
            puts "Maruku: Using LaTeX extension. Images in `#{options['maruku']['png_dir']}`."

            # Switch off MathML output
            MaRuKu::Globals[:html_math_output_mathml] = false
            MaRuKu::Globals[:html_math_engine] = 'none'

            # Turn on math to PNG support with blahtex
            # Resulting PNGs stored in `images/latex`
            MaRuKu::Globals[:html_math_output_png] = true
            MaRuKu::Globals[:html_png_engine] =  options['maruku']['png_engine']
            MaRuKu::Globals[:html_png_dir] = options['maruku']['png_dir']
            MaRuKu::Globals[:html_png_url] = options['maruku']['png_url']
          end
        rescue LoadError
            puts "The maruku gem is required for markdown support!"
        end
    end

  end

  def self.textile(content)
    RedCloth.new(content).to_html
  end

  def self.process(config)
    Jekyll.configure(config)
    Jekyll::Site.new(config).process
  end
end
