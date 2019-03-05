# frozen_string_literal: true

require "helper"

class TestThemeAssetsReaderInheritance < JekyllUnitTest
  def setup
    @site = fixture_site(
      "theme"       => "test-theme-inheritance",
      "theme-color" => "black"
    )
    assert @site.theme
  end

  def assert_file_with_relative_path(haystack, relative_path)
    assert haystack.any? { |f|
      f.relative_path == relative_path
    }, "Site should read in the #{relative_path} file, " \
      "but it was not found in #{haystack.inspect}"
  end

  def refute_file_with_relative_path(haystack, relative_path)
    refute haystack.any? { |f|
      f.relative_path == relative_path
    }, "Site should not have read in the #{relative_path} file, " \
      "but it was found in #{haystack.inspect}"
  end

  context "with a valid theme using theme inheritance" do
    should "read all assets from child and parent themes" do
      @site.reset
      ThemeAssetsReader.new(@site).read
      # This is from the child theme
      assert_file_with_relative_path @site.static_files, "/assets/another.js"
      # These are from the parent theme
      assert_file_with_relative_path @site.static_files, "/assets/img/logo.png"
      assert_file_with_relative_path @site.pages, "assets/style.scss"
    end

    should "convert pages" do
      @site.process

      file = @site.pages.find { |f| f.relative_path == "assets/style.scss" }
      refute_nil file
      assert_equal @site.in_dest_dir("assets/style.css"), file.destination(@site.dest)
      assert_includes file.output, ".sample {\n  color: black; }"
    end

    should "use layout from child theme before considering parent layouts" do
      @site.process

      file = @site.pages.find { |f| f.relative_path == "assets/layout_tests/override.html" }
      refute_nil file
      assert_includes file.output, "override.html from test-theme-inheritance"
    end

    should "use layout from parent theme if necessary" do
      @site.process

      file = @site.pages.find { |f| f.relative_path == "assets/layout_tests/test-layout.html" }
      refute_nil file
      assert_includes file.output, "test-layout.html from test-theme"
    end
  end

  context "with a valid theme using inheritance without an assets dir" do
    should "not read any assets" do
      site = fixture_site("theme" => "test-theme-inheritance")
      allow(site.theme).to receive(:assets_path).and_return(nil)
      ThemeAssetsReader.new(site).read
      # This is from the child theme
      refute_file_with_relative_path @site.pages, "assets/another.js"
      # These are from the parent theme
      refute_file_with_relative_path site.static_files, "/assets/img/logo.png"
      refute_file_with_relative_path site.pages, "assets/style.scss"
    end
  end
end
