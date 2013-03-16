if RUBY_VERSION > '1.9' && ENV["COVERAGE"] == "true"
  require 'simplecov'
  require 'simplecov-gem-adapter'
  SimpleCov.start('gem')
end

require 'rubygems'
require 'test/unit'
gem 'RedCloth', '>= 4.2.1'

require 'jekyll'

require 'RedCloth'
require 'rdiscount'
require 'kramdown'
require 'redcarpet'

require 'redgreen' if RUBY_VERSION < '1.9'
require 'shoulda'
require 'rr'

include Jekyll

# Send STDERR into the void to suppress program output messages
STDERR.reopen(test(?e, '/dev/null') ? '/dev/null' : 'NUL:')

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def dest_dir(*subdirs)
    test_dir('dest', *subdirs)
  end

  def source_dir(*subdirs)
    test_dir('source', *subdirs)
  end

  def clear_dest
    FileUtils.rm_rf(dest_dir)
  end

  def test_dir(*subdirs)
    File.join(File.dirname(__FILE__), *subdirs)
  end

  def capture_stdout
    $old_stdout = $stdout
    $stdout = StringIO.new
    yield
    $stdout.rewind
    return $stdout.string
  ensure
    $stdout = $old_stdout
  end
end
