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

  context "loading configuration from a non-existent given file" do
    setup do
      @path = File.join(Dir.pwd, 'bad.yml')
    end

    should "fire warning if given file does not exist" do
      mock(YAML).load_file(@path) { raise "No such file or directory - #{@path}" }
      mock($stderr).puts("WARNING: Could not read configuration. Using defaults (and options).")
      mock($stderr).puts("\tNo such file or directory - #{@path}")
      assert_equal Jekyll::DEFAULTS, Jekyll.configuration({'config_file'=>'bad.yml'})
    end
  end

  context "loading configuration from an existent given file" do
    setup do
      @path = File.join(Dir.pwd, '_myconfig.yml')
    end

    should "load configuration as hash" do
      mock(YAML).load_file(@path) { { 'foo' => 'bar' } }
      mock($stdout).puts("Configuration from #{@path}")
      assert_equal Jekyll::DEFAULTS.merge({'config_file'=>'_myconfig.yml', 'foo'=>'bar'}),
                   Jekyll.configuration({'config_file'=>'_myconfig.yml'})
    end
  end

  context "loading configuration from a bad given file" do
    setup do
      @path = File.join(Dir.pwd, '_array_config.yml')
    end

    should "fire warning with bad config" do
      mock(YAML).load_file(@path) { ['foo', 'bar'] }
      mock($stderr).puts("WARNING: Could not read configuration. Using defaults (and options).")
      mock($stderr).puts("\tInvalid configuration - #{@path}")
      assert_equal Jekyll::DEFAULTS, Jekyll.configuration({'config_file'=>'_array_config.yml'})
    end
  end
end
