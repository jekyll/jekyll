require 'helper'

class TestDeprecator < Test::Unit::TestCase
  context ".config" do
    setup do
      @config = Configuration[{
        "auto"        => true,
        "watch"       => true,
        "server"      => true,
        "exclude"     => "READ-ME.md, Gemfile,CONTRIBUTING.hello.markdown",
        "include"     => "STOP_THE_PRESSES.txt,.heloses, .git",
        "server_port" => 6666
      }]
      $stderr.stubs(:puts)
    end
    should "fire warning and unset 'auto'" do
      $stderr.expects(:puts).with { |param| param.include? "Deprecation: Auto-regeneration can no longer be set from your configuration file(s). Use the --watch/-w command-line option instead." }
      assert @config.has_key?("auto")
      assert !Deprecator.config(@config).has_key?("auto")
    end
    should "fire warning and unset 'watch'" do
      $stderr.expects(:puts).with { |param| param.include? "Deprecation: Auto-regeneration can no longer be set from your configuration file(s). Use the --watch/-w command-line option instead." }
      assert @config.has_key?("watch")
      assert !Deprecator.config(@config).has_key?("watch")
    end
    should "fire warning and unset 'server'" do
      $stderr.expects(:puts).with { |param| param.include? "Deprecation: The 'server' configuration option is no longer accepted. Use the 'jekyll serve' subcommand to serve your site with WEBrick." }
      assert @config.has_key?("server")
      assert !Deprecator.config(@config).has_key?("server")
    end
    should "fire warning and transform string exclude into an array" do
      $stderr.expects(:puts).with { |param| param.include? "Deprecation: The 'exclude' configuration option must now be specified as an array, but you specified a string. For now, we've treated the string you provided as a list of comma-separated values." }
      compatible_config = Deprecator.config(@config)
      assert @config.has_key?("exclude")
      assert compatible_config.has_key?("exclude")
      assert_equal compatible_config["exclude"],
                    %w[READ-ME.md Gemfile CONTRIBUTING.hello.markdown]
    end
    should "fire warning and transform string include into an array" do
      $stderr.expects(:puts).with { |param| param.include? "Deprecation: The 'include' configuration option must now be specified as an array, but you specified a string. For now, we've treated the string you provided as a list of comma-separated values." }
      compatible_config = Deprecator.config(@config)
      assert @config.has_key?("include")
      assert compatible_config.has_key?("include")
      assert_equal compatible_config["include"],
                    %w[STOP_THE_PRESSES.txt .heloses .git]
    end
    should "fire warning and rename key server_port to port" do
      $stderr.expects(:puts).with { |param| param.include? "Deprecation: The 'server_port' configuration option has been renamed to 'port'. Please update your config file accordingly." }
      compatible_config = Deprecator.config(@config)
      assert @config.has_key?("server_port")
      assert !@config.has_key?("port")
      assert !compatible_config.has_key?("server_port")
      assert compatible_config.has_key?("port")
      assert_equal compatible_config["port"], @config["server_port"]
    end
  end
  context ".command" do
  end
end