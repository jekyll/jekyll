require File.dirname(__FILE__) + '/helper'

class TestGeneratedSite < Test::Unit::TestCase
  def setup
    clear_dest
    config = Jekyll::DEFAULTS.clone
    config['source'] = File.join(File.dirname(__FILE__), *%w[source])
    config['destination'] = dest_dir
    Jekyll.configure(config)
    @s = Site.new(config)
    @s.process
    @index = File.read(File.join(dest_dir, 'index.html'))
  end
  
  def test_site_posts_in_index
    # confirm that {{ site.posts }} is working
    assert @index.include?("#{@s.posts.size} Posts")
  end

  def test_post_content_in_index
    # confirm that the {{ post.content }} is rendered OK
    assert @index.include?('<p>This <em>is</em> cool</p>')
  end
end
