# frozen_string_literal: true

require "helper"

class TestLocalTheme < JekyllUnitTest
  def setup
    @theme_root = source_dir("_themes", "local-theme")
    FileUtils.mkdir_p(File.join(@theme_root, "_layouts"))
    FileUtils.mkdir_p(File.join(@theme_root, "_includes"))
    FileUtils.mkdir_p(File.join(@theme_root, "_data"))
    File.write(File.join(@theme_root, "_layouts", "local.html"), "Local: {{ content }}")
  end

  def teardown
    FileUtils.rm_rf(source_dir("_themes"))
    FileUtils.rm_rf(source_dir("_theme"))
  end

  context "resolving a theme from the site's source" do
    should "return a LocalTheme when a matching folder exists in _themes" do
      theme = Jekyll::LocalTheme.from_source(source_dir, "local-theme")
      assert_instance_of Jekyll::LocalTheme, theme
      assert_equal "local-theme", theme.name
      assert_equal File.realpath(@theme_root), theme.root
    end

    should "normalize the theme name like gem-based themes do" do
      theme = Jekyll::LocalTheme.from_source(source_dir, " Local-Theme ")
      assert_instance_of Jekyll::LocalTheme, theme
      assert_equal "local-theme", theme.name
    end

    should "support resolving through a Site instance" do
      site = fixture_site("theme" => "local-theme")
      theme = Jekyll::LocalTheme.from_site(site, "local-theme")
      assert_instance_of Jekyll::LocalTheme, theme
      assert_equal File.realpath(@theme_root), theme.root
    end

    should "return nil when there is no matching folder in _themes" do
      assert_nil Jekyll::LocalTheme.from_source(source_dir, "other-theme")
    end

    should "return nil for names that would escape the _themes folder" do
      assert_nil Jekyll::LocalTheme.from_source(source_dir, "../test-theme")
      assert_nil Jekyll::LocalTheme.from_source(source_dir, "foo/bar")
      assert_nil Jekyll::LocalTheme.from_source(source_dir, "")
    end

    should "fall back to a single _theme directory" do
      FileUtils.rm_rf(source_dir("_themes"))
      single_theme = source_dir("_theme")
      FileUtils.mkdir_p(File.join(single_theme, "_sass"))
      site = fixture_site("theme" => "single-theme")

      theme = Jekyll::LocalTheme.from_site(site, "single-theme")

      assert_equal File.realpath(single_theme), theme.root
      assert_equal File.join(theme.root, "_sass"), theme.sass_path
    end

    should "have no version and no runtime dependencies" do
      theme = Jekyll::LocalTheme.from_source(source_dir, "local-theme")
      assert_nil theme.version
      assert_equal [], theme.runtime_dependencies
    end
  end

  context "path generation" do
    setup do
      @theme = Jekyll::LocalTheme.from_source(source_dir, "local-theme")
    end

    should "know the layouts path" do
      assert_equal File.realpath(File.join(@theme_root, "_layouts")), @theme.layouts_path
    end

    should "know the includes path" do
      assert_equal File.realpath(File.join(@theme_root, "_includes")), @theme.includes_path
    end

    should "know the data path" do
      assert_equal File.realpath(File.join(@theme_root, "_data")), @theme.data_path
    end

    should "return nil for paths that don't exist" do
      assert_nil @theme.sass_path
      assert_nil @theme.assets_path
    end
  end

  context "a site configured with a local theme" do
    should "set a LocalTheme as the site's theme" do
      site = fixture_site("theme" => "local-theme")
      assert_instance_of Jekyll::LocalTheme, site.theme
      assert_equal "local-theme", site.theme.name
      assert_equal File.realpath(@theme_root), site.theme.root
    end

    should "add the theme's includes path to the site's load paths" do
      site = fixture_site("theme" => "local-theme")
      expected = [source_dir("_includes"), File.realpath(File.join(@theme_root, "_includes"))]
      assert_equal expected, site.includes_load_paths
    end

    should "read layouts from the local theme" do
      site = fixture_site("theme" => "local-theme")
      layouts = LayoutReader.new(site).read
      assert layouts.key?("local"), "Expected the local theme's layout to be read"
    end

    should "load the config file from the local theme" do
      File.write(File.join(@theme_root, "_config.yml"), "local_theme_marker: true\n")
      site = fixture_site("theme" => "local-theme")
      assert site.config["local_theme_marker"]
    end

    should "prefer an installed gem over a local folder of the same name" do
      FileUtils.mkdir_p(source_dir("_themes", "test-theme", "_layouts"))
      site = fixture_site("theme" => "test-theme")
      assert_instance_of Jekyll::Theme, site.theme
      refute_instance_of Jekyll::LocalTheme, site.theme
      assert_equal theme_dir, site.theme.root
    ensure
      FileUtils.rm_rf(source_dir("_themes", "test-theme"))
    end

    should "raise MissingDependencyException when neither gem nor local theme exists" do
      assert_raises(Jekyll::Errors::MissingDependencyException) do
        fixture_site("theme" => "nonexistent-theme-xyz").reset
      end
    end
  end

  context "a theme drop for a local theme" do
    setup do
      @drop = fixture_site("theme" => "local-theme").to_liquid.theme
    end

    should "export empty gem-specific data instead of raising" do
      assert_equal "", @drop["authors"]
      assert_equal "", @drop["version"]
      assert_equal "", @drop["description"]
      assert_equal({}, @drop["metadata"])
      assert_equal [], @drop["dependencies"]
    end
  end
end
