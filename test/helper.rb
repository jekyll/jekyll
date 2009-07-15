require 'rubygems'
gem 'RedCloth', '= 4.2.1'

require File.join(File.dirname(__FILE__), *%w[.. lib jekyll])

require 'test/unit'
require 'redgreen'
require 'shoulda'
require 'rr'

include Jekyll

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def dest_dir(*subdirs)
    File.join(File.dirname(__FILE__), 'dest', *subdirs)
  end

  def source_dir(*subdirs)
    File.join(File.dirname(__FILE__), 'source', *subdirs)
  end

  def clear_dest
    FileUtils.rm_rf(dest_dir)
  end
end
