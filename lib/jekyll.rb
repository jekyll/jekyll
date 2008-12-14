$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

# rubygems
require 'rubygems'

# core
require 'fileutils'
require 'time'

# stdlib

# 3rd party
require 'liquid'
require 'redcloth'
begin
  require 'rdiscount'
rescue LoadError
  puts "The rdiscount gem is required for markdown support!"
end
require 'directory_watcher'

# internal requires
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
  VERSION = '0.1.6'
  
  class << self
    attr_accessor :source, :dest, :lsi, :pygments
  end
  
  Jekyll.lsi = false
  Jekyll.pygments = false
  
  def self.process(source, dest)
    require 'classifier' if Jekyll.lsi
    
    Jekyll.source = source
    Jekyll.dest = dest
    Jekyll::Site.new(source, dest).process
  end
end
