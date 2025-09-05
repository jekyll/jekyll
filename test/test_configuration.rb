# frozen_string_literal: true

require "helper"
require "colorator"

class TestConfiguration < JekyllUnitTest
  test_config = {
    "source"      => new(nil).source_dir,
    "destination" => dest_dir,
  }

  context ".from" do
    should "create a Configuration object" do
      assert_instance_of Configuration, Configuration.from({})
    end

    should "merge input over defaults" do
      result = Configuration.from("source" => "blah")
      refute_equal result["source"], Configuration::DEFAULTS["source"]
      assert_equal "blah", result["source"]
    end

    should "return a valid Configuration instance" do
      assert_instance_of Configuration, Configuration.from({})
    end

    should "add default collections" do
      result = Configuration.from({})
      expected = { "posts" => {
        "output"    => true,
        "permalink" => "/:categories/:year/:month/:day/:title:output_ext",
      } }
      assert_equal expected, result["collections"]
    end

    should "NOT backwards-compatibilize" do
      assert(
        Configuration.from("watch" => true)["watch"],
        "Expected the 'watch' key to not be removed."
      )
    end
  end

  context "the effective site configuration" do
    setup do
      @config = Configuration.from(
        "exclude" => %w(
          README.md Licence
        )
      )
    end

    should "always exclude node_modules" do
      assert_includes @config["exclude"], "node_modules"
    end

    should "always exclude Gemfile and related paths" do
      exclude = @config["exclude"]
      assert_includes exclude, "Gemfile"
      assert_includes exclude, "Gemfile.lock"
      assert_includes exclude, "gemfiles"
    end

    should "always exclude ruby vendor directories" do
      exclude = @config["exclude"]
      assert_includes exclude, "vendor/bundle/"
      assert_includes exclude, "vendor/cache/"
      assert_includes exclude, "vendor/gems/"
      assert_includes exclude, "vendor/ruby/"
    end

    should "always exclude default cache directories" do
      exclude = @config["exclude"]
      assert_includes exclude, ".sass-cache"
      assert_includes exclude, ".jekyll-cache"
    end
  end

  context "#add_default_collections" do
    should "no-op if collections is nil" do
      result = Configuration[{ "collections" => nil }].add_default_collections
      assert_nil result["collections"]
    end

    should "turn an array into a hash" do
      result = Configuration[{ "collections" => %w(methods) }].add_default_collections
      assert_instance_of Hash, result["collections"]
      expected = { "posts" => { "output" => true }, "methods" => {} }
      assert_equal expected, result["collections"]
    end

    should "only assign collections.posts.permalink if a permalink is specified" do
      result = Configuration[{ "permalink" => "pretty", "collections" => {} }]
        .add_default_collections

      expected = {
        "posts" => {
          "output"    => true,
          "permalink" => "/:categories/:year/:month/:day/:title/",
        },
      }

      assert_equal expected, result["collections"]

      result   = Configuration[{ "permalink" => nil, "collections" => {} }].add_default_collections
      expected = { "posts" => { "output" => true } }

      assert_equal expected, result["collections"]
    end

    should "forces posts to output" do
      result = Configuration[{ "collections" => { "posts" => { "output" => false } } }]
        .add_default_collections
      assert result["collections"]["posts"]["output"]
    end
  end

  context "#stringify_keys" do
    setup do
      @mixed_keys = Configuration[{
        "markdown" => "kramdown",
        :permalink => "date",
        "baseurl"  => "/",
        :include   => [".htaccess"],
        :source    => "./",
      }]

      @string_keys = Configuration[{
        "markdown"  => "kramdown",
        "permalink" => "date",
        "baseurl"   => "/",
        "include"   => [".htaccess"],
        "source"    => "./",
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
      @config = Configuration[{ "source" => source_dir }]
      @no_override     = {}
      @one_config_file = { "config" => "config.yml" }
      @multiple_files  = {
        "config" => %w(config/site.yml config/deploy.toml configuration.yml),
      }
    end

    should "always return an array" do
      assert_kind_of Array, @config.config_files(@no_override)
      assert_kind_of Array, @config.config_files(@one_config_file)
      assert_kind_of Array, @config.config_files(@multiple_files)
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

    should "return .toml if that exists" do
      allow(File).to receive(:exist?).with(source_dir("_config.yml")).and_return(false)
      allow(File).to receive(:exist?).with(source_dir("_config.yaml")).and_return(false)
      allow(File).to receive(:exist?).with(source_dir("_config.toml")).and_return(true)
      assert_equal [source_dir("_config.toml")], @config.config_files(@no_override)
    end

    should "return .yml if both .yml and .toml exist" do
      allow(File).to receive(:exist?).with(source_dir("_config.yml")).and_return(true)
      allow(File).to receive(:exist?).with(source_dir("_config.toml")).and_return(true)
      assert_equal [source_dir("_config.yml")], @config.config_files(@no_override)
    end

    should "return the config if given one config file" do
      assert_equal %w(config.yml), @config.config_files(@one_config_file)
    end

    should "return an array of the config files if given many config files" do
      assert_equal(
        %w(config/site.yml config/deploy.toml configuration.yml),
        @config.config_files(@multiple_files)
      )
    end
  end

  context "#read_config_file" do
    setup do
      @config = Configuration[{ "source" => source_dir("empty.yml") }]
    end

    should "not raise an error on empty files" do
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(File.expand_path("empty.yml")).and_return(false)
      Jekyll.logger.log_level = :warn
      @config.read_config_file("empty.yml")
      Jekyll.logger.log_level = :info
    end
  end

  context "#read_config_files" do
    setup do
      @config = Configuration[{ "source" => source_dir }]
    end

    should "continue to read config files if one is empty" do
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(File.expand_path("empty.yml")).and_return(false)
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(File.expand_path("not_empty.yml")).and_return(
        "foo" => "bar"
      )
      Jekyll.logger.log_level = :warn
      read_config = @config.read_config_files(%w(empty.yml not_empty.yml))
      Jekyll.logger.log_level = :info
      assert_equal "bar", read_config["foo"]
    end
  end

  context "#validate" do
    setup do
      @config = Configuration[{
        "auto"        => true,
        "watch"       => true,
        "server"      => true,
        "pygments"    => true,
        "layouts"     => true,
        "data_source" => true,
        "gems"        => [],
      }]
    end

    should "raise an error if `exclude` key is a string" do
      config = Configuration[{ "exclude" => "READ-ME.md, Gemfile,CONTRIBUTING.hello.markdown" }]
      assert_raises(Jekyll::Errors::InvalidConfigurationError) { config.validate }
    end

    should "raise an error if `include` key is a string" do
      config = Configuration[{ "include" => "STOP_THE_PRESSES.txt,.heloses, .git" }]
      assert_raises(Jekyll::Errors::InvalidConfigurationError) { config.validate }
    end

    should "raise an error if `plugins` key is a string" do
      config = Configuration[{ "plugins" => "_plugin" }]
      assert_raises(Jekyll::Errors::InvalidConfigurationError) { config.validate }
    end

    should "not rename configuration keys" do
      assert @config.key?("layouts")
      assert @config.validate.key?("layouts")
      refute @config.validate.key?("layouts_dir")

      assert @config.key?("data_source")
      assert @config.validate.key?("data_source")
      refute @config.validate.key?("data_dir")

      assert @config.key?("gems")
      assert @config.validate.key?("gems")
      refute @config.validate.key?("plugins")
    end
  end

  context "loading configuration" do
    setup do
      @path = source_dir("_config.yml")
      @user_config = File.join(Dir.pwd, "my_config_file.yml")
    end

    should "fire warning with no _config.yml" do
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(@path) do
        raise SystemCallError, "No such file or directory - #{@path}"
      end
      allow($stderr).to receive(:puts).with(
        Colorator.yellow("Configuration file: none")
      )
      assert_equal site_configuration, Jekyll.configuration(test_config)
    end

    should "load configuration as hash" do
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(@path).and_return({})
      allow($stdout).to receive(:puts).with("Configuration file: #{@path}")
      assert_equal site_configuration, Jekyll.configuration(test_config)
    end

    should "fire warning with bad config" do
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(@path).and_return([])
      allow($stderr)
        .to receive(:puts)
        .and_return(
          "WARNING: ".rjust(20) +
          Colorator.yellow("Error reading configuration. Using defaults (and options).")
        )
      allow($stderr)
        .to receive(:puts)
        .and_return(Colorator.yellow("Configuration file: (INVALID) #{@path}"))
      assert_equal site_configuration, Jekyll.configuration(test_config)
    end

    should "fire warning when user-specified config file isn't there" do
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(@user_config) do
        raise SystemCallError, "No such file or directory - #{@user_config}"
      end
      allow($stderr)
        .to receive(:puts)
        .with(Colorator.red(
                "Fatal: ".rjust(20) + \
                "The configuration file '#{@user_config}' could not be found."
              ))
      assert_raises LoadError do
        Jekyll.configuration("config" => [@user_config])
      end
    end

    should "not clobber YAML.load to the dismay of other libraries" do
      assert_equal :foo, YAML.load(":foo")
      # as opposed to: assert_equal ':foo', Jekyll::Utils.safe_load_yaml(':foo')
    end
  end

  context "loading config from external file" do
    setup do
      @paths = {
        :default => source_dir("_config.yml"),
        :other   => source_dir("_config.live.yml"),
        :toml    => source_dir("_config.dev.toml"),
        :empty   => "",
      }
    end

    should "load default plus posts config if no config_file is set" do
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(@paths[:default]).and_return({})
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:default]}")
      assert_equal site_configuration, Jekyll.configuration(test_config)
    end

    should "load different config if specified" do
      allow(Jekyll::Utils)
        .to receive(:safe_load_yaml_file)
        .with(@paths[:other])
        .and_return("baseurl" => "http://example.com")
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:other]}")
      assert_equal \
        site_configuration(
          "baseurl" => "http://example.com",
          "config"  => @paths[:other]
        ),
        Jekyll.configuration(test_config.merge("config" => @paths[:other]))
    end

    should "load different config if specified with symbol key" do
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(@paths[:default]).and_return({})
      allow(Jekyll::Utils)
        .to receive(:safe_load_yaml_file)
        .with(@paths[:other])
        .and_return("baseurl" => "http://example.com")
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:other]}")
      assert_equal \
        site_configuration(
          "baseurl" => "http://example.com",
          "config"  => @paths[:other]
        ),
        Jekyll.configuration(test_config.merge(:config => @paths[:other]))
    end

    should "load default config if path passed is empty" do
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(@paths[:default]).and_return({})
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:default]}")
      assert_equal \
        site_configuration("config" => [@paths[:empty]]),
        Jekyll.configuration(test_config.merge("config" => [@paths[:empty]]))
    end

    should "successfully load a TOML file" do
      Jekyll.logger.log_level = :warn
      assert_equal \
        site_configuration(
          "baseurl" => "/you-beautiful-blog-you",
          "title"   => "My magnificent site, wut",
          "config"  => [@paths[:toml]]
        ),
        Jekyll.configuration(test_config.merge("config" => [@paths[:toml]]))
      Jekyll.logger.log_level = :info
    end

    should "load multiple config files" do
      External.require_with_graceful_fail("tomlrb")

      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(@paths[:default]).and_return({})
      allow(Jekyll::Utils).to receive(:safe_load_yaml_file).with(@paths[:other]).and_return({})
      allow(Tomlrb).to receive(:load_file).with(@paths[:toml]).and_return({})
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:default]}")
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:other]}")
      allow($stdout).to receive(:puts).with("Configuration file: #{@paths[:toml]}")
      assert_equal(
        site_configuration(
          "config" => [@paths[:default], @paths[:other], @paths[:toml]]
        ),
        Jekyll.configuration(
          test_config.merge(
            "config" => [@paths[:default], @paths[:other], @paths[:toml]]
          )
        )
      )
    end

    should "load multiple config files and last config should win" do
      allow(Jekyll::Utils)
        .to receive(:safe_load_yaml_file)
        .with(@paths[:default])
        .and_return("baseurl" => "http://example.dev")
      allow(Jekyll::Utils)
        .to receive(:safe_load_yaml_file)
        .with(@paths[:other])
        .and_return("baseurl" => "http://example.com")
      allow($stdout)
        .to receive(:puts)
        .with("Configuration file: #{@paths[:default]}")
      allow($stdout)
        .to receive(:puts)
        .with("Configuration file: #{@paths[:other]}")
      assert_equal \
        site_configuration(
          "baseurl" => "http://example.com",
          "config"  => [@paths[:default], @paths[:other]]
        ),
        Jekyll.configuration(
          test_config.merge("config" => [@paths[:default], @paths[:other]])
        )
    end
  end

  context "#add_default_collections" do
    should "not do anything if collections is nil" do
      conf = Configuration[default_configuration].tap { |c| c["collections"] = nil }
      assert_equal conf.add_default_collections, conf
      assert_nil conf.add_default_collections["collections"]
    end

    should "converts collections to a hash if an array" do
      conf = Configuration[default_configuration].tap do |c|
        c["collections"] = ["docs"]
      end
      assert_equal conf.add_default_collections, conf.merge(
        "collections" => {
          "docs"  => {},
          "posts" => {
            "output"    => true,
            "permalink" => "/:categories/:year/:month/:day/:title:output_ext",
          },
        }
      )
    end

    should "force collections.posts.output = true" do
      conf = Configuration[default_configuration].tap do |c|
        c["collections"] = { "posts" => { "output" => false } }
      end
      assert_equal conf.add_default_collections, conf.merge(
        "collections" => {
          "posts" => {
            "output"    => true,
            "permalink" => "/:categories/:year/:month/:day/:title:output_ext",
          },
        }
      )
    end

    should "set collections.posts.permalink if it's not set" do
      conf = Configuration[default_configuration]
      assert_equal conf.add_default_collections, conf.merge(
        "collections" => {
          "posts" => {
            "output"    => true,
            "permalink" => "/:categories/:year/:month/:day/:title:output_ext",
          },
        }
      )
    end

    should "leave collections.posts.permalink alone if it is set" do
      posts_permalink = "/:year/:title/"
      conf = Configuration[default_configuration].tap do |c|
        c["collections"] = {
          "posts" => { "permalink" => posts_permalink },
        }
      end
      assert_equal conf.add_default_collections, conf.merge(
        "collections" => {
          "posts" => {
            "output"    => true,
            "permalink" => posts_permalink,
          },
        }
      )
    end
  end

  context "folded YAML string" do
    setup do
      @tester = Configuration.new
    end

    should "ignore newlines in that string entirely from a sample file" do
      config = Jekyll.configuration(
        @tester.read_config_file(
          source_dir("_config_folded.yml")
        )
      )
      assert_equal(
        "This string of text will ignore newlines till the next key.\n",
        config["folded_string"]
      )

      assert_equal(
        "This string of text will ignore newlines till the next key.",
        config["clean_folded_string"]
      )
    end

    should "ignore newlines in that string entirely from the template file" do
      config = Jekyll.configuration(
        @tester.read_config_file(
          File.expand_path("../lib/site_template/_config.yml", File.dirname(__FILE__))
        )
      )
      assert_includes config["description"], "an awesome description"
      refute_includes config["description"], "\n"
    end
  end
end
