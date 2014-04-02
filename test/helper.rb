require 'simplecov'
require 'simplecov-gem-adapter'
SimpleCov.start('gem')

require 'coveralls'
Coveralls.wear_merged!

require 'rubygems'
require 'rbconfig'
require 'tempfile'
require 'test/unit'
require 'ostruct'
gem 'RedCloth', '>= 4.2.1'

require 'jekyll'

require 'RedCloth'
require 'rdiscount'
require 'kramdown'
require 'redcarpet'

require 'shoulda'
require 'rr'

include Jekyll

# Send STDERR into the void to suppress program output messages
STDERR.reopen(test(?e, '/dev/null') ? '/dev/null' : 'NUL:')

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def build_configs(overrides, base_hash = Jekyll::Configuration::DEFAULTS)
    Utils.deep_merge_hashes(base_hash, overrides)
  end

  def site_configuration(overrides = {})
    build_configs({
      "source"      => source_dir,
      "destination" => dest_dir
    }, build_configs(overrides))
  end

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

  def directory_with_contents(path)
    FileUtils.rm_rf(path)
    FileUtils.mkdir(path)
    File.open("#{path}/index.html", "w"){ |f| f.write("I was previously generated.") }
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

  def is_windows
    self.class.is_windows
  end

  def self.is_windows
    RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
  end
end
