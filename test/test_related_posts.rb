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
      assert_equal @site.posts[0..9], Jekyll::RelatedPosts.new(@site.posts.last).build
    end
  end

  context "building related posts with lsi" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir,
                                               'destination' => dest_dir,
                                               'lsi' => true})
      end
      @site = Site.new(Jekyll.configuration)
    end

    should "use lsi for the related posts" do
      @site.reset
      @site.read
      require 'classifier'
      any_instance_of(::Classifier::LSI) do |c|
        stub(c).find_related { @site.posts[-1..-9] }
        stub(c).build_index
      end
      assert_equal @site.posts[-1..-9], Jekyll::RelatedPosts.new(@site.posts.last).build
    end
  end
end
