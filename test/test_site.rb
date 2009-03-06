require File.dirname(__FILE__) + '/helper'

class TestSite < Test::Unit::TestCase
  context "creating sites" do
    setup do
      @source = File.join(File.dirname(__FILE__), 'source')
      @s = Site.new(@source, dest_dir)
    end

    should "read layouts" do
      @s.read_layouts
      assert_equal ["default", "simple"].sort, @s.layouts.keys.sort
    end

    should "read posts" do
      @s.read_posts('')
      posts = Dir[File.join(@source, '_posts/*')]
      assert_equal posts.size - 1, @s.posts.size
    end

    should "deploy payload" do
      clear_dest
      @s.process

      posts = Dir[File.join(@source, "**", "_posts/*")]
      categories = %w(bar baz category foo z_category publish_test).sort

      assert_equal posts.size - 1, @s.posts.size
      assert_equal categories, @s.categories.keys.sort
      assert_equal 3, @s.categories['foo'].size
    end
  end
end
