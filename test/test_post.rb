require File.dirname(__FILE__) + '/helper'

class TestPost < Test::Unit::TestCase
  should "ensure valid posts are valid" do
    assert Post.valid?("2008-10-19-foo-bar.textile")
    assert Post.valid?("foo/bar/2008-10-19-foo-bar.textile")

    assert !Post.valid?("lol2008-10-19-foo-bar.textile")
    assert !Post.valid?("blah")
  end

  context "processing posts" do
    setup do
      @post = Post.allocate
      @real_file = "2008-10-18-foo-bar.textile"
      @fake_file = "2008-10-19-foo-bar.textile"
      @source = File.join(File.dirname(__FILE__), *%w[source _posts])
    end

    should "keep date, title, and markup type" do
      @post.process(@fake_file)

      assert_equal Time.parse("2008-10-19"), @post.date
      assert_equal "foo-bar", @post.slug
      assert_equal ".textile", @post.ext
    end

    should "create url based on date and title" do
      @post.categories = []
      @post.process(@fake_file)
      assert_equal "/2008/10/19/foo-bar.html", @post.url
    end

    should "respect permalink" do
      file = "2008-12-03-permalinked-post.textile"
      @post.process(file)
      @post.read_yaml(@source, file)

      assert_equal "my_category/permalinked-post", @post.permalink
      assert_equal "my_category/", @post.dir
      assert_equal "my_category/permalinked-post", @post.url
    end

    should "read yaml front-matter" do
      @post.read_yaml(@source, @real_file)

      assert_equal({"title" => "Foo Bar", "layout" => "default"}, @post.data)
      assert_equal "\nh1. {{ page.title }}\n\nBest *post* ever", @post.content
    end

    should "transform textile" do
      @post.process(@real_file)
      @post.read_yaml(@source, @real_file)
      @post.transform

      assert_equal "<h1>{{ page.title }}</h1>\n<p>Best <strong>post</strong> ever</p>", @post.content
    end
  end

  context "initializing posts" do
    setup do
      @setup_post = lambda do |file|
        Post.new(File.join(File.dirname(__FILE__), *%w[source]), '', file)
      end
    end

    should "publish when published yaml is no specified" do
      post = @setup_post.call("2008-02-02-published.textile")
      assert_equal true, post.published
    end

    should "not published when published yaml is false" do
      post = @setup_post.call("2008-02-02-not-published.textile")
      assert_equal false, post.published
    end

    should "recognize category in yaml" do
      post = @setup_post.call("2009-01-27-category.textile")
      assert post.categories.include?('foo')
    end

    should "recognize several categories in yaml" do
      post = @setup_post.call("2009-01-27-categories.textile")
      assert post.categories.include?('foo')
      assert post.categories.include?('bar')
      assert post.categories.include?('baz')
    end

    context "rendering" do
      setup do
        clear_dest
        @render = lambda do |post|
          layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
          post.render(layouts, {"site" => {"posts" => []}})
        end
      end

      should "render properly" do
        post = @setup_post.call("2008-10-18-foo-bar.textile")
        @render.call(post)
        assert_equal "<<< <h1>Foo Bar</h1>\n<p>Best <strong>post</strong> ever</p> >>>", post.output
      end

      should "write properly" do
        post = @setup_post.call("2008-10-18-foo-bar.textile")
        @render.call(post)
        post.write(dest_dir)

        assert File.directory?(dest_dir)
        assert File.exists?(File.join(dest_dir, '2008', '10', '18', 'foo-bar.html'))
      end

      should "insert data" do
        post = @setup_post.call("2008-11-21-complex.textile")
        @render.call(post)

        assert_equal "<<< <p>url: /2008/11/21/complex.html<br />\ndate: #{Time.parse("2008-11-21")}<br />\nid: /2008/11/21/complex</p> >>>", post.output
      end

      should "include templates" do
        Jekyll.source = File.join(File.dirname(__FILE__), 'source')
        post = @setup_post.call("2008-12-13-include.markdown")
        @render.call(post)

        assert_equal "<<< <hr />\n<p>Tom Preston-Werner github.com/mojombo</p>\n\n<p>This <em>is</em> cool</p> >>>", post.output
      end
    end
  end

  should "generate categories and topics" do
    post = Post.new(File.join(File.dirname(__FILE__), *%w[source]), 'foo', 'bar/2008-12-12-topical-post.textile')
    assert_equal ['foo'], post.categories
    assert_equal ['bar'], post.topics
  end
end
