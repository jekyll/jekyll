require File.dirname(__FILE__) + '/helper'

class TestGeneratedSite < Test::Unit::TestCase
  context "generated sites" do
    setup do
      clear_dest
      @source = File.join(File.dirname(__FILE__), *%w[source])
      @configuration = Jekyll.configuration 'source' => @source, 'destination' => dest_dir
      @site = Site.new(@configuration)
      @site.process
      @index = File.read(File.join(dest_dir, 'index.html'))
    end

    should "insert site.posts into the index" do
      assert @index.include?("#{@site.posts.size} Posts")
    end

    should "render post.content" do
      latest_post = Dir[File.join(@source, '_posts/*')].last
      post = Post.new(@site, @source, '', File.basename(latest_post))
      #Jekyll.content_type = post.determine_content_type
      post.transform
      assert @index.include?(post.content)
    end

    should "hide unpublished posts" do
      published = Dir[File.join(dest_dir, 'publish_test/2008/02/02/*.html')].map {|f| File.basename(f)}

      assert_equal 1, published.size
      assert_equal "published.html", published.first
    end

    should "not copy _posts directory" do
      assert !File.exist?(File.join(dest_dir, '_posts'))
    end
  end
end
