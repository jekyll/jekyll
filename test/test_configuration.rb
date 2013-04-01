require 'helper'

class TestConfiguration < Test::Unit::TestCase
  context "loading configuration" do
    setup do
      @path = File.join(Dir.pwd, '_config.yml')
    end

    should "fire warning with no _config.yml" do
      mock(YAML).safe_load_file(@path) { raise SystemCallError, "No such file or directory - #{@path}" }
      mock($stderr).puts("Configuration file: none")
      assert_equal Jekyll::DEFAULTS, Jekyll.configuration({})
    end

    should "load configuration as hash" do
      mock(YAML).safe_load_file(@path) { Hash.new }
      mock($stdout).puts("Configuration file: #{@path}")
      assert_equal Jekyll::DEFAULTS, Jekyll.configuration({})
    end

    should "fire warning with bad config" do
      mock(YAML).safe_load_file(@path) { Array.new }
      mock($stderr).puts("           WARNING: Error reading configuration. Using defaults (and options).")
      mock($stderr).puts("Configuration file: (INVALID) #{@path}")
      assert_equal Jekyll::DEFAULTS, Jekyll.configuration({})
    end
  end

  context "loading config from external file" do
    setup do
      @paths = {
        :default => File.join(Dir.pwd, '_config.yml'),
        :other   => File.join(Dir.pwd, '_config.live.yml'),
        :empty   => ""
      }
    end

    should "load default config if no config_file is set" do
      mock(YAML).safe_load_file(@paths[:default]) { Hash.new }
      mock($stdout).puts("Configuration file: #{@paths[:default]}")
      assert_equal Jekyll::DEFAULTS, Jekyll.configuration({})
    end

    should "load different config if specified" do
      mock(YAML).safe_load_file(@paths[:other]) { {"baseurl" => "http://wahoo.dev"} }
      mock($stdout).puts("Configuration file: #{@paths[:other]}")
      assert_equal Jekyll::DEFAULTS.deep_merge({ "baseurl" => "http://wahoo.dev" }), Jekyll.configuration({ "config" => @paths[:other] })
    end

    should "load default config if path passed is empty" do
      mock(YAML).safe_load_file(@paths[:default]) { Hash.new }
      mock($stdout).puts("Configuration file: #{@paths[:default]}")
      assert_equal Jekyll::DEFAULTS, Jekyll.configuration({ "config" => @paths[:empty] })

    end
  end

  context "loading configuration with includes" do
    setup do
      @replacement_source_dir = File.expand_path('../fixtures/configuration', __FILE__)
    end

    should "include config_a when loading the main config file with one inclusion" do
      mock($stdout).puts("Configuration file: " + @replacement_source_dir + "/one_inclusion/_config.yml")
      mock($stdout).puts("Configuration file: " + @replacement_source_dir + "/one_inclusion/configs/_config_a.yml")
      config = Jekyll.configuration({"source" => File.join(@replacement_source_dir, 'one_inclusion')})
      assert_equal "/foobar", config["root"]
    end
    should "include config_a when loading the main config file with glob inclusions" do
      mock($stdout).puts("Configuration file: " + @replacement_source_dir + "/pattern_include/_config.yml")
      mock($stdout).puts("Configuration file: " + @replacement_source_dir + "/pattern_include/configs/_config_a.yml")
      mock($stdout).puts("Configuration file: " + @replacement_source_dir + "/pattern_include/configs/_config_b.yml")
      config = Jekyll.configuration({"source" => File.join(@replacement_source_dir, 'pattern_include')})
      assert_equal "/buzz", config["root"]
    end
    should "include config_a when loading the main config file with one inclusion, letting the included config overrule them all" do
      mock($stdout).puts("Configuration file: " + @replacement_source_dir + "/root_config_override/_config.yml")
      mock($stdout).puts("Configuration file: " + @replacement_source_dir + "/root_config_override/configs/_config_a.yml")
      config = Jekyll.configuration({"source" => File.join(@replacement_source_dir, 'root_config_override')})
      assert_equal "/overruled", config["root"]

    end
  end
end
