$:.unshift File.dirname(__FILE__)     # For use/testing when no gem is installed

# rubygems
require 'rubygems'

# core
require 'fileutils'

# stdlib

# internal requires
require 'autoblog/site'
require 'autoblog/post'

module AutoBlog
  VERSION = '1.0.0'
  
  def self.process(repo_path)
    AutoBlog::Site.new(repo_path)
  end
end