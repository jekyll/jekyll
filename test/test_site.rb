require File.dirname(__FILE__) + '/helper'

class TestSite < Test::Unit::TestCase
  def setup
    config = {
      'source' => File.join(File.dirname(__FILE__), *%w[source]), 
      'destination' => dest_dir
    }
    @s = Site.new(config)
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
  
  def test_write_posts
    clear_dest
    
    @s.process
  end
end
