# frozen_string_literal: true

$stdout.puts "# -------------------------------------------------------------"
$stdout.puts "# SPECS AND TESTS ARE RUNNING WITH WARNINGS OFF."
$stdout.puts "# SEE: https://github.com/Shopify/liquid/issues/730"
$stdout.puts "# SEE: https://github.com/jekyll/jekyll/issues/4719"
$stdout.puts "# -------------------------------------------------------------"
$VERBOSE = nil

def jruby?
  defined?(RUBY_ENGINE) && RUBY_ENGINE == "jruby"
end

if ENV["CI"]
  require "simplecov"
  SimpleCov.start
else
  require File.expand_path("simplecov_custom_profile", __dir__)
  SimpleCov.start "gem" do
    add_filter "/vendor/gem"
    add_filter "/vendor/bundle"
    add_filter ".bundle"
  end
end

require "nokogiri"
require "rubygems"
require "ostruct"
require "minitest/autorun"
require "minitest/reporters"
require "minitest/profile"
require "rspec/mocks"
require_relative "../lib/jekyll"

Jekyll.logger = Logger.new(StringIO.new, :error)

require "kramdown"
require "shoulda-context"

include Jekyll

require "jekyll/commands/serve/servlet"

# Report with color.
Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(
    :color => true
  ),
]

module Minitest::Assertions
  def assert_exist(filename, msg = nil)
    msg = message(msg) { "Expected '#{filename}' to exist" }
    assert_path_exists(filename, msg)
  end

  def refute_exist(filename, msg = nil)
    msg = message(msg) { "Expected '#{filename}' not to exist" }
    refute_path_exists(filename, msg)
  end
end

module DirectoryHelpers
  def root_dir(*subdirs)
    File.expand_path(File.join("..", *subdirs), __dir__)
  end

  def dest_dir(*subdirs)
    test_dir("dest", *subdirs)
  end

  def source_dir(*subdirs)
    test_dir("source", *subdirs)
  end

  def theme_dir(*subdirs)
    test_dir("fixtures", "test-theme", *subdirs)
  end

  def test_dir(*subdirs)
    root_dir("test", *subdirs)
  end

  def temp_dir(*subdirs)
    if Utils::Platforms.vanilla_windows?
      drive = Dir.pwd.sub(%r!^([^/]+).*!, '\1')
      temp_root = File.join(drive, "tmp")
    else
      temp_root = "/tmp"
    end

    File.join(temp_root, *subdirs)
  end
end

module Jekyll
  #
  # --- NOTE: ---
  #
  # This monkey-patch was introduced because GitHub Actions on Windows acknowledges symlinked test
  # file `test/source/symlink-test/symlinked-file-outside-source` but errors out since the linked
  # location `/etc/passwd` does not exist on Windows.
  #
  # --- TODO: ---
  #
  # Consider having the `symlinked-file-outside-source` point to a file that is outside the
  # `source_dir` (defaults to `test/source`) yet is certain to exist on tested platforms.
  # For example, `jekyll.gemspec` is a good candidate.
  #
  # This monkey-patch will then no longer be necessary.
  #
  class ModifiedReader < Reader
    def read_directories(dir = "")
      if dir.start_with?("/symlink") && Utils::Platforms.really_windows?
        Jekyll.logger.debug "Skipping:", "Jekyll does not support symlinks on Windows"
      else
        super
      end
    end
  end

  Hooks.register :site, :after_init do |site|
    site.instance_variable_set(:@reader, ModifiedReader.new(site))
  end
end

class JekyllUnitTest < Minitest::Test
  include ::RSpec::Mocks::ExampleMethods
  include DirectoryHelpers
  extend DirectoryHelpers

  def mu_pp(obj)
    s = obj.is_a?(Hash) ? JSON.pretty_generate(obj) : obj.inspect
    s = s.encode Encoding.default_external if defined? Encoding
    s
  end

  def mocks_expect(*args)
    RSpec::Mocks::ExampleMethods::ExpectHost.instance_method(:expect).bind(self).call(*args)
  end

  def before_setup
    RSpec::Mocks.setup
    super
  end

  def after_teardown
    super
    RSpec::Mocks.verify
  ensure
    RSpec::Mocks.teardown
  end

  def fixture_document(relative_path)
    site = fixture_site(
      "collections" => {
        "methods" => {
          "output" => true,
        },
      }
    )
    site.read
    matching_doc = site.collections["methods"].docs.find do |doc|
      doc.relative_path == relative_path
    end
    [site, matching_doc]
  end

  def fixture_site(overrides = {})
    Jekyll::Site.new(site_configuration(overrides))
  end

  def default_configuration
    Marshal.load(Marshal.dump(Jekyll::Configuration::DEFAULTS))
  end

  def build_configs(overrides, base_hash = default_configuration)
    Utils.deep_merge_hashes(base_hash, overrides)
  end

  def site_configuration(overrides = {})
    full_overrides = build_configs(overrides, build_configs(
                                                "destination" => dest_dir,
                                                "incremental" => false
                                              ))
    Configuration.from(full_overrides.merge(
                         "source" => source_dir
                       ))
  end

  def clear_dest
    FileUtils.rm_rf(dest_dir)
    FileUtils.rm_rf(source_dir(".jekyll-metadata"))
  end

  def directory_with_contents(path)
    FileUtils.rm_rf(path)
    FileUtils.mkdir(path)
    File.write("#{path}/index.html", "I was previously generated.")
  end

  def with_env(key, value)
    old_value = ENV[key]
    ENV[key] = value
    yield
    ENV[key] = old_value
  end

  def md5_digest(path)
    require "digest"
    Digest::MD5.file(path).hexdigest
  end

  def capture_output(level = :debug)
    buffer = StringIO.new
    Jekyll.logger = Logger.new(buffer)
    Jekyll.logger.log_level = level
    yield
    buffer.rewind
    buffer.string.to_s
  ensure
    Jekyll.logger = Logger.new(StringIO.new, :error)
  end
  alias_method :capture_stdout, :capture_output
  alias_method :capture_stderr, :capture_output

  def nokogiri_fragment(str)
    Nokogiri::HTML.fragment(
      str
    )
  end

  def skip_if_windows(msg = nil)
    if Utils::Platforms.really_windows?
      msg ||= "Jekyll does not currently support this feature on Windows."
      skip msg.to_s.magenta
    end
  end

  def symlink_if_allowed(target, sym_file)
    FileUtils.ln_sf(target, sym_file)
  rescue Errno::EACCES
    skip "Permission denied for creating a symlink to #{target.inspect} " \
         "on this machine".magenta
  rescue NotImplementedError => e
    skip e.to_s.magenta
  end
end

class FakeLogger
  def <<(str); end
end

module TestWEBrick
  module_function

  def mount_server(&block)
    server = WEBrick::HTTPServer.new(config)

    begin
      server.mount("/", Jekyll::Commands::Serve::Servlet, document_root,
                   document_root_options)

      server.start
      addr = server.listeners[0].addr
      block.yield([server, addr[3], addr[1]])
    rescue StandardError => e
      raise e
    ensure
      server.shutdown
      sleep 0.1 until server.status == :Stop
    end
  end

  def config
    logger = FakeLogger.new
    {
      :BindAddress => "127.0.0.1", :Port => 0,
      :ShutdownSocketWithoutClose => true,
      :ServerType => Thread,
      :Logger => WEBrick::Log.new(logger),
      :AccessLog => [[logger, ""]],
      :MimeTypesCharset => Jekyll::Commands::Serve.send(:mime_types_charset),
      :JekyllOptions => {},
    }
  end

  def document_root
    "#{File.dirname(__FILE__)}/fixtures/webrick"
  end

  def document_root_options
    WEBrick::Config::FileHandler.merge(
      :FancyIndexing     => true,
      :NondisclosureName => [
        ".ht*", "~*",
      ]
    )
  end
end

class TagUnitTest < JekyllUnitTest
  def render_content(content, override = {})
    base_config = {
      "source"      => source_dir,
      "destination" => dest_dir,
    }
    site = fixture_site(base_config.merge(override))

    if override["read_posts"]
      site.posts.docs.concat(PostReader.new(site).read_posts(""))
    elsif override["read_collections"]
      CollectionReader.new(site).read
    elsif override["read_all"]
      site.read
    end

    @result = render_with(site, content)
  end

  private

  def render_with(site, content)
    converter = site.converters.find { |c| c.instance_of?(Jekyll::Converters::Markdown) }
    payload   = { "highlighter_prefix" => converter.highlighter_prefix,
                  "highlighter_suffix" => converter.highlighter_suffix, }
    info = { :registers => { :site => site } }
    converter.convert(
      Liquid::Template.parse(content).render!(payload, info)
    )
  end
end
