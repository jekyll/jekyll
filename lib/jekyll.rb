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
  
  class << self
    attr_accessor :source, :dest, :lsi, :pygments, :markdown_proc,:permalink_style
  end
  
  
  def self.process(source, dest)
    require 'classifier' if Jekyll.lsi
    
    Jekyll.source = source
    Jekyll.dest = dest
    Jekyll::Site.new(source, dest).process
  end
end
