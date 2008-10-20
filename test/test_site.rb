require File.dirname(__FILE__) + '/helper'

class TestSite < Test::Unit::TestCase
  def setup
    source = File.join(File.dirname(__FILE__), *%w[source])
    @s = Site.new(source, "")
  end
  
  def test_site_init
    
  end
  
  def test_read_layouts
    @s.read_layouts
    
    assert_equal ["default"], @s.layouts.keys
  end
  
  def test_read_posts
    @s.read_posts
    
    assert_equal 1, @s.posts.size
  end
end