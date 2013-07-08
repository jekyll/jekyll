require 'helper'

class TestConfiguration < Test::Unit::TestCase
  context "#stringify_keys" do
    setup do
      @mixed_keys = Configuration[{
        'markdown' => 'maruku',
        :permalink => 'date',
        'baseurl'  => '/',
        :include   => ['.htaccess'],
        :source    => './'
      }]
      @string_keys = Configuration[{
        'markdown'  => 'maruku',
        'permalink' => 'date',
        'baseurl'   => '/',
        'include'   => ['.htaccess'],
        'source'    => './'
      }]
    end
    should "stringify symbol keys" do
      assert_equal @string_keys, @mixed_keys.stringify_keys
    end
    should "not mess with keys already strings" do
      assert_equal @string_keys, @string_keys.stringify_keys
    end
  end
  context "#config_files" do
    setup do
      @config = Configuration[{"source" => source_dir}]
      @no_override     = {}
      @one_config_file = {"config" => "config.yml"}
      @multiple_files  = {"config" => %w[config/site.yml config/deploy.yml configuration.yml]}
    end

    should "always return an array" do
      assert @config.config_files(@no_override).is_a?(Array)
      assert @config.config_files(@one_config_file).is_a?(Array)
      assert @config.config_files(@multiple_files).is_a?(Array)
    end
    should "return the default config path if no config files are specified" do
      assert_equal [File.join(source_dir, "_config.yml")], @config.config_files(@no_override)
    end
    should "return the config if given one config file" do
      assert_equal %w[config.yml], @config.config_files(@one_config_file)
    end
    should "return an array of the config files if given many config files" do
      assert_equal %w[config/site.yml config/deploy.yml configuration.yml], @config.config_files(@multiple_files)
    end
  end
  context "loading configuration" do
    setup do
      @path = File.join(Dir.pwd, '_config.yml')
      @user_config = File.join(Dir.pwd, "my_config_file.yml")
      YAML.stubs(:safe_load_file) # to ignore other YAML.safe_load_file invocations from Jekyll.configuration({})
    end

    should "fire warning with no _config.yml" do
      YAML.expects(:safe_load_file).with(@path).raises(SystemCallError, "No such file or directory - #{@path}")
      mock($stderr).puts("Configuration file: none".yellow)
      assert_equal Jekyll::Configuration::DEFAULTS, Jekyll.configuration({})
    end

    should "load configuration as hash" do
      YAML.expects(:safe_load_file).with(@path).returns(Hash.new)
      mock($stdout).puts("Configuration file: #{@path}")
      assert_equal Jekyll::Configuration::DEFAULTS, Jekyll.configuration({})
    end

    should "fire warning with bad config" do
      YAML.expects(:safe_load_file).with(@path).returns(Array.new)
      mock($stderr).puts(("WARNING: ".rjust(20) + "Error reading configuration. Using defaults (and options).").yellow)
      mock($stderr).puts("Configuration file: (INVALID) #{@path}".yellow)
      assert_equal Jekyll::Configuration::DEFAULTS, Jekyll.configuration({})
    end

    should "fire warning when user-specified config file isn't there" do
      YAML.expects(:safe_load_file).with(@user_config).raises(SystemCallError, "No such file or directory - #{@user_config}")
      mock($stderr).puts(("Fatal: ".rjust(20) + "The configuration file '#{@user_config}' could not be found.").red)
      assert_raises LoadError do
        Jekyll.configuration({'config' => [@user_config]})
      end
    end
  end
  context "loading config from external file" do
    setup do
      @paths = {
        :default => File.join(Dir.pwd, '_config.yml'),
        :other   => File.join(Dir.pwd, '_config.live.yml'),
        :empty   => ""
      }
      YAML.stubs(:safe_load_file) # to ignore other YAML.safe_load_file invocations from Jekyll.configuration({})
    end

    should "load default config if no config_file is set" do
      YAML.expects(:safe_load_file).with(@paths[:default]).returns(Hash.new)
      mock($stdout).puts("Configuration file: #{@paths[:default]}")
      assert_equal Jekyll::Configuration::DEFAULTS, Jekyll.configuration({})
    end

    should "load different config if specified" do
      YAML.expects(:safe_load_file).with(@paths[:other]).returns({"baseurl" => "http://wahoo.dev"})
      mock($stdout).puts("Configuration file: #{@paths[:other]}")
      assert_equal Jekyll::Configuration::DEFAULTS.deep_merge({ "baseurl" => "http://wahoo.dev" }), Jekyll.configuration({ "config" => @paths[:other] })
    end

    should "load default config if path passed is empty" do
      YAML.expects(:safe_load_file).with(@paths[:default]).returns(Hash.new)
      mock($stdout).puts("Configuration file: #{@paths[:default]}")
      assert_equal Jekyll::Configuration::DEFAULTS, Jekyll.configuration({ "config" => @paths[:empty] })
    end

    should "load multiple config files" do
      YAML.expects(:safe_load_file).with(@paths[:default]).returns(Hash.new)
      YAML.expects(:safe_load_file).with(@paths[:other]).returns(Hash.new)
      mock($stdout).puts("Configuration file: #{@paths[:default]}")
      mock($stdout).puts("Configuration file: #{@paths[:other]}")
      assert_equal Jekyll::Configuration::DEFAULTS, Jekyll.configuration({ "config" => [@paths[:default], @paths[:other]] })
    end

    should "load multiple config files and last config should win" do
      YAML.expects(:safe_load_file).with(@paths[:default]).returns({"baseurl" => "http://example.dev"})
      YAML.expects(:safe_load_file).with(@paths[:other]).returns({"baseurl" => "http://wahoo.dev"})
      mock($stdout).puts("Configuration file: #{@paths[:default]}")
      mock($stdout).puts("Configuration file: #{@paths[:other]}")
      assert_equal Jekyll::Configuration::DEFAULTS.deep_merge({ "baseurl" => "http://wahoo.dev" }), Jekyll.configuration({ "config" => [@paths[:default], @paths[:other]] })
    end
  end
end
