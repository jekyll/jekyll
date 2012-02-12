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
      stub(Jekyll).configuration { Jekyll::DEFAULTS }
      @site = Site.new(Jekyll.configuration)
    end

    should "ensure valid posts are valid" do
      assert Post.valid?("2008-09-09-foo-bar.textile")
      assert Post.valid?("foo/bar/2008-09-09-foo-bar.textile")

      assert !Post.valid?("lol2008-09-09-foo-bar.textile")
      assert !Post.valid?("blah")
    end

    context "processing posts" do
      setup do
        @post = Post.allocate
        @post.site = @site

        @real_file = "2008-10-18-foo-bar.textile"
        @fake_file = "2008-09-09-foo-bar.textile"
        @source = source_dir('_posts')
      end

      should "keep date, title, and markup type" do
        @post.categories = []
        @post.process(@fake_file)

        assert_equal Time.parse("2008-09-09"), @post.date
        assert_equal "foo-bar", @post.slug
        assert_equal ".textile", @post.ext
        assert_equal "/2008/09/09", @post.dir
        assert_equal "/2008/09/09/foo-bar", @post.id
      end

      should "create url based on date and title" do
        @post.categories = []
        @post.process(@fake_file)
        assert_equal "/2008/09/09/foo-bar.html", @post.url
      end

      should "raise a good error on invalid post date" do
        assert_raise Jekyll::FatalException do
          @post.process("2009-27-03-foo-bar.textile")
        end
      end

      should "CGI escape urls" do
        @post.categories = []
        @post.process("2009-03-12-hash-#1.markdown")
        assert_equal "/2009/03/12/hash-%231.html", @post.url
        assert_equal "/2009/03/12/hash-#1", @post.id
      end

      should "respect permalink in yaml front matter" do
        file = "2008-12-03-permalinked-post.textile"
        @post.process(file)
        @post.read_yaml(@source, file)

        assert_equal "my_category/permalinked-post", @post.permalink
        assert_equal "my_category", @post.dir
        assert_equal "my_category/permalinked-post", @post.url
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
            @post.categories << "French cuisine"
            @post.categories << "Belgian beer"
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/:categories/:year/:month/:day/:title.html", @post.template
            assert_equal "/French%20cuisine/Belgian%20beer/2008/09/09/foo-bar.html", @post.url
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

        context "with custom date permalink" do
          setup do
            @post.site.permalink_style = '/:categories/:year/:i_month/:i_day/:title/'
            @post.process(@fake_file)
          end

          should "process the url correctly" do
            assert_equal "/2008/9/9/foo-bar/", @post.url
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
        assert_equal "h1. {{ page.title }}\n\nBest *post* ever", @post.content
      end

      should "transform textile" do
        @post.process(@real_file)
        @post.read_yaml(@source, @real_file)
        @post.transform

        assert_equal "<h1>{{ page.title }}</h1>\n<p>Best <strong>post</strong> ever</p>", @post.content
      end
    end

    context "when in a site" do
      setup do
        clear_dest
        stub(Jekyll).configuration { Jekyll::DEFAULTS }
        @site = Site.new(Jekyll.configuration)
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
      should "publish when published yaml is no specified" do
        post = setup_post("2008-02-02-published.textile")
        assert_equal true, post.published
      end

      should "not published when published yaml is false" do
        post = setup_post("2008-02-02-not-published.textile")
        assert_equal false, post.published
      end

      should "recognize date in yaml" do
        post = setup_post("2010-01-09-date-override.textile")
        do_render(post)
        assert_equal Time, post.date.class
        assert_equal Time, post.to_liquid["date"].class
        assert_equal "/2010/01/10/date-override.html", post.url
        assert_equal "<p>Post with a front matter date</p>\n<p>10 Jan 2010</p>", post.output
      end

      should "recognize time in yaml" do
        post = setup_post("2010-01-09-time-override.textile")
        do_render(post)
        assert_equal Time, post.date.class
        assert_equal Time, post.to_liquid["date"].class
        assert_equal "/2010/01/10/time-override.html", post.url
        assert_equal "<p>Post with a front matter time</p>\n<p>10 Jan 2010</p>", post.output
      end

      should "recognize time with timezone in yaml" do
        post = setup_post("2010-01-09-timezone-override.textile")
        do_render(post)
        assert_equal Time, post.date.class
        assert_equal Time, post.to_liquid["date"].class
        assert_equal "/2010/01/10/timezone-override.html", post.url
        assert_equal "<p>Post with a front matter time with timezone</p>\n<p>10 Jan 2010</p>", post.output
      end

      should "to_liquid prioritizes post attributes over data" do
        post = setup_post("2010-01-16-override-data.textile")
        assert_equal Array, post.tags.class
        assert_equal Array, post.to_liquid["tags"].class
        assert_equal Time, post.date.class
        assert_equal Time, post.to_liquid["date"].class
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
          post = setup_post("2008-10-18-foo-bar.textile")
          do_render(post)
          assert_equal "<<< <h1>Foo Bar</h1>\n<p>Best <strong>post</strong> ever</p> >>>", post.output
        end

        should "write properly" do
          post = setup_post("2008-10-18-foo-bar.textile")
          do_render(post)
          post.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exists?(File.join(dest_dir, '2008', '10', '18', 'foo-bar.html'))
        end

        should "write properly without html extension" do
          post = setup_post("2008-10-18-foo-bar.textile")
          post.site.permalink_style = ":title"
          do_render(post)
          post.write(dest_dir)

          assert File.directory?(dest_dir)
          assert File.exists?(File.join(dest_dir, 'foo-bar', 'index.html'))
        end

        should "insert data" do
          post = setup_post("2008-11-21-complex.textile")
          do_render(post)

          assert_equal "<<< <p>url: /2008/11/21/complex.html<br />\ndate: #{Time.parse("2008-11-21")}<br />\nid: /2008/11/21/complex</p> >>>", post.output
        end

        should "include templates" do
          post = setup_post("2008-12-13-include.markdown")
          post.site.source = File.join(File.dirname(__FILE__), 'source')
          do_render(post)

          assert_equal "<<< <hr />\n<p>Tom Preston-Werner github.com/mojombo</p>\n\n<p>This <em>is</em> cool</p> >>>", post.output
        end

        should "render date specified in front matter properly" do
          post = setup_post("2010-01-09-date-override.textile")
          do_render(post)

          assert_equal "<p>Post with a front matter date</p>\n<p>10 Jan 2010</p>", post.output
        end

        should "render time specified in front matter properly" do
          post = setup_post("2010-01-09-time-override.textile")
          do_render(post)

          assert_equal "<p>Post with a front matter time</p>\n<p>10 Jan 2010</p>", post.output
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
      stub(Jekyll).configuration { Jekyll::DEFAULTS }
      @site = Site.new(Jekyll.configuration)
    end
    
    should "process .md as markdown under default configuration" do
      post = setup_post '2011-04-12-md-extension.md'
      conv = post.converter
      assert conv.kind_of? Jekyll::MarkdownConverter
    end
    
    should "process .text as indentity under default configuration" do
      post = setup_post '2011-04-12-text-extension.text'
      conv = post.converter
      assert conv.kind_of? Jekyll::IdentityConverter
    end
    
    should "process .text as markdown under alternate configuration" do
      @site.config['markdown_ext'] = 'markdown,mdw,mdwn,md,text'
      post = setup_post '2011-04-12-text-extension.text'
      conv = post.converter
      assert conv.kind_of? Jekyll::MarkdownConverter
    end
    
    should "process .md as markdown under alternate configuration" do
      @site.config['markdown_ext'] = 'markdown,mkd,mkdn,md,text'
      post = setup_post '2011-04-12-text-extension.text'
      conv = post.converter
      assert conv.kind_of? Jekyll::MarkdownConverter
    end
    
    should "process .text as textile under alternate configuration" do
      @site.config['textile_ext'] = 'textile,text'
      post = setup_post '2011-04-12-text-extension.text'
      conv = post.converter
      assert conv.kind_of? Jekyll::TextileConverter
    end
    
  end
  
end
