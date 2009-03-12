require File.dirname(__FILE__) + '/helper'

class TestPost < Test::Unit::TestCase
  def setup
    Jekyll.configure(Jekyll::DEFAULTS)
  end
  
  def test_valid
    assert Post.valid?("2008-10-19-foo-bar.textile")
    assert Post.valid?("foo/bar/2008-10-19-foo-bar.textile")
    
    assert !Post.valid?("lol2008-10-19-foo-bar.textile")
    assert !Post.valid?("blah")
  end
  
  def test_process
    p = Post.allocate
    p.process("2008-10-19-foo-bar.textile")
    
    assert_equal Time.parse("2008-10-19"), p.date
    assert_equal "foo-bar", p.slug
    assert_equal ".textile", p.ext
  end
  
  def test_url
    p = Post.allocate
    p.categories = []
    p.process("2008-10-19-foo-bar.textile")
    
    assert_equal "/2008/10/19/foo-bar.html", p.url
  end
  
  def test_permalink
    p = Post.allocate
    p.process("2008-12-03-permalinked-post.textile")
    p.read_yaml(File.join(File.dirname(__FILE__), *%w[source _posts]), "2008-12-03-permalinked-post.textile")

    assert_equal "my_category/permalinked-post", p.permalink
  end

  def test_dir_respects_permalink
    p = Post.allocate
    p.process("2008-12-03-permalinked-post.textile")
    p.read_yaml(File.join(File.dirname(__FILE__), *%w[source _posts]), "2008-12-03-permalinked-post.textile")

    assert_equal "my_category/", p.dir
  end
  
  def test_url_respects_permalink
    p = Post.allocate
    p.process("2008-12-03-permalinked-post.textile")
    p.read_yaml(File.join(File.dirname(__FILE__), *%w[source _posts]), "2008-12-03-permalinked-post.textile")

    assert_equal "my_category/permalinked-post", p.url
  end

  def test_read_yaml
    p = Post.allocate
    p.read_yaml(File.join(File.dirname(__FILE__), *%w[source _posts]), "2008-10-18-foo-bar.textile")
    
    assert_equal({"title" => "Foo Bar", "layout" => "default"}, p.data)
    assert_equal "\nh1. {{ page.title }}\n\nBest *post* ever", p.content
  end
  
  def test_transform
    p = Post.allocate
    p.process("2008-10-18-foo-bar.textile")
    p.read_yaml(File.join(File.dirname(__FILE__), *%w[source _posts]), "2008-10-18-foo-bar.textile")
    p.transform
    
    assert_equal "<h1>{{ page.title }}</h1>\n<p>Best <strong>post</strong> ever</p>", p.content
  end

  def test_published
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',  "2008-02-02-published.textile")
		assert_equal true, p.published
  end

  def test_not_published
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',  "2008-02-02-not-published.textile")
		assert_equal false, p.published
  end

  def test_yaml_category
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',  "2009-01-27-category.textile")
    assert p.categories.include?('foo')
  end

  def test_yaml_categories
    p1 = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',
                  "2009-01-27-categories.textile")
    p2 = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',
                  "2009-01-27-array-categories.textile")
    
    [p1, p2].each do |p|
      assert p.categories.include?('foo')
      assert p.categories.include?('bar')
      assert p.categories.include?('baz')
    end
  end
  
  def test_render
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '',  "2008-10-18-foo-bar.textile")
    layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
    p.render(layouts, {"site" => {"posts" => []}})
    
    assert_equal "<<< <h1>Foo Bar</h1>\n<p>Best <strong>post</strong> ever</p> >>>", p.output
  end
  
  def test_write
    clear_dest
    
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '', "2008-10-18-foo-bar.textile")
    layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
    p.render(layouts, {"site" => {"posts" => []}})
    p.write(dest_dir)
  end
  
  def test_data
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '', "2008-11-21-complex.textile")
    layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
    p.render(layouts, {"site" => {"posts" => []}})
    
    assert_equal "<<< <p>url: /2008/11/21/complex.html<br />\ndate: #{Time.parse("2008-11-21")}<br />\nid: /2008/11/21/complex</p> >>>", p.output
  end
  
  def test_categories_and_topics
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), 'foo', 'bar/2008-12-12-topical-post.textile')
    assert_equal ['foo'], p.categories
    assert_equal ['bar'], p.topics
  end    
  
  def test_include
    config = Jekyll::DEFAULTS.clone
    config['source'] = File.join(File.dirname(__FILE__), *%w[source])
    Jekyll.configure(config)

    p = Post.new(File.join(File.dirname(__FILE__), *%w[source]), '', "2008-12-13-include.markdown")
    layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
    p.render(layouts, {"site" => {"posts" => []}})
    
    assert_equal "<<< <hr />\n<p>Tom Preston-Werner github.com/mojombo</p>\n\n<p>This <em>is</em> cool</p> >>>", p.output
  end
end
