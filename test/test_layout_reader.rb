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

    context "when no _layouts directory exists in CWD" do
      should "know to use the layout directory relative to the site source" do
        assert_equal LayoutReader.new(@site).layout_directory, source_dir("_layouts")
      end
    end

    context "when a _layouts directory exists in CWD" do
      setup do
        stub(File).directory? { true }
        stub(Dir).pwd { source_dir("blah") }
      end

      should "know to use the layout directory relative to CWD" do
        assert_equal LayoutReader.new(@site).layout_directory, source_dir("blah/_layouts")
      end
    end
  end
end
