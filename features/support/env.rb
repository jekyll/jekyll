require 'fileutils'
require 'rr'
require 'test/unit'

World do
  include Test::Unit::Assertions
end

TEST_DIR = File.join('/', 'tmp', 'jekyll')
