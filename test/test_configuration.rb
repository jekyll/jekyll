require 'helper'

class TestConfiguration < Test::Unit::TestCase
  context "loading configuration" do
    setup do
      @path = File.join(Dir.pwd, '_config.yml')
    end

    should "fire warning with no _config.yml" do
      mock(YAML).load_file(@path) { raise "No such file or directory - #{@path}" }
      mock($stderr).puts("WARNING: Could not read configuration. Using defaults (and options).")
      mock($stderr).puts("\tNo such file or directory - #{@path}")
      assert_equal Jekyll::DEFAULTS, Jekyll.configuration({})
    end

    should "load configuration as hash" do
      mock(YAML).load_file(@path) { Hash.new }
      mock($stdout).puts("Configuration from #{@path}")
      assert_equal Jekyll::DEFAULTS, Jekyll.configuration({})
    end

    should "fire warning with bad config" do
      mock(YAML).load_file(@path) { Array.new }
      mock($stderr).puts("WARNING: Could not read configuration. Using defaults (and options).")
      mock($stderr).puts("\tInvalid configuration - #{@path}")
      assert_equal Jekyll::DEFAULTS, Jekyll.configuration({})
    end
  end

  context "loading configuration with includes" do
    setup do
      @replacement_source_dir = File.join(Dir.pwd, 'test', 'fixtures', 'configuration')

    end

    should "include config_a when loading the main config file with one inclusion" do
      mock($stdout).puts("Configuration from /Users/mario/Dev/Source/jekyll/test/fixtures/configuration/one_inclusion/_config.yml")
      mock($stdout).puts("Configuration from /Users/mario/Dev/Source/jekyll/test/fixtures/configuration/one_inclusion/additional_configs/_config_a.yml")
      config = Jekyll.configuration({"source" => File.join(@replacement_source_dir, 'one_inclusion')})
      assert_equal "/foobar", config["root"]
    end
    should "include multiple config files when loading the main config file with one glob inclusion" do
      mock($stdout).puts("Configuration from /Users/mario/Dev/Source/jekyll/test/fixtures/configuration/pattern_include/_config.yml")
      mock($stdout).puts("Configuration from /Users/mario/Dev/Source/jekyll/test/fixtures/configuration/pattern_include/additional_configs/_config_a.yml")
      mock($stdout).puts("Configuration from /Users/mario/Dev/Source/jekyll/test/fixtures/configuration/pattern_include/additional_configs/_config_b.yml")
      config = Jekyll.configuration({"source" => File.join(@replacement_source_dir, 'pattern_include')})
      assert_equal "/buzz", config["root"]
    end
    should "let the root config overrule all specified configuration files" do
      mock($stdout).puts("Configuration from /Users/mario/Dev/Source/jekyll/test/fixtures/configuration/root_config_override/_config.yml")
      mock($stdout).puts("Configuration from /Users/mario/Dev/Source/jekyll/test/fixtures/configuration/root_config_override/additional_configs/_config_a.yml")
      config = Jekyll.configuration({"source" => File.join(@replacement_source_dir, 'root_config_override')})
      assert_equal "/overruled", config["root"]
    end
  end
end
