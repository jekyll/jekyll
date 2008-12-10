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
require 'classifier'
require 'directory_watcher'

# internal requires
require 'jekyll/site'
require 'jekyll/convertible'
require 'jekyll/layout'
require 'jekyll/page'
require 'jekyll/post'
require 'jekyll/filters'
require 'jekyll/blocks'

module Jekyll
  VERSION = '0.1.4'
  
  def self.process(source, dest)
    Jekyll::Site.new(source, dest).process
  end
end
