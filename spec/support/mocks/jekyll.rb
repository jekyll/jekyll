# Frozen-string-literal: true
# Copyright: 2015 - 2016 Jordon Bedwell - Apache v2.0 License
# Encoding: utf-8

require "yaml"
module Mocks
  class Jekyll
    extend Forwardable

    #

    def initialize(context)
      @context = context
      @tmpdir = Dir.mktmpdir
      @fixture_dir = Pathname.new(File.expand_path("../../fixture", __dir__))
      @dir = Pathname.new(@tmpdir)
      @frontmatter = {}

      @config = Object::Jekyll::Configuration::DEFAULTS.merge({
        "destination" => @dir.join("_site").to_s,
        "source" => @dir.to_s
      })

      setup
      make_readable
      stub
    rescue => error
      @dir.rmtree if @dir && @dir.exist?
      raise error
    end

    #

    def setup
      @dir.join("_posts").mkdir
      @dir.join("_config.yml").write("")
      @dir.join("_layouts").mkdir
      @dir.join("_plugins").mkdir
    end

    #

    def with_config(config)
      @config = Object::Jekyll::Utils.deep_merge_hashes(
        @config, config
      )

      self
    end

    #

    def site_exist?(file = "")
      return Pathname.new(@config["destination"]) \
        .join(file).exist?
    end

    #

    def exist?(file = "")
      return @dir.join(file).exist?
    end

    #

    def write(file, data)
      @dir.join(file).write(
        Object::Jekyll::Utils.strip_heredoc(data)
      )
    end

    #

    def fixture
      FileUtils.cp_r(@fixture_dir.children, @dir, {
        :dereference_root => true
      })

      self
    end

    #

    def to_site
      @site ||= Object::Jekyll::Site.new(@config)
    end

    #

    def teardown
      @dir.rmtree if @dir && @dir.exist?
    end

    #

    private
    def make_readable
      @context.instance_variable_get(:@__memoized).class.send(:attr_reader, :memoized)
      @context.class.send(:attr_reader, \
        :__memoized)
    end

    #

    private
    def stub
      @context.allow(Dir).to @context.receive(:pwd).and_return @tmpdir
    end
  end
end
