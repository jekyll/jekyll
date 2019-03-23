# frozen_string_literal: true

require "helper"

class TestSite < JekyllUnitTest
  def with_image_as_post
    tmp_image_path = File.join(source_dir, "_posts", "2017-09-01-jekyll-sticker.jpg")
    FileUtils.cp File.join(Dir.pwd, "docs", "img", "jekyll-sticker.jpg"), tmp_image_path
    yield
  ensure
    FileUtils.rm tmp_image_path
  end

  def read_posts
    @site.posts.docs.concat(PostReader.new(@site).read_posts(""))
    posts = Dir[source_dir("_posts", "**", "*")]
    posts.delete_if do |post|
      File.directory?(post) && post !~ Document::DATE_FILENAME_MATCHER
    end
  end

  context "configuring sites" do
    should "have an array for plugins by default" do
      site = Site.new default_configuration
      assert_equal [File.join(Dir.pwd, "_plugins")], site.plugins
    end

    should "look for plugins under the site directory by default" do
      site = Site.new(site_configuration)
      assert_equal [source_dir("_plugins")], site.plugins
    end

    should "have an array for plugins if passed as a string" do
      site = Site.new(site_configuration("plugins_dir" => "/tmp/plugins"))
      array = Utils::Platforms.windows? ? ["C:/tmp/plugins"] : ["/tmp/plugins"]
      assert_equal array, site.plugins
    end

    should "have an array for plugins if passed as an array" do
      site = Site.new(site_configuration(
                        "plugins_dir" => ["/tmp/plugins", "/tmp/otherplugins"]
                      ))
      array = if Utils::Platforms.windows?
                ["C:/tmp/plugins", "C:/tmp/otherplugins"]
              else
                ["/tmp/plugins", "/tmp/otherplugins"]
              end
      assert_equal array, site.plugins
    end

    should "have an empty array for plugins if nothing is passed" do
      site = Site.new(site_configuration("plugins_dir" => []))
      assert_equal [], site.plugins
    end

    should "have the default for plugins if nil is passed" do
      site = Site.new(site_configuration("plugins_dir" => nil))
      assert_equal [source_dir("_plugins")], site.plugins
    end

    should "default baseurl to `nil`" do
      site = Site.new(default_configuration)
      assert_nil site.baseurl
    end

    should "expose baseurl passed in from config" do
      site = Site.new(site_configuration("baseurl" => "/blog"))
      assert_equal "/blog", site.baseurl
    end

    should "only include theme includes_path if the path exists" do
      site = fixture_site("theme" => "test-theme")
      assert_equal [source_dir("_includes"), theme_dir("_includes")],
                   site.includes_load_paths

      allow(File).to receive(:directory?).with(theme_dir("_sass")).and_return(true)
      allow(File).to receive(:directory?).with(theme_dir("_layouts")).and_return(true)
      allow(File).to receive(:directory?).with(theme_dir("_includes")).and_return(false)
      site = fixture_site("theme" => "test-theme")
      assert_equal [source_dir("_includes")], site.includes_load_paths
    end

    should "configure cache_dir" do
      fixture_site.process
      assert File.directory?(source_dir(".jekyll-cache", "Jekyll", "Cache"))
      assert File.directory?(source_dir(".jekyll-cache", "Jekyll", "Cache", "Jekyll--Cache"))
    end

    should "use .jekyll-cache directory at source as cache_dir by default" do
      site = Site.new(default_configuration)
      assert_equal File.join(site.source, ".jekyll-cache"), site.cache_dir
    end
  end

  context "creating sites" do
    setup do
      @site = Site.new(site_configuration)
      @num_invalid_posts = 6
    end

    teardown do
      self.class.send(:remove_const, :MyGenerator) if defined?(MyGenerator)
    end

    should "have an empty tag hash by default" do
      assert_equal({}, @site.tags)
    end

    should "give site with parsed pages and posts to generators" do
      class MyGenerator < Generator
        def generate(site)
          site.pages.dup.each do |page|
            raise "#{page} isn't a page" unless page.is_a?(Page)
            raise "#{page} doesn't respond to :name" unless page.respond_to?(:name)
          end
          site.file_read_opts[:secret_message] = "hi"
        end
      end
      @site = Site.new(site_configuration)
      @site.read
      @site.generate
      refute_equal 0, @site.pages.size
      assert_equal "hi", @site.file_read_opts[:secret_message]
    end

    should "reset data before processing" do
      clear_dest
      @site.process
      before_posts = @site.posts.length
      before_layouts = @site.layouts.length
      before_categories = @site.categories.length
      before_tags = @site.tags.length
      before_pages = @site.pages.length
      before_static_files = @site.static_files.length
      before_time = @site.time

      @site.process
      assert_equal before_posts, @site.posts.length
      assert_equal before_layouts, @site.layouts.length
      assert_equal before_categories, @site.categories.length
      assert_equal before_tags, @site.tags.length
      assert_equal before_pages, @site.pages.length
      assert_equal before_static_files, @site.static_files.length
      assert before_time <= @site.time
    end

    should "write only modified static files" do
      clear_dest
      StaticFile.reset_cache
      @site.regenerator.clear

      @site.process
      some_static_file = @site.static_files[0].path
      dest = File.expand_path(@site.static_files[0].destination(@site.dest))
      mtime1 = File.stat(dest).mtime.to_i # first run must generate dest file

      # need to sleep because filesystem timestamps have best resolution in seconds
      sleep 1
      @site.process
      mtime2 = File.stat(dest).mtime.to_i
      assert_equal mtime1, mtime2

      # simulate file modification by user
      FileUtils.touch some_static_file

      sleep 1
      @site.process
      mtime3 = File.stat(dest).mtime.to_i
      refute_equal mtime2, mtime3 # must be regenerated!

      sleep 1
      @site.process
      mtime4 = File.stat(dest).mtime.to_i
      assert_equal mtime3, mtime4 # no modifications, so must be the same
    end

    should "write static files if not modified but missing in destination" do
      clear_dest
      StaticFile.reset_cache
      @site.regenerator.clear

      @site.process
      dest = File.expand_path(@site.static_files[0].destination(@site.dest))
      mtime1 = File.stat(dest).mtime.to_i # first run must generate dest file

      # need to sleep because filesystem timestamps have best resolution in seconds
      sleep 1
      @site.process
      mtime2 = File.stat(dest).mtime.to_i
      assert_equal mtime1, mtime2

      # simulate destination file deletion
      File.unlink dest
      refute File.exist?(dest)

      sleep 1
      @site.process
      mtime3 = File.stat(dest).mtime.to_i
      assert_equal mtime2, mtime3 # must be regenerated and with original mtime!

      sleep 1
      @site.process
      mtime4 = File.stat(dest).mtime.to_i
      assert_equal mtime3, mtime4 # no modifications, so remain the same
    end

    should "setup plugins in priority order" do
      assert_equal(
        @site.converters.sort_by(&:class).map { |c| c.class.priority },
        @site.converters.map { |c| c.class.priority }
      )
      assert_equal(
        @site.generators.sort_by(&:class).map { |g| g.class.priority },
        @site.generators.map { |g| g.class.priority }
      )
    end

    should "sort pages alphabetically" do
      method = Dir.method(:entries)
      allow(Dir).to receive(:entries) do |*args, &block|
        method.call(*args, &block).reverse
      end
      @site.process
      # exclude files in symlinked directories here and insert them in the
      # following step when not on Windows.
      sorted_pages = %w(
        %#\ +.md
        .htaccess
        about.html
        application.coffee
        bar.html
        coffeescript.coffee
        contacts.html
        deal.with.dots.html
        dynamic_file.php
        environment.html
        exploit.md
        foo.md
        humans.txt
        index.html
        index.html
        info.md
        main.scss
        properties.html
        sitemap.xml
        static_files.html
        trailing-dots...md
      )
      unless Utils::Platforms.really_windows?
        # files in symlinked directories may appear twice
        sorted_pages.push("main.scss", "symlinked-file").sort!
      end
      assert_equal sorted_pages, @site.pages.map(&:name)
    end

    should "read posts" do
      posts = read_posts
      assert_equal posts.size - @num_invalid_posts, @site.posts.size
    end

    should "skip posts with invalid encoding" do
      with_image_as_post do
        posts = read_posts
        num_invalid_posts = @num_invalid_posts + 1
        assert_equal posts.size - num_invalid_posts, @site.posts.size
      end
    end

    should "read pages with YAML front matter" do
      abs_path = File.expand_path("about.html", @site.source)
      assert_equal true, Utils.has_yaml_header?(abs_path)
    end

    should "enforce a strict 3-dash limit on the start of the YAML front matter" do
      abs_path = File.expand_path("pgp.key", @site.source)
      assert_equal false, Utils.has_yaml_header?(abs_path)
    end

    should "expose jekyll version to site payload" do
      assert_equal Jekyll::VERSION, @site.site_payload["jekyll"]["version"]
    end

    should "expose list of static files to site payload" do
      assert_equal @site.static_files, @site.site_payload["site"]["static_files"]
    end

    should "deploy payload" do
      clear_dest
      @site.process

      posts = Dir[source_dir("**", "_posts", "**", "*")]
      posts.delete_if do |post|
        File.directory?(post) && post !~ Document::DATE_FILENAME_MATCHER
      end
      categories = %w(
        2013 bar baz category foo z_category MixedCase Mixedcase publish_test win
      ).sort

      assert_equal posts.size - @num_invalid_posts, @site.posts.size
      assert_equal categories, @site.categories.keys.sort
      assert_equal 5, @site.categories["foo"].size
    end

    context "error handling" do
      should "raise if destination is included in source" do
        assert_raises Jekyll::Errors::FatalException do
          Site.new(site_configuration("destination" => source_dir))
        end
      end

      should "raise if destination is source" do
        assert_raises Jekyll::Errors::FatalException do
          Site.new(site_configuration("destination" => File.join(source_dir, "..")))
        end
      end

      should "raise for bad frontmatter if strict_front_matter is set" do
        site = Site.new(site_configuration(
                          "collections"         => ["broken"],
                          "strict_front_matter" => true
                        ))
        assert_raises(Psych::SyntaxError) do
          site.process
        end
      end

      should "not raise for bad frontmatter if strict_front_matter is not set" do
        site = Site.new(site_configuration(
                          "collections"         => ["broken"],
                          "strict_front_matter" => false
                        ))
        site.process
      end
    end

    context "with orphaned files in destination" do
      setup do
        clear_dest
        @site.regenerator.clear
        @site.process
        # generate some orphaned files:
        # single file
        FileUtils.touch(dest_dir("obsolete.html"))
        # single file in sub directory
        FileUtils.mkdir(dest_dir("qux"))
        FileUtils.touch(dest_dir("qux/obsolete.html"))
        # empty directory
        FileUtils.mkdir(dest_dir("quux"))
        FileUtils.mkdir(dest_dir(".git"))
        FileUtils.mkdir(dest_dir(".svn"))
        FileUtils.mkdir(dest_dir(".hg"))
        # single file in repository
        FileUtils.touch(dest_dir(".git/HEAD"))
        FileUtils.touch(dest_dir(".svn/HEAD"))
        FileUtils.touch(dest_dir(".hg/HEAD"))
      end

      teardown do
        FileUtils.rm_f(dest_dir("obsolete.html"))
        FileUtils.rm_rf(dest_dir("qux"))
        FileUtils.rm_f(dest_dir("quux"))
        FileUtils.rm_rf(dest_dir(".git"))
        FileUtils.rm_rf(dest_dir(".svn"))
        FileUtils.rm_rf(dest_dir(".hg"))
      end

      should "remove orphaned files in destination" do
        @site.process
        refute_exist dest_dir("obsolete.html")
        refute_exist dest_dir("qux")
        refute_exist dest_dir("quux")
        assert_exist dest_dir(".git")
        assert_exist dest_dir(".git", "HEAD")
      end

      should "remove orphaned files in destination - keep_files .svn" do
        config = site_configuration("keep_files" => %w(.svn))
        @site = Site.new(config)
        @site.process
        refute_exist dest_dir(".htpasswd")
        refute_exist dest_dir("obsolete.html")
        refute_exist dest_dir("qux")
        refute_exist dest_dir("quux")
        refute_exist dest_dir(".git")
        refute_exist dest_dir(".git", "HEAD")
        assert_exist dest_dir(".svn")
        assert_exist dest_dir(".svn", "HEAD")
      end
    end

    context "using a non-default markdown processor in the configuration" do
      should "use the non-default markdown processor" do
        class Jekyll::Converters::Markdown::CustomMarkdown
          def initialize(*args)
            @args = args
          end

          def convert(*_args)
            ""
          end
        end

        custom_processor = "CustomMarkdown"
        s = Site.new(site_configuration("markdown" => custom_processor))
        s.process

        # Do some cleanup, we don't like straggling stuff.
        Jekyll::Converters::Markdown.send(:remove_const, :CustomMarkdown)
      end

      should "ignore, if there are any bad characters in the class name" do
        module Jekyll::Converters::Markdown::Custom
          class Markdown
            def initialize(*args)
              @args = args
            end

            def convert(*_args)
              ""
            end
          end
        end

        bad_processor = "Custom::Markdown"
        s = Site.new(site_configuration(
                       "markdown"    => bad_processor,
                       "incremental" => false
                     ))
        assert_raises Jekyll::Errors::FatalException do
          s.process
        end

        # Do some cleanup, we don't like straggling stuff.
        Jekyll::Converters::Markdown.send(:remove_const, :Custom)
      end
    end

    context "with an invalid markdown processor in the configuration" do
      should "not throw an error at initialization time" do
        bad_processor = "not a processor name"
        assert Site.new(site_configuration("markdown" => bad_processor))
      end

      should "throw FatalException at process time" do
        bad_processor = "not a processor name"
        s = Site.new(site_configuration(
                       "markdown"    => bad_processor,
                       "incremental" => false
                     ))
        assert_raises Jekyll::Errors::FatalException do
          s.process
        end
      end
    end

    context "data directory" do
      should "auto load yaml files" do
        site = Site.new(site_configuration)
        site.process

        file_content = SafeYAML.load_file(File.join(source_dir, "_data", "members.yaml"))

        assert_equal site.data["members"], file_content
        assert_equal site.site_payload["site"]["data"]["members"], file_content
      end

      should "load yaml files from extracted method" do
        site = Site.new(site_configuration)
        site.process

        file_content = DataReader.new(site)
          .read_data_file(source_dir("_data", "members.yaml"))

        assert_equal site.data["members"], file_content
        assert_equal site.site_payload["site"]["data"]["members"], file_content
      end

      should "auto load yml files" do
        site = Site.new(site_configuration)
        site.process

        file_content = SafeYAML.load_file(File.join(source_dir, "_data", "languages.yml"))

        assert_equal site.data["languages"], file_content
        assert_equal site.site_payload["site"]["data"]["languages"], file_content
      end

      should "auto load json files" do
        site = Site.new(site_configuration)
        site.process

        file_content = SafeYAML.load_file(File.join(source_dir, "_data", "members.json"))

        assert_equal site.data["members"], file_content
        assert_equal site.site_payload["site"]["data"]["members"], file_content
      end

      should "auto load yaml files in subdirectory" do
        site = Site.new(site_configuration)
        site.process

        file_content = SafeYAML.load_file(File.join(
                                            source_dir, "_data", "categories", "dairy.yaml"
                                          ))

        assert_equal site.data["categories"]["dairy"], file_content
        assert_equal(
          site.site_payload["site"]["data"]["categories"]["dairy"],
          file_content
        )
      end

      should "auto load yaml files in subdirectory with a period in the name" do
        site = Site.new(site_configuration)
        site.process

        file_content = SafeYAML.load_file(File.join(
                                            source_dir, "_data", "categories.01", "dairy.yaml"
                                          ))

        assert_equal site.data["categories01"]["dairy"], file_content
        assert_equal(
          site.site_payload["site"]["data"]["categories01"]["dairy"],
          file_content
        )
      end

      should "load symlink files in unsafe mode" do
        site = Site.new(site_configuration("safe" => false))
        site.process

        file_content = SafeYAML.load_file(File.join(source_dir, "_data", "products.yml"))

        assert_equal site.data["products"], file_content
        assert_equal site.site_payload["site"]["data"]["products"], file_content
      end

      should "load the symlink files in safe mode, " \
             "as they resolve to inside site.source" do
        site = Site.new(site_configuration("safe" => true))
        site.process
        file_content = SafeYAML.load_file(File.join(source_dir, "_data", "products.yml"))
        assert_equal site.data["products"], file_content
        assert_equal site.site_payload["site"]["data"]["products"], file_content
      end
    end

    context "manipulating the Jekyll environment" do
      setup do
        @site = Site.new(site_configuration(
                           "incremental" => false
                         ))
        @site.process
        @page = @site.pages.find { |p| p.name == "environment.html" }
      end

      should "default to 'development'" do
        assert_equal "development", @page.content.strip
      end

      context "in production" do
        setup do
          ENV["JEKYLL_ENV"] = "production"
          @site = Site.new(site_configuration(
                             "incremental" => false
                           ))
          @site.process
          @page = @site.pages.find { |p| p.name == "environment.html" }
        end

        teardown do
          ENV.delete("JEKYLL_ENV")
        end

        should "be overridden by JEKYLL_ENV" do
          assert_equal "production", @page.content.strip
        end
      end
    end

    context "when setting theme" do
      should "set no theme if config is not set" do
        expect($stderr).not_to receive(:puts)
        expect($stdout).not_to receive(:puts)
        site = fixture_site("theme" => nil)
        assert_nil site.theme
      end

      should "set no theme if config is a hash" do
        output = capture_output do
          site = fixture_site("theme" => {})
          assert_nil site.theme
        end
        expected_msg = "Theme: value of 'theme' in config should be String " \
          "to use gem-based themes, but got Hash\n"
        assert_includes output, expected_msg
      end

      should "set a theme if the config is a string" do
        [:debug, :info, :warn, :error].each do |level|
          if level == :info
            expect(Jekyll.logger.writer).to receive(level)
          else
            expect(Jekyll.logger.writer).not_to receive(level)
          end
        end
        site = fixture_site("theme" => "test-theme")
        assert_instance_of Jekyll::Theme, site.theme
        assert_equal "test-theme", site.theme.name
      end
    end

    context "with liquid profiling" do
      setup do
        @site = Site.new(site_configuration("profile" => true))
      end

      # Suppress output while testing
      setup do
        $stdout = StringIO.new
      end
      teardown do
        $stdout = STDOUT
      end

      should "print profile table" do
        expect(@site.liquid_renderer).to receive(:stats_table)
        @site.process
      end
    end

    context "incremental build" do
      setup do
        @site = Site.new(site_configuration(
                           "incremental" => true
                         ))
        @site.read
      end

      should "build incrementally" do
        contacts_html = @site.pages.find { |p| p.name == "contacts.html" }
        @site.process

        source = @site.in_source_dir(contacts_html.path)
        dest = File.expand_path(contacts_html.destination(@site.dest))
        mtime1 = File.stat(dest).mtime.to_i # first run must generate dest file

        # need to sleep because filesystem timestamps have best resolution in seconds
        sleep 1
        @site.process
        mtime2 = File.stat(dest).mtime.to_i
        assert_equal mtime1, mtime2 # no modifications, so remain the same

        # simulate file modification by user
        FileUtils.touch source

        sleep 1
        @site.process
        mtime3 = File.stat(dest).mtime.to_i
        refute_equal mtime2, mtime3 # must be regenerated

        sleep 1
        @site.process
        mtime4 = File.stat(dest).mtime.to_i
        assert_equal mtime3, mtime4 # no modifications, so remain the same
      end

      should "regenerate files that have had their destination deleted" do
        contacts_html = @site.pages.find { |p| p.name == "contacts.html" }
        @site.process

        dest = File.expand_path(contacts_html.destination(@site.dest))
        mtime1 = File.stat(dest).mtime.to_i # first run must generate dest file

        # simulate file modification by user
        File.unlink dest
        refute File.file?(dest)

        sleep 1 # sleep for 1 second, since mtimes have 1s resolution
        @site.process
        assert File.file?(dest)
        mtime2 = File.stat(dest).mtime.to_i
        refute_equal mtime1, mtime2 # must be regenerated
      end
    end

    context "#in_cache_dir method" do
      setup do
        @site = Site.new(
          site_configuration(
            "cache_dir" => "../../custom-cache-dir"
          )
        )
      end

      should "create sanitized paths within the cache directory" do
        assert_equal File.join(@site.source, "custom-cache-dir"), @site.cache_dir
        assert_equal(
          File.join(@site.source, "custom-cache-dir", "foo.md.metadata"),
          @site.in_cache_dir("../../foo.md.metadata")
        )
      end
    end
  end
end
