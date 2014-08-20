require 'helper'

class TestRelatedPosts < Test::Unit::TestCase
  context "building related posts without lsi" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir,
                                               'destination' => dest_dir})
      end
      @site = Site.new(Jekyll.configuration)
    end

    should "use the most recent posts for related posts" do
      @site.reset
      @site.read

      last_post     = @site.posts.last
      related_posts = Jekyll::RelatedPosts.new(last_post).build

      last_10_recent_posts = (@site.posts.reverse - [last_post]).first(10)
      assert_equal last_10_recent_posts, related_posts
    end
  end

  context "building related posts with lsi" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir,
                                               'destination' => dest_dir,
                                               'lsi' => true})
      end
      any_instance_of(Jekyll::RelatedPosts) { |i| stub(i).display }
      @site = Site.new(Jekyll.configuration)
    end

    should "use lsi for the related posts" do
      @site.reset
      @site.read
      require 'classifier-reborn'
      any_instance_of(::ClassifierReborn::LSI) do |c|
        stub(c).find_related { @site.posts[-1..-9] }
        stub(c).build_index
      end
      assert_equal @site.posts[-1..-9], Jekyll::RelatedPosts.new(@site.posts.last).build
    end
  end
end
