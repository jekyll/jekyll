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



  should "RENAME ME: test published" do
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',  "2008-02-02-published.textile")
		assert_equal true, p.published
  end

  should "RENAME ME: test not published" do
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',  "2008-02-02-not-published.textile")
		assert_equal false, p.published
  end

  should "RENAME ME: test yaml category" do
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',  "2009-01-27-category.textile")
    assert p.categories.include?('foo')
  end

  should "RENAME ME: test yaml categories" do
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',  "2009-01-27-categories.textile")
    assert p.categories.include?('foo')
    assert p.categories.include?('bar')
    assert p.categories.include?('baz')
  end
  
  should "RENAME ME: test render" do
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',  "2008-10-18-foo-bar.textile")
    layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
    p.render(layouts, {"site" => {"posts" => []}})
    
    assert_equal "<<< <h1>Foo Bar</h1>\n<p>Best <strong>post</strong> ever</p> >>>", p.output
  end
  
  should "RENAME ME: test write" do
    clear_dest
    
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '', "2008-10-18-foo-bar.textile")
    layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
    p.render(layouts, {"site" => {"posts" => []}})
    p.write(dest_dir)
  end
  
  should "RENAME ME: test data" do
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '', "2008-11-21-complex.textile")
    layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
    p.render(layouts, {"site" => {"posts" => []}})
    
    assert_equal "<<< <p>url: /2008/11/21/complex.html<br />\ndate: #{Time.parse("2008-11-21")}<br />\nid: /2008/11/21/complex</p> >>>", p.output
  end
  
  should "RENAME ME: test categories and topics" do
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), 'foo', 'bar/2008-12-12-topical-post.textile')
    assert_equal ['foo'], p.categories
    assert_equal ['bar'], p.topics
  end    
  
  should "RENAME ME: test include" do
    Jekyll.source = File.join(File.dirname(__FILE__), *%w[source])
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '', "2008-12-13-include.markdown")
    layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
    p.render(layouts, {"site" => {"posts" => []}})
    
    assert_equal "<<< <hr />\n<p>Tom Preston-Werner github.com/mojombo</p>\n\n<p>This <em>is</em> cool</p> >>>", p.output
  end
end
