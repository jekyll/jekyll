require 'helper'

class TestConfiguration < JekyllUnitTest
  @@test_config = {
    "source" => new(nil).source_dir,
    "destination" => dest_dir
  }

  context ".from" do
    should "create a Configuration object" do
      assert_instance_of Configuration, Configuration.from({})
    end

    should "merge input over defaults" do
      result = Configuration.from({"source" => "blah"})
      refute_equal result["source"], Configuration::DEFAULTS["source"]
      assert_equal result["source"], "blah"
    end

    should "fix common mistakes" do
      result = Configuration.from({"paginate" => 0})
      assert_nil result["paginate"], "Expected 'paginate' to be corrected to 'nil', but was #{result["paginate"].inspect}"
    end

    should "add default collections" do
      result = Configuration.from({})
      assert_equal result["collections"], {"posts" => {"output" => true, "permalink" => "/:categories/:year/:month/:day/:title.html"}}
    end

    should "NOT backwards-compatibilize" do
      assert Configuration.from("watch" => true)["watch"], "Expected the 'watch' key to not be removed."
    end
  end

  context "#add_default_collections" do
    should "no-op if collections is nil" do
      result = Configuration[{"collections" => nil}].add_default_collections
      assert_nil result["collections"]
    end

    should "turn an array into a hash" do
      result = Configuration[{"collections" => %w{methods}}].add_default_collections
      assert_instance_of Hash, result["collections"]
      assert_equal result["collections"], {"posts" => {"output" => true}, "methods" => {}}
    end

    should "only assign collections.posts.permalink if a permalink is specified" do
      result = Configuration[{"permalink" => "pretty", "collections" => {}}].add_default_collections
      assert_equal result["collections"], {"posts" => {"output" => true, "permalink" => "/:categories/:year/:month/:day/:title/"}}

      result = Configuration[{"permalink" => nil, "collections" => {}}].add_default_collections
      assert_equal result["collections"], {"posts" => {"output" => true}}
    end

    should "forces posts to output" do
      result = Configuration[{"collections" => {"posts" => {"output" => false}}}].add_default_collections
      assert_equal result["collections"]["posts"]["output"], true
    end
  end

  context "#stringify_keys" do
    setup do
      @mixed_keys = Configuration[{
        'markdown' => 'kramdown',
        :permalink => 'date',
        'baseurl'  => '/',
        :include   => ['.htaccess'],
        :source    => './'
      }]
      @string_keys = Configuration[{
        'markdown'  => 'kramdown',
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
      @multiple_files  = {"config" => %w[config/site.yml config/deploy.toml configuration.yml]}
    end

    should "always return an array" do
      assert @config.config_files(@no_override).is_a?(Array)
      assert @config.config_files(@one_config_file).is_a?(Array)
      assert @config.config_files(@multiple_files).is_a?(Array)
    end
    should "return the default config path if no config files are specified" do
      assert_equal [source_dir("_config.yml")], @config.config_files(@no_override)
    end
    should "return .yaml if it exists but .yml does not" do
      allow(File).to receive(:exist?).with(source_dir("_config.yml")).and_return(false)
      allow(File).to receive(:exist?).with(source_dir("_config.yaml")).and_return(true)
      assert_equal [source_dir("_config.yaml")], @config.config_files(@no_override)
    end
    should "return .yml if both .yml and .yaml exist" do
      allow(File).to receive(:exist?).with(source_dir("_config.yml")).and_return(true)
      assert_equal [source_dir("_config.yml")], @config.config_files(@no_override)
    end
    should "return the config if given one config file" do
      assert_equal %w[config.yml], @config.config_files(@one_config_file)
    end
    should "return an array of the config files if given many config files" do
      assert_equal %w[config/site.yml config/deploy.toml configuration.yml], @config.config_files(@multiple_files)
    end
  end
  context "#backwards_compatibilize" do
    setup do
      @config = Configuration[{
        "auto"     => true,
        "watch"    => true,
        "server"   => true,
        "exclude"  => "READ-ME.md, Gemfile,CONTRIBUTING.hello.markdown",
        "include"  => "STOP_THE_PRESSES.txt,.heloses, .git",
        "pygments" => true,
        "plugins" => true,
        "layouts" => true,
        "data_source" => true,
      }]
    end
    should "unset 'auto' and 'watch'" do
      assert @config.key?("auto")
      assert @config.key?("watch")
      assert !@config.backwards_compatibilize.key?("auto")
      assert !@config.backwards_compatibilize.key?("watch")
    end
    should "unset 'server'" do
      assert @config.key?("server")
      assert !@config.backwards_compatibilize.key?("server")
    end
    should "transform string exclude into an array" do
      assert @config.key?("exclude")
      assert @config.backwards_compatibilize.key?("exclude")
      assert_equal @config.backwards_compatibilize["exclude"], %w[READ-ME.md Gemfile CONTRIBUTING.hello.markdown]
    end
    should "transform string include into an array" do
      assert @config.key?("include")
      assert @config.backwards_compatibilize.key?("include")
      assert_equal @config.backwards_compatibilize["include"], %w[STOP_THE_PRESSES.txt .heloses .git]
    end
    should "set highlighter to pygments" do
      assert @config.key?("pygments")
      assert !@config.backwards_compatibilize.key?("pygments")
      assert_equal @config.backwards_compatibilize["highlighter"], "pygments"
    end
    should "adjust directory names" do
      assert @config.key?("plugins")
      assert !@config.backwards_compatibilize.key?("plugins")
      assert @config.backwards_compatibilize["plugins_dir"]
      assert @config.key?("layouts")
      assert !@config.backwards_compatibilize.key?("layouts")
      assert @config.backwards_compatibilize["layouts_dir"]
      assert @config.key?("data_source")
      assert !@config.backwards_compatibilize.key?("data_source")
      assert @config.backwards_compatibilize["data_dir"]
    end
  end
  context "#fix_common_issues" do
    setup do
      @config = Proc.new do |val|
        Configuration[{
          'paginate' => val
        }]
      end
    end
    should "sets an invalid 'paginate' value to nil" do
      assert_nil @config.call(0).fix_common_issues['paginate']
      assert_nil @config.call(-1).fix_common_issues['paginate']
      assert_nil @config.call(true).fix_common_issues['paginate']
    end
  end
  context "loading configuration" do
    setup do
      @path = source_dir('_config.yml')
      @user_config = File.join(Dir.pwd, "my_config_file.yml")
    end

    should "fire warning with no _config.yml" do
      allow(SafeYAML).to receive(:load_file).with(@path) { raise SystemCallError, "No such file or directory - #{@path}" }
      allow($stderr).to receive(:puts).with("Configuration file: none".yellow)
      assert_equal site_configuration, Jekyll.configuration(@@test_config)
    end

    should "load configuration as hash" do
      allow(SafeYAML).to receive(:load_file).with(@path).and_return(Hash.new)
      allow($stdout).to receive(:puts).with("Configuration file: #{@path}")
      assert_equal site_configuration, Jekyll.configuration(@@test_config)
    end

    should "fire warning with bad config" do
      allow(SafeYAML).to receive(:load_file).with(@path).and_return(Array.new)
      allow($stderr).to receive(:puts).and_return(("WARNING: ".rjust(20) + "Error reading configuration. Using defaults (and options).").yellow)
      allow($stderr).to receive(:puts).and_return("Configuration file: (INVALID) #{@path}".yellow)
      assert_equal site_configuration, Jekyll.configuration(@@test_config)
    end

    should "fire warning when user-specified config file isn't there" do
      allow(SafeYAML).to receive(:load_file).with(@user_config) { raise SystemCallError, "No such file or directory - #{@user_config}" }
      allow($stderr).to receive(:puts).with(("Fatal: ".rjust(20) + "The configuration file '#{@user_config}' could not be found.").red)
      assert_raises LoadError do
        Jekyll.configuration({'config' => [@user_config]})
      end
    end

    should "not clobber YAML.load to the dismay of other libraries" do
      assert_equal :foo, YAML.load(':foo')
      # as opposed to: assert_equal ':foo', SafeYAML.load(':foo')
    end
  end
  context "loading config from external file" do
    setup do
      @paths = {
        :default => source_dir('_config.yml'),
        :other   => source_dir('_config.live.yml'),
        :toml    => source_dir('_config.dev.toml'),
        :empty   => ""
      }
    end

    should "load default plus posts config if no config_file is set" do
      allow(SafeYAML).to receive(:load_file).with(@paths[:default]).and_return({})
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:default]}")
      assert_equal site_configuration, Jekyll.configuration(@@test_config)
    end

    should "load different config if specified" do
      allow(SafeYAML).to receive(:load_file).with(@paths[:other]).and_return({"baseurl" => "http://wahoo.dev"})
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:other]}")
      Jekyll.configuration({ "config" => @paths[:other] })
      assert_equal \
        site_configuration({ "baseurl" => "http://wahoo.dev" }),
        Jekyll.configuration(@@test_config.merge({ "config" => @paths[:other] }))
    end

    should "load default config if path passed is empty" do
      allow(SafeYAML).to receive(:load_file).with(@paths[:default]).and_return({})
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:default]}")
      assert_equal \
        site_configuration,
        Jekyll.configuration(@@test_config.merge({ "config" => [@paths[:empty]] }))
    end

    should "successfully load a TOML file" do
      Jekyll.logger.log_level = :warn
      assert_equal \
        site_configuration({ "baseurl" => "/you-beautiful-blog-you", "title" => "My magnificent site, wut" }),
        Jekyll.configuration(@@test_config.merge({ "config" => [@paths[:toml]] }))
      Jekyll.logger.log_level = :info
    end

    should "load multiple config files" do
      External.require_with_graceful_fail('toml')

      allow(SafeYAML).to receive(:load_file).with(@paths[:default]).and_return(Hash.new)
      allow(SafeYAML).to receive(:load_file).with(@paths[:other]).and_return(Hash.new)
      allow(TOML).to receive(:load_file).with(@paths[:toml]).and_return(Hash.new)
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:default]}")
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:other]}")
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:toml]}")
      assert_equal \
        site_configuration,
        Jekyll.configuration(@@test_config.merge({ "config" => [@paths[:default], @paths[:other], @paths[:toml]] }))
    end

    should "load multiple config files and last config should win" do
      allow(SafeYAML).to receive(:load_file).with(@paths[:default]).and_return({"baseurl" => "http://example.dev"})
      allow(SafeYAML).to receive(:load_file).with(@paths[:other]).and_return({"baseurl" => "http://wahoo.dev"})
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:default]}")
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:other]}")
      assert_equal \
        site_configuration({ "baseurl" => "http://wahoo.dev" }),
        Jekyll.configuration(@@test_config.merge({ "config" => [@paths[:default], @paths[:other]] }))
    end
  end

  context "#add_default_collections" do
    should "not do anything if collections is nil" do
      conf = Configuration[default_configuration].tap {|c| c['collections'] = nil }
      assert_equal conf.add_default_collections, conf
      assert_nil conf.add_default_collections['collections']
    end

    should "converts collections to a hash if an array" do
      conf = Configuration[default_configuration].tap {|c| c['collections'] = ['docs'] }
      assert_equal conf.add_default_collections, conf.merge({
        "collections" => {
          "docs" => {},
          "posts" => {
            "output" => true,
            "permalink" => "/:categories/:year/:month/:day/:title.html"
          }}})
    end

    should "force collections.posts.output = true" do
      conf = Configuration[default_configuration].tap {|c| c['collections'] = {'posts' => {'output' => false}} }
      assert_equal conf.add_default_collections, conf.merge({
        "collections" => {
          "posts" => {
            "output" => true,
            "permalink" => "/:categories/:year/:month/:day/:title.html"
          }}})
    end

    should "set collections.posts.permalink if it's not set" do
      conf = Configuration[default_configuration]
      assert_equal conf.add_default_collections, conf.merge({
        "collections" => {
          "posts" => {
            "output" => true,
            "permalink" => "/:categories/:year/:month/:day/:title.html"
          }}})
    end

    should "leave collections.posts.permalink alone if it is set" do
      posts_permalink = "/:year/:title/"
      conf = Configuration[default_configuration].tap do |c|
        c['collections'] = {
          "posts" => { "permalink" => posts_permalink }
        }
      end
      assert_equal conf.add_default_collections, conf.merge({
        "collections" => {
          "posts" => {
            "output" => true,
            "permalink" => posts_permalink
          }}})
    end
  end
end
