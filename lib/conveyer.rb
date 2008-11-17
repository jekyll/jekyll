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
require 'conveyer/site'
require 'conveyer/convertible'
require 'conveyer/layout'
require 'conveyer/page'
require 'conveyer/post'
require 'conveyer/filters'

module Conveyer
  VERSION = '0.1.0'
  
  def self.process(source, dest)
    Conveyer::Site.new(source, dest).process
  end
end