# encoding: utf-8

require 'helper'

class TestPost < Test::Unit::TestCase
  def setup_post(file)
    Post.new(@site, source_dir, '', file)
  end

  def do_render(post)
    layouts = { "default" => Layout.new(@site, source_dir('_layouts'), "simple.html")}
    post.render(layouts, {"site" => {"posts" => []}})
  end

  context "A Post" do
    setup do
      clear_dest
      @site = fixture_site
    end

    should "ensure valid posts are valid" do
      assert Post.valid?("2008-09-09-foo-bar.textile")
      assert Post.valid?("foo/bar/2008-09-09-foo-bar.textile")
      assert Post.valid?("2008-09-09-foo-bar.markdown")
      assert Post.valid?("foo/bar/2008-09-09-foo-bar.markdown")

      assert !Post.valid?("lol2008-09-09-foo-bar.textile")
      assert !Post.valid?("lol2008-09-09-foo-bar.markdown")
      assert !Post.valid?("blah")
    end

    should "make properties accessible through #[]" do
      post = setup_post('2013-12-20-properties.text')

      attrs = {
        categories: %w(foo bar baz MixedCase),
        content: "All the properties.\n\nPlus an excerpt.\n",
        date: Time.new(2013, 12, 20),
        dir: "/foo/bar/baz/mixedcase/2013/12/20",
        excerpt: "All the properties.\n\n",
        foo: 'bar',
        id: "/foo/bar/baz/mixedcase/2013/12/20/properties",
        layout: 'default',
        name: nil,
        path: "_posts/2013-12-20-properties.text",
        permalink: nil,
        published: nil,
        tags: %w(ay bee cee),
        title: 'Properties Post',
        url: "/foo/bar/baz/mixedcase/2013/12/20/properties.html"
      }

      attrs.each do |attr, val|
        attr_str = attr.to_s
        result = post[attr_str]
        assert_equal val, result, "For <post[\"#{attr_str}\"]>:"
      end
    end

    context "processing posts" do
      setup do
        @post = Post.allocate
        @post.site = @site

        @real_file = "2008-10-18-foo-bar.markdown"
        @fake_file = "2008-09-09-foo-bar.markdown"
        @source = source_dir('_posts')
      end

      should "keep date, title, and markup type" do
        @post.categories = []
        @post.process(@fake_file)

        assert_equal Time.parse("2008-09-09"), @post.date
        assert_equal "foo-bar", @post.slug
        assert_equal ".markdown", @post.ext
        assert_equal "/2008/09/09", @post.dir
        assert_equal "/2008/09/09/foo-bar", @post.id
      end

      should "ignore subfolders" do
        post = Post.allocate
        post.categories = ['foo']
        post.site = @site
        post.process("cat1/2008-09-09-foo-bar.textile")
        assert_equal 1, post.categories.size
        assert_equal "foo", post.categories[0]

        post = Post.allocate
        post.categories = ['foo', 'bar']
        post.site = @site
        post.process("cat2/CAT3/2008-09-09-foo-bar.textile")
        assert_equal 2, post.categories.size
        assert_equal "foo", post.categories[0]
        assert_equal "bar", post.categories[1]

      end

      should "create url based on date and title" do
        @post.categories = []
        @post.process(@fake_file)
        assert_equal "/2008/09/09/foo-bar.html", @post.url
      end

      should "raise a good error on invalid post date" do
        assert_raise Jekyll::Errors::FatalException do
          @post.process("2009-27-03-foo-bar.textile")
        end
      end

      should "escape urls" do
        @post.categories = []
        @post.process("2009-03-12-hash-#1.markdown")
        assert_equal "/2009/03/12/hash-%231.html", @post.url
        assert_equal "/2009/03/12/hash-#1", @post.id
      end

      should "escape urls with non-alphabetic characters" do
        @post.categories = []
        @post.process("2014-03-22-escape-+ %20[].markdown")
        assert_equal "/2014/03/22/escape-+%20%2520%5B%5D.html", @post.url
        assert_equal "/2014/03/22/escape-+ %20[]", @post.id
      end

      should "return a UTF-8 escaped string" do
        assert_equal Encoding::UTF_8, URL.escape_path("/rails笔记/2014/04/20/escaped/").encoding
      end

      should "return a UTF-8 unescaped string" do
        assert_equal Encoding::UTF_8, URL.unescape_path("/rails%E7%AC%94%E8%AE%B0/2014/04/20/escaped/".encode(Encoding::ASCII)).encoding
      end

      should "respect permalink in yaml front matter" do
        file = "2008-12-03-permalinked-post.textile"
        @post.process(file)
        @post.read_yaml(@source, file)

        assert_equal "my_category/permalinked-post", @post.permalink
        assert_equal "/my_category", @post.dir
        assert_equal "/my_category/permalinked-post", @post.url
      end

      should "not be writable outside of destination" do
        unexpected = File.expand_path("../../../baddie.html", dest_dir)
        File.delete unexpected if File.exist?(unexpected)
        post = setup_post("2014-01-06-permalink-traversal.md")
        do_render(post)
        post.write(dest_dir)

        assert !File.exist?(unexpected), "../../../baddie.html should not exist."
        assert File.exist?(File.expand_path("baddie.html", dest_dir))
      end

      context "with CRLF linebreaks" do
        setup do
          @real_file = "2009-05-24-yaml-linebreak.markdown"
          @source = source_dir('win/_posts')
        end
        should "read yaml front-matter" do
          @post.read_yaml(@source, @real_file)

          assert_equal({"title" => "Test title", "layout" => "post", "tag" => "Ruby"}, @post.data)
          assert_equal "This is the content", @post.content
        end
      end

      context "with three dots ending YAML header" do
        setup do
          @real_file = "2014-03-03-yaml-with-dots.md"
        end
        should "should read the YAML header" do
          @post.read_yaml(@source, @real_file)

          assert_equal({"title" => "Test Post Where YAML Ends in Dots"},
                       @post.data)
        end
      end

      context "with embedded triple dash" do
        setup do
          @real_file = "2010-01-08-triple-dash.markdown"
        end
        should "consume the embedded dashes" do
          @post.read_yaml(@source, @real_file)

          assert_equal({"title" => "Foo --- Bar"}, @post.data)
          assert_equal "Triple the fun!", @post.content
        end
      end

      context "with site wide permalink" do
        setup do
          @post.categories = []
        end

        context "with unspecified (date) style" do
          setup do
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:year/:month/:day/:title.html", @post.template
            assert_equal "/2008/09/09/foo-bar.html", @post.url
          end
        end

        context "with unspecified (date) style and a category" do
          setup do
            @post.categories << "beer"
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:year/:month/:day/:title.html", @post.template
            assert_equal "/beer/2008/09/09/foo-bar.html", @post.url
          end
        end

        context "with unspecified (date) style and a numeric category" do
          setup do
            @post.categories << 2013
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:year/:month/:day/:title.html", @post.template
            assert_equal "/2013/2008/09/09/foo-bar.html", @post.url
          end
        end

        context "with specified layout of nil" do
          setup do
            file = '2013-01-12-nil-layout.textile'
            @post = setup_post(file)
            @post.process(file)
          end

          should "layout of nil is respected" do
            assert_equal "nil", @post.data["layout"]
          end
        end

        context "with unspecified (date) style and categories" do
          setup do
            @post.categories << "food"
            @post.categories << "beer"
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:year/:month/:day/:title.html", @post.template
            assert_equal "/food/beer/2008/09/09/foo-bar.html", @post.url
          end
        end

        context "with space (categories)" do
          setup do
            @post.categories << "french cuisine"
            @post.categories << "belgian beer"
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:year/:month/:day/:title.html", @post.template
            assert_equal "/french%20cuisine/belgian%20beer/2008/09/09/foo-bar.html", @post.url
          end
        end

        context "with mixed case (category)" do
          setup do
            @post.categories << "MixedCase"
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:year/:month/:day/:title.html", @post.template
            assert_equal "/mixedcase/2008/09/09/foo-bar.html", @post.url
          end
        end

        context "with duplicated mixed case (categories)" do
          setup do
            @post.categories << "MixedCase"
            @post.categories << "Mixedcase"
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:year/:month/:day/:title.html", @post.template
            assert_equal "/mixedcase/2008/09/09/foo-bar.html", @post.url
          end
        end

        context "with none style" do
          setup do
            @post.site.permalink_style = :none
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:title.html", @post.template
            assert_equal "/foo-bar.html", @post.url
          end
        end

        context "with pretty style" do
          setup do
            @post.site.permalink_style = :pretty
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:year/:month/:day/:title/", @post.template
            assert_equal "/2008/09/09/foo-bar/", @post.url
          end
        end

        context "with ordinal style" do
          setup do
            @post.site.permalink_style = :ordinal
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:year/:y_day/:title.html", @post.template
            assert_equal "/2008/253/foo-bar.html", @post.url
          end
        end

        context "with custom date permalink" do
          setup do
            @post.site.permalink_style = '/:categories/:year/:i_month/:i_day/:title/'
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/2008/9/9/foo-bar/", @post.url
          end
        end

        context "with custom abbreviated month date permalink" do
          setup do
            @post.site.permalink_style = '/:categories/:year/:short_month/:day/:title/'
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/2008/Sep/09/foo-bar/", @post.url
          end
        end

        context "with prefix style and no extension" do
          setup do
            @post.site.permalink_style = "/prefix/:title"
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/prefix/:title", @post.template
            assert_equal "/prefix/foo-bar", @post.url
          end
        end
      end

      should "read yaml front-matter" do
        @post.read_yaml(@source, @real_file)

        assert_equal({"title" => "Foo Bar", "layout" => "default"}, @post.data)
        assert_equal "# {{ page.title }}\n\nBest **post** ever", @post.content
      end

      should "transform textile" do
        @post.process(@real_file)
        @post.read_yaml(@source, @real_file)
        assert_equal "<h1 id=\"pagetitle-\">{{ page.title }}</h1>\n\n<p>Best <strong>post</strong> ever</p>", @post.transform.strip
      end

      context "#excerpt" do
        setup do
          file = "2013-01-02-post-excerpt.markdown"
          @post = setup_post(file)
          @post.process(file)
          @post.read_yaml(@source, file)
          do_render(@post)
        end

        should "return first paragraph by default" do
          assert @post.excerpt.include?("First paragraph"), "contains first paragraph"
          assert !@post.excerpt.include?("Second paragraph"), "does not contains second paragraph"
          assert !@post.excerpt.include?("Third paragraph"), "does not contains third paragraph"
        end

        should "correctly resolve link references" do
          assert @post.excerpt.include?("www.jekyllrb.com"), "contains referenced link URL"
        end

        should "return rendered HTML" do
          assert_equal "<p>First paragraph with <a href=\"http://www.jekyllrb.com/\">link ref</a>.</p>\n\n",
                       @post.excerpt
        end

        context "with excerpt_separator setting" do
          setup do
            file = "2013-01-02-post-excerpt.markdown"

            @post.site.config['excerpt_separator'] = "\n---\n"

            @post.process(file)
            @post.read_yaml(@source, file)
            @post.transform
          end

          should "respect given separator" do
            assert @post.excerpt.include?("First paragraph"), "contains first paragraph"
            assert @post.excerpt.include?("Second paragraph"), "contains second paragraph"
            assert !@post.excerpt.include?("Third paragraph"), "does not contains third paragraph"
          end

          should "replace separator with new-lines" do
            assert !@post.excerpt.include?("---"), "does not contains separator"
          end
        end

        context "with page's excerpt_separator setting" do
          setup do
            file = "2015-01-08-post-excerpt-separator.markdown"

            @post.process(file)
            @post.read_yaml(@source, file)
            @post.transform
          end

          should "respect given separator" do
            assert @post.excerpt.include?("First paragraph"), "contains first paragraph"
            assert @post.excerpt.include?("Second paragraph"), "contains second paragraph"
            assert !@post.excerpt.include?("Third paragraph"), "does not contains third paragraph"
          end
        end

        context "with custom excerpt" do
          setup do
            file = "2013-04-11-custom-excerpt.markdown"
            @post = setup_post(file)
            do_render(@post)
          end

          should "use custom excerpt" do
            assert_equal("I can set a custom excerpt", @post.excerpt)
          end

          should "expose custom excerpt to liquid" do
            assert @post.content.include?("I can use the excerpt: <quote>I can set a custom excerpt</quote>"), "Exposes incorrect excerpt to liquid."
          end

        end

      end
    end

    context "when in a site" do
      setup do
        clear_dest
        @site = fixture_site
        @site.posts = [setup_post('2008-02-02-published.textile'),
                       setup_post('2009-01-27-categories.textile')]
      end

      should "have next post" do
        assert_equal(@site.posts.last, @site.posts.first.next)
      end

      should "have previous post" do
        assert_equal(@site.posts.first, @site.posts.last.previous)
      end

      should "not have previous post if first" do
        assert_equal(nil, @site.posts.first.previous)
      end

      should "not have next post if last" do
        assert_equal(nil, @site.posts.last.next)
      end
    end

    context "initializing posts" do
      should "recognize date in yaml" do
        post = setup_post("2010-01-09-date-override.markdown")
        do_render(post)
        assert_equal Time, post.date.class
        assert_equal Time, post.to_liquid["date"].class
        assert_equal "/2010/01/10/date-override.html", post.url
        assert_equal "<p>Post with a front matter date</p>\n\n<p>10 Jan 2010</p>", post.output.strip
      end

      should "recognize time in yaml" do
        post = setup_post("2010-01-09-time-override.markdown")
        do_render(post)
        assert_equal Time, post.date.class
        assert_equal Time, post.to_liquid["date"].class
        assert_equal "/2010/01/10/time-override.html", post.url
        assert_equal "<p>Post with a front matter time</p>\n\n<p>10 Jan 2010</p>", post.output.strip
      end

      should "recognize time with timezone in yaml" do
        post = setup_post("2010-01-09-timezone-override.markdown")
        do_render(post)
        assert_equal Time, post.date.class
        assert_equal Time, post.to_liquid["date"].class
        assert_equal "/2010/01/10/timezone-override.html", post.url
        assert_equal "<p>Post with a front matter time with timezone</p>\n\n<p>10 Jan 2010</p>", post.output.strip
      end

      should "to_liquid prioritizes post attributes over data" do
        post = setup_post("2010-01-16-override-data.textile")
        assert_equal Array, post.tags.class
        assert_equal Array, post.to_liquid["tags"].class
        assert_equal Time, post.date.class
        assert_equal Time, post.to_liquid["date"].class
      end

      should "to_liquid should consider inheritance" do
        klass = Class.new(Jekyll::Post)
        assert_gets_called = false
        klass.send(:define_method, :assert_gets_called) { assert_gets_called = true }
        klass.const_set(:EXCERPT_ATTRIBUTES_FOR_LIQUID, Jekyll::Post::EXCERPT_ATTRIBUTES_FOR_LIQUID + ['assert_gets_called'])
        post = klass.new(@site, source_dir, '', "2008-02-02-published.textile")
        do_render(post)

        assert assert_gets_called, 'assert_gets_called did not get called on post.'
      end

      should "recognize category in yaml" do
        post = setup_post("2009-01-27-category.textile")
        assert post.categories.include?('foo')
      end

      should "recognize several categories in yaml" do
        post = setup_post("2009-01-27-categories.textile")
        assert post.categories.include?('foo')
        assert post.categories.include?('bar')
        assert post.categories.include?('baz')
      end

      should "recognize empty category in yaml" do
        post = setup_post("2009-01-27-empty-category.textile")
        assert_equal [], post.categories
      end

      should "recognize empty categories in yaml" do
        post = setup_post("2009-01-27-empty-categories.textile")
        assert_equal [], post.categories
      end

      should "recognize number category in yaml" do
        post = setup_post("2013-05-10-number-category.textile")
        assert post.categories.include?('2013')
        assert !post.categories.include?(2013)
      end

      should "recognize mixed case category in yaml" do
        post = setup_post("2014-07-05-mixed-case-category.markdown")
        assert post.categories.include?('MixedCase')
        assert !post.categories.include?('mixedcase')
      end

      should "recognize tag in yaml" do
        post = setup_post("2009-05-18-tag.textile")
        assert post.tags.include?('code')
      end

      should "recognize tags in yaml" do
        post = setup_post("2009-05-18-tags.textile")
        assert post.tags.include?('food')
        assert post.tags.include?('cooking')
        assert post.tags.include?('pizza')
      end

      should "recognize empty tag in yaml" do
        post = setup_post("2009-05-18-empty-tag.textile")
        assert_equal [], post.tags
      end

      should "recognize empty tags in yaml" do
        post = setup_post("2009-05-18-empty-tags.textile")
        assert_equal [], post.tags
      end

      should "allow no yaml" do
        post = setup_post("2009-06-22-no-yaml.textile")
        assert_equal "No YAML.", post.content
      end

      should "allow empty yaml" do
        post = setup_post("2009-06-22-empty-yaml.textile")
        assert_equal "Empty YAML.", post.content
      end

      context "rendering" do
        setup do
          clear_dest
        end

        should "render properly" do
          post = setup_post("2008-10-18-foo-bar.markdown")
          do_render(post)
          assert_equal "<<< <h1 id=\"foo-bar\">Foo Bar</h1>\n\n<p>Best <strong>post</strong> ever</p>\n >>>", post.output
        end

        should "write properly" do
          post = setup_post("2008-10-18-foo-bar.markdown")
          do_render(post)
          post.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exist?(File.join(dest_dir, '2008', '10', '18', 'foo-bar.html'))
        end

        should "write properly when url has hash" do
          post = setup_post("2009-03-12-hash-#1.markdown")
          do_render(post)
          post.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exist?(File.join(dest_dir, '2009', '03', '12',
                                        'hash-#1.html'))
        end

        should "write properly when url has space" do
          post = setup_post("2014-03-22-escape-+ %20[].markdown")
          do_render(post)
          post.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exist?(File.join(dest_dir, '2014', '03', '22',
                                        'escape-+ %20[].html'))
        end

        should "write properly when category has different letter case" do
          %w(2014-07-05-mixed-case-category.markdown 2014-07-05-another-mixed-case-category.markdown).each do |file|
            post = setup_post(file)
            do_render(post)
            post.write(dest_dir)
          end

          assert File.directory?(dest_dir)
          assert File.exist?(File.join(dest_dir, 'mixedcase', '2014', '07', '05',
                                        'mixed-case-category.html'))
          assert File.exist?(File.join(dest_dir, 'mixedcase', '2014', '07', '05',
                                        'another-mixed-case-category.html'))
        end

        should "write properly without html extension" do
          post = setup_post("2008-10-18-foo-bar.markdown")
          post.site.permalink_style = ":title/"
          do_render(post)
          post.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exist?(File.join(dest_dir, 'foo-bar', 'index.html'))
        end

        should "insert data" do
          post = setup_post("2008-11-21-complex.markdown")
          do_render(post)

          assert_equal "<<< <p>url: /2008/11/21/complex.html\ndate: #{Time.parse("2008-11-21")}\nid: /2008/11/21/complex</p>\n >>>", post.output
        end

        should "include templates" do
          post = setup_post("2008-12-13-include.markdown")
          do_render(post)

          assert_equal "<<< <hr />\n<p>Tom Preston-Werner\ngithub.com/mojombo</p>\n\n<p>This <em>is</em> cool</p>\n >>>", post.output
        end

        should "render date specified in front matter properly" do
          post = setup_post("2010-01-09-date-override.markdown")
          do_render(post)

          assert_equal "<p>Post with a front matter date</p>\n\n<p>10 Jan 2010</p>", post.output.strip
        end

        should "render time specified in front matter properly" do
          post = setup_post("2010-01-09-time-override.markdown")
          do_render(post)

          assert_equal "<p>Post with a front matter time</p>\n\n<p>10 Jan 2010</p>", post.output.strip
        end

      end
    end

    should "generate categories and topics" do
      post = Post.new(@site, File.join(File.dirname(__FILE__), *%w[source]), 'foo', 'bar/2008-12-12-topical-post.textile')
      assert_equal ['foo'], post.categories
    end
  end

  context "converter file extension settings" do
    setup do
      @site = fixture_site
    end

    should "process .md as markdown under default configuration" do
      post = setup_post '2011-04-12-md-extension.md'
      conv = post.converters.first
      assert conv.kind_of? Jekyll::Converters::Markdown
    end

    should "process .text as identity under default configuration" do
      post = setup_post '2011-04-12-text-extension.text'
      conv = post.converters.first
      assert conv.kind_of? Jekyll::Converters::Identity
    end

    should "process .text as markdown under alternate configuration" do
      @site.config['markdown_ext'] = 'markdown,mdw,mdwn,md,text'
      post = setup_post '2011-04-12-text-extension.text'
      conv = post.converters.first
      assert conv.kind_of? Jekyll::Converters::Markdown
    end

    should "process .md as markdown under alternate configuration" do
      @site.config['markdown_ext'] = 'markdown,mkd,mkdn,md,text'
      post = setup_post '2011-04-12-text-extension.text'
      conv = post.converters.first
      assert conv.kind_of? Jekyll::Converters::Markdown
    end

    should "process .mkdn under text if it is not in the markdown config" do
      @site.config['markdown_ext'] = 'markdown,mkd,md,text'
      post = setup_post '2013-08-01-mkdn-extension.mkdn'
      conv = post.converters.first
      assert conv.kind_of? Jekyll::Converters::Identity
    end

    should "process .Rmd under text if it is not in the markdown config" do
      @site.config['markdown_ext'] = 'markdown,mkd,md,text'
      post = setup_post '2014-11-24-Rmd-extension.Rmd'
      assert_equal 1, post.converters.size
      conv = post.converters.first
      assert conv.kind_of?(Jekyll::Converters::Identity), "The converter for .Rmd should be the Identity converter."
    end

  end

  context "site config with category" do
    setup do
      front_matter_defaults = {
        'defaults' => [{
          'scope' =>  { 'path' => '' },
          'values' => { 'category' => 'article' }
        }]
      }
      @site = fixture_site(front_matter_defaults)
    end

    should "return category if post does not specify category" do
      post = setup_post("2009-01-27-no-category.textile")
      assert post.categories.include?('article'), "Expected post.categories to include 'article' but did not."
    end

    should "override site category if set on post" do
      post = setup_post("2009-01-27-category.textile")
      assert post.categories.include?('foo'), "Expected post.categories to include 'foo' but did not."
      assert !post.categories.include?('article'), "Did not expect post.categories to include 'article' but it did."
    end
  end

  context "site config with categories" do
    setup do
      front_matter_defaults = {
        'defaults' => [{
          'scope' =>  { 'path' => '' },
          'values' => { 'categories' => ['article'] }
        }]
      }
      @site = fixture_site(front_matter_defaults)
    end

    should "return categories if post does not specify categories" do
      post = setup_post("2009-01-27-no-category.textile")
      assert post.categories.include?('article'), "Expected post.categories to include 'article' but did not."
    end

    should "override site categories if set on post" do
      post = setup_post("2009-01-27-categories.textile")
      ['foo', 'bar', 'baz'].each do |category|
        assert post.categories.include?(category), "Expected post.categories to include '#{category}' but did not."
      end
      assert !post.categories.include?('article'), "Did not expect post.categories to include 'article' but it did."
    end
  end

end
