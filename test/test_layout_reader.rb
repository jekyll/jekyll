require 'helper'

class TestLayoutReader < JekyllUnitTest
  context "reading layouts" do
    setup do
      config = Jekyll::Configuration::DEFAULTS.merge({'source' => source_dir, 'destination' => dest_dir})
      @site = fixture_site(config)
    end

    should "read layouts" do
      layouts = LayoutReader.new(@site).read
      assert_equal ["default", "simple", "post/simple"].sort, layouts.keys.sort
    end

    context "when no _layouts directory exists in CWD" do
      should "know to use the layout directory relative to the site source" do
        assert_equal LayoutReader.new(@site).layout_directories[0], source_dir("_layouts")
      end
    end

    context "when a _layouts directory exists in CWD" do
      setup do
        allow(File).to receive(:directory?).and_return(true)
        allow(Dir).to receive(:pwd).and_return(source_dir("blah"))
      end

      should "know to use the layout directory relative to CWD" do
        assert_equal LayoutReader.new(@site).layout_directories[0], source_dir("blah/_layouts")
      end
    end

    context "when layout directories is a string" do
      setup do
        config = Jekyll::Configuration::DEFAULTS.merge({'layouts_dir' => "_layouts2"})
        @site = fixture_site(config)
      end

      should "read layouts" do
        layouts = LayoutReader.new(@site).read
        assert_equal ["default2"], layouts.keys
      end
    end

    context "when layout directories is an array" do
      setup do
        config = Jekyll::Configuration::DEFAULTS.merge({'layouts_dir' => ["_layouts2", "_layouts3"]})
        @site = fixture_site(config)
      end

      should "read layouts" do
        layouts = LayoutReader.new(@site).read
        assert_equal ["default2", "default3"].sort, layouts.keys.sort
      end
    end
  end
end
