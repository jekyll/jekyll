require File.dirname(__FILE__) + '/helper'

class TestSite < Test::Unit::TestCase
  def setup
    source = File.join(File.dirname(__FILE__), *%w[source])
    @s = Site.new(source, dest_dir)
  end
  
  def test_site_init
    
  end
  
  def test_read_layouts
    @s.read_layouts
    
    assert_equal ["default", "simple"].sort, @s.layouts.keys.sort
  end
 
  def test_read_posts
    @s.read_posts('')
    
    assert_equal 4, @s.posts.size
  end
  
  def test_site_payload
    clear_dest
    @s.process
    
    assert_equal 5, @s.posts.length
    assert_equal ['foo'], @s.categories.keys
    assert_equal 1, @s.categories['foo'].length
  end
end
