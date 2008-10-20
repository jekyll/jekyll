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

# internal requires
require 'autoblog/site'
require 'autoblog/post'
require 'autoblog/page'
require 'autoblog/filters'

module AutoBlog
  VERSION = '1.0.0'
  
  def self.process(source, dest)
    AutoBlog::Site.new(source, dest).process
  end
end