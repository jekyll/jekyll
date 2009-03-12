require File.dirname(__FILE__) + '/helper'

class TestSite < Test::Unit::TestCase
  def setup
    @config = Jekyll::DEFAULTS.clone
    @config['source'] = File.join(File.dirname(__FILE__), *%w[source])
    @config['destination'] = dest_dir
    Jekyll.configure(@config)
    @s = Site.new(@config)
  end
  
  def test_site_init
    
  end
  
  def test_read_layouts
    @s.read_layouts
    
    assert_equal ["default", "simple"].sort, @s.layouts.keys.sort
  end
 
  def test_read_posts
    @s.read_posts('')
    posts = Dir[File.join(@config['source'], '_posts/*')]
    assert_equal posts.size - 1, @s.posts.size
  end
  
  def test_site_payload
    clear_dest
    @s.process
    
    posts = Dir[File.join(@config['source'], "**", "_posts/*")]
    categories = %w(bar baz category foo z_category publish_test).sort

    assert_equal posts.size - 1, @s.posts.size
    assert_equal categories, @s.categories.keys.sort
    assert_equal 4, @s.categories['foo'].size
  end

  def test_filter_entries
    ent1 = %w[foo.markdown bar.markdown baz.markdown #baz.markdown#
              .baz.markdow foo.markdown~]
    ent2 = %w[.htaccess _posts bla.bla]

    assert_equal %w[foo.markdown bar.markdown baz.markdown], @s.filter_entries(ent1)
    assert_equal ent2, @s.filter_entries(ent2)
  end
end
