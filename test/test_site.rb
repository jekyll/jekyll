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

  def with_event_layouts(front_matter)
    files = event_layout_files(front_matter)

    files.each { |path, content| File.write(path, content) }
    clear_dest
    yield
  ensure
    FileUtils.rm_f(files&.keys)
    clear_dest
  end

  def with_event_ics_layout(front_matter)
    files = {
      source_dir("_layouts", "event.ics") => "BEGIN:VCALENDAR\n{{ content }}",
      source_dir("multiformat-event.md")  => <<~MARKDOWN,
        ---
        title: Multi-format Event
        #{front_matter}
        ---
        Event body
      MARKDOWN
    }

    files.each { |path, content| File.write(path, content) }
    clear_dest
    yield
  ensure
    FileUtils.rm_f(files&.keys)
    clear_dest
  end

  def with_event_post
    files = event_layout_files("layout: event\noutputs:\n  - ics\n")
    files.delete(source_dir("multiformat-event.md"))
    files[source_dir("_posts", "2026-05-13-multiformat-event.md")] = <<~MARKDOWN
      ---
      title: Multi-format Event
      layout: event
      outputs:
        - ics
      ---
      Event body
    MARKDOWN

    files.each { |path, content| File.write(path, content) }
    clear_dest
    yield
  ensure
    FileUtils.rm_f(files&.keys)
    clear_dest
  end

  def event_layout_files(front_matter)
    {
      source_dir("_layouts", "event.html") => <<~HTML,
        HTML EVENT LAYOUT
        {{ content }}
      HTML
      source_dir("_layouts", "event.ics")  => <<~ICS,
        BEGIN:VCALENDAR
        SUMMARY:{{ page.title }}
        {{ content }}
        END:VCALENDAR
      ICS
      source_dir("multiformat-event.md")   => <<~MARKDOWN,
        ---
        title: Multi-format Event
        #{front_matter}
        ---
        Event body
      MARKDOWN
    }
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
      array = [temp_dir("plugins")]
      assert_equal array, site.plugins
    end

    should "have an array for plugins if passed as an array" do
      site = Site.new(site_configuration(
                        "plugins_dir" => ["/tmp/plugins", "/tmp/otherplugins"]
                      ))
      array = [temp_dir("plugins"), temp_dir("otherplugins")]
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

    should "have the cache_dir hidden from Git" do
      site = fixture_site
      assert_equal site.source, source_dir
      assert_exist source_dir(".jekyll-cache", ".gitignore")
      assert_equal(
        "# ignore everything in this directory\n*\n",
        File.binread(source_dir(".jekyll-cache", ".gitignore"))
      )
    end

    should "load config file from theme-gem as Jekyll::Configuration instance" do
      site = fixture_site("theme" => "test-theme")
      assert_instance_of Jekyll::Configuration, site.config
      assert_equal "Hello World", site.config["title"]
    end

    context "with a custom cache_dir configuration" do
      should "have the custom cache_dir hidden from Git" do
        site = fixture_site("cache_dir" => "../../custom-cache-dir")
        refute_exist File.expand_path("../../custom-cache-dir/.gitignore", site.source)
        assert_exist source_dir("custom-cache-dir", ".gitignore")
        assert_equal(
          "# ignore everything in this directory\n*\n",
          File.binread(source_dir("custom-cache-dir", ".gitignore"))
        )
      end
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
      refute_path_exists(dest)

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
      # rubocop:disable Style/WordArray
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
        foo.md
        humans.txt
        index.html
        index.html
        info.md
        main.css.map
        main.scss
        properties.html
        sitemap.xml
        static_files.html
        test-styles.css.map
        test-styles.scss
        trailing-dots...md
      )
      # rubocop:enable Style/WordArray
      unless Utils::Platforms.really_windows?
        # files in symlinked directories may appear twice
        sorted_pages.push("main.css.map", "main.scss", "symlinked-file").sort!
      end
      assert_equal sorted_pages, @site.pages.map(&:name).sort!
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
      assert Utils.has_yaml_header?(abs_path)
    end

    context "with multi-format outputs" do
      should "not write an event.ics output without outputs front matter" do
        with_event_layouts("layout: event") do
          clear_dest
          FileUtils.mkdir_p(dest_dir)
          File.write(dest_dir("multiformat-event.ics"), "stale")

          @site.process

          assert_exist dest_dir("multiformat-event.html")
          refute_exist dest_dir("multiformat-event.ics")
          assert_includes File.read(dest_dir("multiformat-event.html")), "HTML EVENT LAYOUT"
          refute_includes File.read(dest_dir("multiformat-event.html")), "BEGIN:VCALENDAR"
        end
      end

      should "write all sibling layout outputs when outputs is auto" do
        front_matter = <<~YAML
          layout: event
          outputs: auto
        YAML

        with_event_layouts(front_matter) do
          File.write(source_dir("_layouts", "event.json"), "JSON EVENT\n{{ content }}")
          clear_dest
          @site.process
          page = @site.pages.find { |site_page| site_page.name == "multiformat-event.md" }

          assert_exist dest_dir("multiformat-event.html")
          assert_exist dest_dir("multiformat-event.ics")
          assert_exist dest_dir("multiformat-event.json")
          assert_includes File.read(dest_dir("multiformat-event.html")), "HTML EVENT LAYOUT"
          assert_includes File.read(dest_dir("multiformat-event.ics")), "BEGIN:VCALENDAR"
          assert_includes File.read(dest_dir("multiformat-event.json")), "JSON EVENT"
          assert_equal [
            dest_dir("multiformat-event.html"),
            dest_dir("multiformat-event.ics"),
            dest_dir("multiformat-event.json"),
          ], page.destination_paths(dest_dir)
        ensure
          FileUtils.rm_f(source_dir("_layouts", "event.json"))
        end
      end

      should "write sibling layout outputs from front matter defaults" do
        with_event_layouts("layout: event") do
          @site = Site.new(site_configuration(
                             "defaults" => [{
                               "scope"  => { "path" => "" },
                               "values" => { "outputs" => "auto" },
                             }]
                           ))
          clear_dest
          @site.process

          assert_exist dest_dir("multiformat-event.html")
          assert_exist dest_dir("multiformat-event.ics")
          assert_includes File.read(dest_dir("multiformat-event.ics")), "BEGIN:VCALENDAR"
        end
      end

      should "allow a non-html layout as the primary layout by basename" do
        with_event_ics_layout("layout: event") do
          clear_dest
          @site.process

          assert_exist dest_dir("multiformat-event.html")
          assert_includes File.read(dest_dir("multiformat-event.html")), "BEGIN:VCALENDAR"
        end
      end

      should "write html and ics outputs when ics is requested" do
        front_matter = <<~YAML
          layout: event
          outputs:
            - ics
        YAML

        with_event_layouts(front_matter) do
          clear_dest
          @site.process

          assert_exist dest_dir("multiformat-event.html")
          assert_exist dest_dir("multiformat-event.ics")
          assert_includes File.read(dest_dir("multiformat-event.html")), "HTML EVENT LAYOUT"
          assert_includes File.read(dest_dir("multiformat-event.ics")), "BEGIN:VCALENDAR"
        end
      end

      should "write a requested output when outputs is a string" do
        with_event_layouts("layout: event\noutputs: ics\n") do
          clear_dest
          @site.process

          assert_exist dest_dir("multiformat-event.html")
          assert_exist dest_dir("multiformat-event.ics")
          assert_includes File.read(dest_dir("multiformat-event.ics")), "BEGIN:VCALENDAR"
        end
      end

      should "only write requested outputs when sibling layouts include other formats" do
        front_matter = <<~YAML
          layout: event
          outputs:
            - ics
        YAML

        with_event_layouts(front_matter) do
          File.write(source_dir("_layouts", "event.json"), "{\"body\": {{ content | jsonify }}}")
          clear_dest
          @site.process

          assert_exist dest_dir("multiformat-event.html")
          assert_exist dest_dir("multiformat-event.ics")
          refute_exist dest_dir("multiformat-event.json")
        ensure
          FileUtils.rm_f(source_dir("_layouts", "event.json"))
        end
      end

      should "not write additional outputs when outputs is false" do
        front_matter = <<~YAML
          layout: event
          outputs: false
        YAML

        with_event_layouts(front_matter) do
          @site = Site.new(site_configuration(
                             "defaults" => [{
                               "scope"  => { "path" => "" },
                               "values" => { "outputs" => "auto" },
                             }]
                           ))
          clear_dest
          @site.process
          page = @site.pages.find { |site_page| site_page.name == "multiformat-event.md" }

          assert_exist dest_dir("multiformat-event.html")
          refute_exist dest_dir("multiformat-event.ics")
          assert_equal [dest_dir("multiformat-event.html")], page.destination_paths(dest_dir)
        end
      end

      should "not write additional outputs when outputs is empty" do
        front_matter = <<~YAML
          layout: event
          outputs: []
        YAML

        with_event_layouts(front_matter) do
          @site = Site.new(site_configuration(
                             "defaults" => [{
                               "scope"  => { "path" => "" },
                               "values" => { "outputs" => "auto" },
                             }]
                           ))
          clear_dest
          @site.process
          page = @site.pages.find { |site_page| site_page.name == "multiformat-event.md" }

          assert_exist dest_dir("multiformat-event.html")
          refute_exist dest_dir("multiformat-event.ics")
          assert_equal [dest_dir("multiformat-event.html")], page.destination_paths(dest_dir)
        end
      end

      should "not warn about html sibling layouts when auto output matches primary extension" do
        front_matter = <<~YAML
          layout: event
          permalink: /calendar.ics
          outputs: auto
        YAML

        with_event_layouts(front_matter) do
          clear_dest
          output = capture_stderr { @site.process }
          page = @site.pages.find { |site_page| site_page.name == "multiformat-event.md" }

          assert_exist dest_dir("calendar.ics")
          refute_exist dest_dir("calendar.html")
          refute_includes output, "Layout 'event.html' requested"
          assert_equal [dest_dir("calendar.ics")], page.destination_paths(dest_dir)
        end
      end

      should "not expose secondary layout state to the next page" do
        files = {
          source_dir("_layouts", "first.html") => <<~HTML,
            ---
            format: html
            ---
            FIRST HTML
            {{ content }}
          HTML
          source_dir("_layouts", "first.ics")  => <<~ICS,
            ---
            format: ics
            ---
            FIRST ICS
            {{ content }}
          ICS
          source_dir("_layouts", "plain.html") => "PLAIN\n{{ content }}",
          source_dir("aaa-first.md")           => <<~MARKDOWN,
            ---
            title: First
            layout: first
            outputs:
              - ics
            ---
            First body
          MARKDOWN
          source_dir("zzz-second.md")          => <<~MARKDOWN,
            ---
            title: Second
            layout: plain
            ---
            Layout format: {{ layout.format }}
            Leaked content: {{ content }}
          MARKDOWN
        }

        files.each { |path, content| File.write(path, content) }
        clear_dest
        @site.process
        second_output = File.read(dest_dir("zzz-second.html"))

        refute_includes second_output, "ics"
        refute_includes second_output, "FIRST ICS"
      ensure
        FileUtils.rm_f(files&.keys)
        clear_dest
      end

      should "apply post render hooks to additional outputs" do
        hook = proc do |document|
          next unless document.data["title"] == "Multi-format Event"

          document.output = "#{document.output}\nHOOKED"
        end
        Jekyll::Hooks.register :pages, :post_render, &hook

        front_matter = <<~YAML
          layout: event
          outputs:
            - ics
        YAML

        with_event_layouts(front_matter) do
          clear_dest
          @site.process

          assert_includes File.read(dest_dir("multiformat-event.html")), "HOOKED"
          assert_includes File.read(dest_dir("multiformat-event.ics")), "HOOKED"
        end
      ensure
        registry = Jekyll::Hooks.instance_variable_get(:@registry)
        priority = Jekyll::Hooks.instance_variable_get(:@hook_priority)
        registry[:pages][:post_render].delete(hook)
        priority.delete(hook)
      end

      should "prefer matching parent layouts for a non-html primary layout" do
        files = {
          source_dir("_layouts", "base.html") => "HTML BASE\n{{ content }}",
          source_dir("_layouts", "base.ics")  => "ICS BASE\n{{ content }}",
          source_dir("_layouts", "event.ics") => <<~ICS,
            ---
            layout: base
            ---
            ICS EVENT
            {{ content }}
          ICS
          source_dir("multiformat-event.md")  => <<~MARKDOWN,
            ---
            title: Multi-format Event
            layout: event
            ---
            Event body
          MARKDOWN
        }

        files.each { |path, content| File.write(path, content) }
        clear_dest
        @site.process

        assert_includes File.read(dest_dir("multiformat-event.html")), "ICS BASE"
        refute_includes File.read(dest_dir("multiformat-event.html")), "HTML BASE"
      ensure
        FileUtils.rm_f(files&.keys)
        clear_dest
      end

      should "not advertise additional output paths for pages without layouts" do
        front_matter = <<~YAML
          layout: none
          outputs: auto
        YAML

        with_event_layouts(front_matter) do
          clear_dest
          @site.process
          page = @site.pages.find { |site_page| site_page.name == "multiformat-event.md" }

          assert_exist dest_dir("multiformat-event.html")
          refute_exist dest_dir("multiformat-event.ics")
          assert_equal [dest_dir("multiformat-event.html")], page.destination_paths(dest_dir)
        end
      end

      should "render the original issue example with sibling layout formats" do
        files = {
          source_dir("_layouts", "post.html")            => "HTML POST\n{{ content }}",
          source_dir("_layouts", "post.ical")            => "ICAL POST\n{{ content }}",
          source_dir("_posts", "2026-05-13-calendar.md") => <<~MARKDOWN,
            ---
            title: Calendar Event
            layout: post
            outputs: auto
            ---
            Event body
          MARKDOWN
        }

        files.each { |path, content| File.write(path, content) }
        clear_dest
        @site.process
        post = @site.posts.docs.find { |site_post| site_post.data["title"] == "Calendar Event" }

        assert_exist post.destination(dest_dir)
        assert_exist post.destination(dest_dir, ".ical")
        assert_includes File.read(post.destination(dest_dir)), "HTML POST"
        assert_includes File.read(post.destination(dest_dir, ".ical")), "ICAL POST"
      ensure
        FileUtils.rm_f(files&.keys)
        clear_dest
      end

      should "prefer matching parent layouts for requested outputs" do
        files = {
          source_dir("_layouts", "base.html")  => "HTML BASE\n{{ content }}",
          source_dir("_layouts", "base.ics")   => "ICS BASE\n{{ content }}",
          source_dir("_layouts", "event.html") => <<~HTML,
            ---
            layout: base
            ---
            HTML EVENT
            {{ content }}
          HTML
          source_dir("_layouts", "event.ics")  => <<~ICS,
            ---
            layout: base
            ---
            ICS EVENT
            {{ content }}
          ICS
          source_dir("multiformat-event.md")   => <<~MARKDOWN,
            ---
            title: Multi-format Event
            layout: event
            outputs:
              - ics
            ---
            Event body
          MARKDOWN
        }

        files.each { |path, content| File.write(path, content) }
        clear_dest
        @site.process

        assert_includes File.read(dest_dir("multiformat-event.html")), "HTML BASE"
        assert_includes File.read(dest_dir("multiformat-event.ics")), "ICS BASE"
        refute_includes File.read(dest_dir("multiformat-event.ics")), "HTML BASE"
      ensure
        FileUtils.rm_f(files&.keys)
        clear_dest
      end

      should "write requested outputs for posts" do
        with_event_post do
          clear_dest
          @site.process
          post = @site.posts.docs.find do |site_post|
            site_post.data["title"] == "Multi-format Event"
          end

          post.destination_paths(dest_dir).each { |path| assert_exist path }
          assert_includes File.read(post.destination(dest_dir)), "HTML EVENT LAYOUT"
          assert_includes File.read(post.destination(dest_dir, ".ics")), "BEGIN:VCALENDAR"
        end
      end

      should "write pretty permalink outputs with the requested extension" do
        front_matter = <<~YAML
          layout: event
          permalink: /calendar/event/
          outputs:
            - ics
        YAML

        with_event_layouts(front_matter) do
          clear_dest
          @site.process

          assert_exist dest_dir("calendar", "event", "index.html")
          assert_exist dest_dir("calendar", "event", "index.ics")
          assert_includes File.read(dest_dir("calendar", "event", "index.ics")),
                          "BEGIN:VCALENDAR"
        end
      end

      should "rewrite a missing requested output during incremental builds" do
        front_matter = <<~YAML
          layout: event
          outputs:
            - ics
        YAML

        with_event_layouts(front_matter) do
          @site = Site.new(site_configuration("incremental" => true))
          @site.process
          FileUtils.rm_f(dest_dir("multiformat-event.ics"))

          @site.process

          assert_exist dest_dir("multiformat-event.ics")
          assert_includes File.read(dest_dir("multiformat-event.ics")), "BEGIN:VCALENDAR"
        end
      end

      should "warn when a requested output conflicts with another file" do
        front_matter = <<~YAML
          layout: event
          outputs:
            - ics
        YAML

        with_event_layouts(front_matter) do
          conflict = source_dir("multiformat-event.ics")
          File.write(conflict, "static calendar")
          output = capture_stderr { @site.process }

          assert_includes output, "Conflict:"
          assert_includes output, dest_dir("multiformat-event.ics")
        ensure
          FileUtils.rm_f(conflict)
        end
      end

      should "ignore output names that are not extension names" do
        front_matter = <<~YAML
          layout: event
          outputs:
            - ../ics
            - json feed
        YAML

        with_event_layouts(front_matter) do
          clear_dest
          @site.process

          assert_exist dest_dir("multiformat-event.html")
          refute_exist dest_dir("multiformat-event.ics")
        end
      end

      should "ignore output names that match the primary extension" do
        front_matter = <<~YAML
          layout: event
          permalink: /calendar.ics
          outputs:
            - ics
        YAML

        with_event_layouts(front_matter) do
          clear_dest
          @site.process
          page = @site.pages.find { |site_page| site_page.name == "multiformat-event.md" }

          assert_equal [dest_dir("calendar.ics")], page.destination_paths(dest_dir)
          assert_includes File.read(dest_dir("calendar.ics")), "HTML EVENT LAYOUT"
          refute_includes File.read(dest_dir("calendar.ics")), "BEGIN:VCALENDAR"
        end
      end
    end

    should "enforce a strict 3-dash limit on the start of the YAML front matter" do
      abs_path = File.expand_path("pgp.key", @site.source)
      refute Utils.has_yaml_header?(abs_path)
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
        expected_msg = "Theme: value of 'theme' in config should be String to use " \
                       "gem-based themes, but got Hash\n"
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

  context "site process phases" do
    should "return nil as documented" do
      site = fixture_site
      [:reset, :read, :generate, :render, :cleanup, :write].each do |phase|
        assert_nil site.send(phase)
      end
    end
  end

  context "static files in a collection" do
    should "be exposed via site instance" do
      site = fixture_site("collections" => ["methods"])
      site.read

      assert_includes site.static_files.map(&:relative_path), "_methods/extensionless_static_file"
    end

    should "not be revisited in `Site#each_site_file`" do
      site = fixture_site("collections" => { "methods" => { "output" => true } })
      site.read

      visited_files = []
      site.each_site_file { |file| visited_files << file }
      assert_equal visited_files.count, visited_files.uniq.count
    end
  end
end
