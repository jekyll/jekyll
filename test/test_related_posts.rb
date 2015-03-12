require 'helper'

class TestRelatedPosts < JekyllUnitTest
  context "building related posts without lsi" do
    setup do
      @site = fixture_site
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
      allow_any_instance_of(Jekyll::RelatedPosts).to receive(:display)
      @site = fixture_site({"lsi" => true})
    end

    should "use lsi for the related posts" do
      @site.reset
      @site.read
      require 'classifier-reborn'
      allow_any_instance_of(::ClassifierReborn::LSI).to receive(:find_related).and_return(@site.posts[-1..-9])
      allow_any_instance_of(::ClassifierReborn::LSI).to receive(:build_index)

      assert_equal @site.posts[-1..-9], Jekyll::RelatedPosts.new(@site.posts.last).build
    end
  end
end
