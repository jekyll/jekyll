require File.join(File.dirname(__FILE__), *%w[.. lib jekyll])

require 'test/unit'

include Jekyll

def dest_dir
  File.join(File.dirname(__FILE__), *%w[dest])
end

def clear_dest
  FileUtils.rm_rf(dest_dir)
end