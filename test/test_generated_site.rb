require File.dirname(__FILE__) + '/helper'

class TestGeneratedSite < Test::Unit::TestCase
  def setup
    clear_dest
    @source = File.join(File.dirname(__FILE__), *%w[source])
    @s = Site.new(@source, dest_dir)
    @s.process
    @index = File.read(File.join(dest_dir, 'index.html'))
  end
  
  def test_site_posts_in_index
    # confirm that {{ site.posts }} is working
    assert @index.include?("#{@s.posts.size} Posts")
  end

  def test_post_content_in_index
    # confirm that the {{ post.content }} is rendered OK
    latest_post = Dir[File.join(@source, '_posts/*')].last
    post = Post.new(@source, '', File.basename(latest_post))
    Jekyll.content_type = post.determine_content_type
    post.transform
    assert @index.include?(post.content)
  end

  def test_unpublished_posts_are_hidden
    published = Dir[File.join(dest_dir, 'publish_test/2008/02/02/*.html')].map {|f| File.basename(f)}
    
    assert_equal 1, published.size
    assert_equal "published.html", published.first
  end
end
