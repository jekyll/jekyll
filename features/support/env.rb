require 'fileutils'
require 'rr'
require 'test/unit'

World do
  include Test::Unit::Assertions
end

TEST_DIR    = File.join('/', 'tmp', 'jekyll')
JEKYLL_PATH = File.join(ENV['PWD'], 'bin', 'jekyll')

def run_jekyll(opts = {})
  if opts[:bg]
    bg = '&'
  end

  system "#{JEKYLL_PATH} >> /dev/null"
end
