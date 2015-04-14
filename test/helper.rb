unless ENV['TRAVIS']
  require File.expand_path('../simplecov_custom_profile', __FILE__)
  SimpleCov.start('gem') do
    add_filter "/vendor/bundle"
    add_filter "/vendor/gem"
  end
end

require 'rubygems'
require 'ostruct'
require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/profile'
require 'rspec/mocks'

require 'jekyll'

require 'rdiscount'
require 'kramdown'
require 'redcarpet'

require 'shoulda'

include Jekyll

# Send STDERR into the void to suppress program output messages
STDERR.reopen(test(?e, '/dev/null') ? '/dev/null' : 'NUL:')

# Report with color.
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]

class JekyllUnitTest < Minitest::Test
  include ::RSpec::Mocks::ExampleMethods

  def mocks_expect(*args)
    RSpec::Mocks::ExampleMethods::ExpectHost.instance_method(:expect).\
      bind(self).call(*args)
  end

  def before_setup
    ::RSpec::Mocks.setup
    super
  end

  def after_teardown
    super
    ::RSpec::Mocks.verify
  ensure
    ::RSpec::Mocks.teardown
  end

  def fixture_site(overrides = {})
    Jekyll::Site.new(site_configuration(overrides))
  end

  def build_configs(overrides, base_hash = Jekyll::Configuration::DEFAULTS)
    Utils.deep_merge_hashes(base_hash, overrides)
  end

  def site_configuration(overrides = {})
    full_overrides = build_configs(overrides, build_configs({
      "destination" => dest_dir,
      "full_rebuild" => true
    }))
    build_configs({
      "source" => source_dir
    }, full_overrides)
  end

  def dest_dir(*subdirs)
    test_dir('dest', *subdirs)
  end

  def source_dir(*subdirs)
    test_dir('source', *subdirs)
  end

  def clear_dest
    FileUtils.rm_rf(dest_dir)
    FileUtils.rm_rf(source_dir('.jekyll-metadata'))
  end

  def test_dir(*subdirs)
    File.join(File.dirname(__FILE__), *subdirs)
  end

  def directory_with_contents(path)
    FileUtils.rm_rf(path)
    FileUtils.mkdir(path)
    File.open("#{path}/index.html", "w"){ |f| f.write("I was previously generated.") }
  end

  def with_env(key, value)
    old_value = ENV[key]
    ENV[key] = value
    yield
    ENV[key] = old_value
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

  def capture_stderr
    $old_stderr = $stderr
    $stderr = StringIO.new
    yield
    $stderr.rewind
    return $stderr.string
  ensure
    $stderr = $old_stderr
  end
end
