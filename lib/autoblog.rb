$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

# rubygems
require 'rubygems'

# core
require 'fileutils'
require 'time'

# stdlib

# internal requires
require 'autoblog/site'
require 'autoblog/post'

module AutoBlog
  VERSION = '1.0.0'
  
  def self.process(source, dest)
    AutoBlog::Site.new(source, dest).process
  end
end