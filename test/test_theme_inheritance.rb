# frozen_string_literal: true

require "helper"
require "tmpdir"

class TestThemeInheritance < JekyllUnitTest
  def setup
    @temporary_root = Dir.mktmpdir("jekyll-theme-inheritance-")
    @source = File.join(@temporary_root, "source")
    @destination = File.join(@temporary_root, "destination")
    FileUtils.mkdir_p(@source)
  end

  def teardown
    FileUtils.remove_entry(@temporary_root) if @temporary_root
  end

  def test_parent_theme_dependency_does_not_require_a_ruby_entrypoint
    site = inherited_site
    assert_equal %w(test-child-theme test-parent-theme),
                 site.theme.inheritance_chain.map(&:name)
  end

  def test_a_regular_theme_still_has_only_one_layer
    assert_equal ["test-theme"], Theme.new("test-theme").inheritance_chain.map(&:name)
  end

  def test_builds_parent_layout_include_asset_data_and_configuration
    write_source("index.html", <<~CONTENT)
      ---
      layout: inherited
      ---
      {% include shared.html %}{% include parent-only.html %}
    CONTENT
    write_source("shared.html", "---\nlayout: shared\n---\ncontent")
    site = inherited_site
    site.process

    assert_includes output("index.html"), "parent-layout:"
    assert_includes output("index.html"), "child-shared-include"
    assert_includes output("index.html"), "parent-only-include"
    assert_includes output("shared.html"), "child-shared-layout:"
    assert_equal "/_layouts/inherited.html", site.layouts["inherited"].relative_path
  end

  def test_inherits_static_and_rendered_assets
    inherited_site.process
    assert_equal "parent-only-asset", output("assets/parent-only.txt").strip
    assert_equal "child-shared-asset", output("assets/shared.txt").strip
    assert_includes output("assets/rendered.html"), "parent-page:child-shared-include"
  end

  def test_merges_parent_data_and_configuration_with_child_precedence
    site = inherited_site
    site.read
    assert_equal "parent-data", site.data["settings"]["parent_only"]
    assert_equal "child-data", site.data["settings"]["shared"]
    assert_equal "parent-config", site.config["theme_options"]["parent_only"]
    assert_equal "child-config", site.config["theme_options"]["shared"]
    assert_equal @source, site.config["source"]
  end

  def test_local_files_and_nested_data_override_child_and_parent
    write_source("index.html", "---\nlayout: shared\n---\n{% include shared.html %}")
    write_source("_layouts/shared.html", "---\n---\nlocal-layout:{{ content }}")
    write_source("_includes/shared.html", "local-include")
    write_source("assets/shared.txt", "local-asset")
    write_source("_data/settings.yml", "shared: local-data\nlocal_only: local-data\n")
    site = inherited_site("theme_options" => { "shared" => "local-config" })
    site.process

    assert_includes output("index.html"), "local-layout:local-include"
    assert_equal "local-asset", output("assets/shared.txt")
    assert_equal({ "parent_only" => "parent-data", "child_only" => "child-data",
                   "shared" => "local-data", "local_only" => "local-data", }, site.data["settings"])
    assert_equal "local-config", site.config["theme_options"]["shared"]
    assert_equal "child-config", site.config["theme_options"]["child_only"]
  end

  def test_sass_fallback_and_child_precedence_in_normal_and_safe_mode
    [false, true].each do |safe|
      inherited_site("safe" => safe).process
      css = output("assets/inherited.css")
      assert_includes css, "color: blue"
      assert_includes css, "width: 12px"
    end
  end

  def test_local_sass_precedes_both_themes
    write_source("_sass/palette.scss", "$theme-color: green;")
    inherited_site.process
    assert_includes output("assets/inherited.css"), "color: green"
  end

  def test_ignoring_theme_configuration_keeps_file_inheritance
    site = inherited_site("ignore_theme_config" => true)
    site.read
    assert_nil site.config["theme_options"]
    assert site.layouts.key?("inherited")
  end

  def test_asset_precedence_also_applies_across_static_files_and_pages
    inherited_site.process
    assert_equal "child-static", output("assets/page-to-static.html").strip
    assert_equal "child-page", output("assets/static-to-page.html").strip
  end

  def test_parent_themes_can_themselves_inherit
    spec = Gem::Specification.find_by_name("test-parent-theme")
    allow(spec).to receive(:metadata).and_return("jekyll:parent_theme" => "test-theme")
    allow(spec).to receive(:runtime_dependencies).and_return([Gem::Dependency.new("test-theme")])
    assert_equal %w(test-child-theme test-parent-theme test-theme),
                 inherited_site.theme.inheritance_chain.map(&:name)
  end

  def test_rejects_an_empty_parent_declaration
    spec = Gem::Specification.find_by_name("test-child-theme")
    allow(spec).to receive(:metadata).and_return("jekyll:parent_theme" => " ")
    error = assert_raises(Errors::FatalException) { inherited_site }
    assert_includes error.message, "non-empty gem name"
  end

  def test_profiler_normalizes_every_layer_and_each_site_source
    renderer_class = Class.new(LiquidRenderer) { public :normalize_path }
    site = inherited_site
    renderer = renderer_class.new(site)
    site.theme.inheritance_chain.each do |layer|
      assert_equal "#{layer.basename}/_layouts/page.html",
                   renderer.normalize_path(layer.in_theme_dir("_layouts", "page.html"))
    end
    assert_equal "index.html", renderer.normalize_path(File.join(@source, "index.html"))
    other_site = fixture_site("theme" => "test-theme")
    other_renderer = renderer_class.new(other_site)
    assert_equal "test-theme/_layouts/page.html",
                 other_renderer.normalize_path(other_site.in_theme_dir("_layouts", "page.html"))
    assert_equal "index.html",
                 other_renderer.normalize_path(other_site.in_source_dir("index.html"))
  end

  def test_requires_the_parent_to_be_an_explicit_runtime_dependency
    spec = Gem::Specification.find_by_name("test-child-theme")
    allow(spec).to receive(:runtime_dependencies).and_return([])
    error = assert_raises(Errors::FatalException) { inherited_site }
    assert_includes error.message, "runtime dependency"
  end

  def test_rejects_an_uninstalled_parent_with_a_useful_error
    spec = Gem::Specification.find_by_name("test-child-theme")
    allow(spec).to receive(:metadata).and_return("jekyll:parent_theme" => "missing-parent-theme")
    dependency = Gem::Dependency.new("missing-parent-theme")
    allow(spec).to receive(:runtime_dependencies).and_return([dependency])
    error = assert_raises(Errors::MissingDependencyException) { inherited_site }
    assert_includes error.message, "missing-parent-theme"
  end

  def test_rejects_parent_version_mismatches
    spec = Gem::Specification.find_by_name("test-child-theme")
    dependency = Gem::Dependency.new("test-parent-theme", ">= 9.0")
    allow(spec).to receive(:runtime_dependencies).and_return([dependency])
    error = assert_raises(Errors::MissingDependencyException) { inherited_site }
    assert_includes error.message, "test-parent-theme"
  end

  def test_rejects_cycles_instead_of_recursing_forever
    spec = Gem::Specification.find_by_name("test-parent-theme")
    allow(spec).to receive(:metadata).and_return("jekyll:parent_theme" => "test-child-theme")
    dependency = Gem::Dependency.new("test-child-theme")
    allow(spec).to receive(:runtime_dependencies).and_return([dependency])
    error = assert_raises(Errors::FatalException) { inherited_site }
    assert_includes error.message, "test-child-theme -> test-parent-theme -> test-child-theme"
  end

  private

  def output(relative_path)
    File.read(File.join(@destination, relative_path))
  end

  def inherited_site(overrides = {})
    Site.new(Configuration.from(build_configs({
      "source" => @source, "destination" => @destination, "theme" => "test-child-theme",
      "strict_front_matter" => true,
      "sass" => { "sourcemap" => "never", "style" => "expanded" },
    }.merge(overrides))))
  end

  def write_source(relative_path, content)
    path = File.join(@source, relative_path)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, content)
  end
end
