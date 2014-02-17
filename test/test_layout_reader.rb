require 'helper'

class TestLayoutReader < Test::Unit::TestCase
  context "reading layouts" do
    setup do
      stub(Jekyll).configuration do
        Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      end
      @site = Site.new(Jekyll.configuration)
    end

    should "read layouts" do
      layouts = LayoutReader.new(@site).read
      assert_equal ["default", "simple", "post/simple"].sort, layouts.keys.sort
    end
  end
end
