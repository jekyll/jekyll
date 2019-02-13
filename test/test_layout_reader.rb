# frozen_string_literal: true

require "helper"

class TestLayoutReader < JekyllUnitTest
  context "reading layouts" do
    setup do
      config = Jekyll::Configuration::DEFAULTS.merge("source"      => source_dir,
                                                     "destination" => dest_dir)
      @site = fixture_site(config)
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
        allow(File).to receive(:directory?).and_return(true)
        allow(Dir).to receive(:pwd).and_return(source_dir("blah"))
      end

      should "ignore the layout directory in CWD and use the directory relative to site source" do
        refute_equal source_dir("blah/_layouts"), LayoutReader.new(@site).layout_directory
        assert_equal source_dir("_layouts"), LayoutReader.new(@site).layout_directory
      end
    end

    context "when a layout is a symlink" do
      setup do
        symlink_if_allowed("/etc/passwd", source_dir("_layouts", "symlink.html"))

        @site = fixture_site(
          "safe"    => true,
          "include" => ["symlink.html"]
        )
      end

      teardown do
        FileUtils.rm_f(source_dir("_layouts", "symlink.html"))
      end

      should "only read the layouts which are in the site" do
        skip_if_windows "Jekyll does not currently support symlinks on Windows."

        layouts = LayoutReader.new(@site).read

        refute layouts.key?("symlink"), "Should not read the symlinked layout"
      end
    end

    context "with a theme" do
      setup do
        symlink_if_allowed("/etc/passwd", theme_dir("_layouts", "theme-symlink.html"))
        @site = fixture_site(
          "include" => ["theme-symlink.html"],
          "theme"   => "test-theme",
          "safe"    => true
        )
      end

      teardown do
        FileUtils.rm_f(theme_dir("_layouts", "theme-symlink.html"))
      end

      should "not read a symlink'd theme" do
        skip_if_windows "Jekyll does not currently support symlinks on Windows."

        layouts = LayoutReader.new(@site).read

        refute layouts.key?("theme-symlink"), \
               "Should not read symlinked layout from theme"
      end
    end
  end
end
