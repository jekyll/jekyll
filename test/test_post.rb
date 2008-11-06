require File.dirname(__FILE__) + '/helper'

class TestPost < Test::Unit::TestCase
  def setup
    
  end
  
  def test_valid
    assert Post.valid?("2008-10-19-foo-bar.textile")
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
    p.process("2008-10-19-foo-bar.textile")
    
    assert_equal "/2008/10/19/foo-bar.html", p.url
  end
  
  def test_read_yaml
    p = Post.allocate
    p.read_yaml(File.join(File.dirname(__FILE__), *%w[source posts]), "2008-10-18-foo-bar.textile")
    
    assert_equal({"title" => "Foo Bar", "layout" => "default"}, p.data)
    assert_equal "\nh1. {{ page.title }}\n\nBest *post* ever", p.content
  end
  
  def test_transform
    p = Post.allocate
    p.process("2008-10-18-foo-bar.textile")
    p.read_yaml(File.join(File.dirname(__FILE__), *%w[source posts]), "2008-10-18-foo-bar.textile")
    p.transform
    
    assert_equal "<h1>{{ page.title }}</h1>\n\n\n\t<p>Best <strong>post</strong> ever</p>", p.content
  end
  
  def test_add_layout
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source posts]), "2008-10-18-foo-bar.textile")
    layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
    p.add_layout(layouts, {"site" => {"posts" => []}})
    
    assert_equal "<<< <h1>Foo Bar</h1>\n\n\n\t<p>Best <strong>post</strong> ever</p> >>>", p.output
  end
  
  def test_write
    clear_dest
    
    p = Post.new(File.join(File.dirname(__FILE__), *%w[source posts]), "2008-10-18-foo-bar.textile")
    layouts = {"default" => Layout.new(File.join(File.dirname(__FILE__), *%w[source _layouts]), "simple.html")}
    p.add_layout(layouts, {"site" => {"posts" => []}})
    p.write(dest_dir)
  end
end