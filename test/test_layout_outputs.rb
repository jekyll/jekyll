# frozen_string_literal: true

require "helper"
require "tmpdir"

class TestLayoutOutputs < JekyllUnitTest
  def setup
    @source = Dir.mktmpdir("jekyll-layout-outputs")
    @destination = File.join(@source, "_site")
    write("_layouts/event.html", "HTML {{ content }}")
    write("_layouts/event.json", "{{ content | strip_html | strip | jsonify }}")
    write("index.md", "---\nlayout: event\n---\n**Hello**")
  end

  def teardown
    FileUtils.remove_entry(@source)
  end

  def test_independent_outputs_share_converted_content_and_preserve_primary_url
    site = build

    assert_equal "HTML <p><strong>Hello</strong></p>\n", output("index.html")
    assert_equal '"Hello"', output("index.json")
    assert_equal "/", site.pages.first.url
    assert_equal output("index.html"), site.pages.first.output
    assert_equal ["event"], site.layouts.keys
    assert_equal [".html", ".json"], site.layout_variants["event"].keys.sort
  end

  def test_posts_and_output_collections_write_alternate_formats
    write("_posts/2020-01-01-first.md", "---\nlayout: event\n---\nPost")
    write("_notes/note.md", "---\nlayout: event\n---\nNote")

    build("collections" => { "notes" => { "output" => true } })

    assert_equal '"Post"', output("2020/01/01/first.json")
    assert_equal '"Note"', output("notes/note.json")
  end

  def test_pretty_permalink_keeps_alternate_files_in_the_same_directory
    write("index.md", "---\nlayout: event\npermalink: /hello/\n---\nHello")

    build

    assert_equal '"Hello"', output("hello/index.json")
    assert_path_exists File.join(@destination, "hello/index.html")
  end

  def test_permalink_extension_selects_matching_primary_layout
    write("index.md", "---\nlayout: event\npermalink: /hello.json\n---\nHello")
    site = build

    assert_equal '"Hello"', output("hello.json")
    assert_equal '"Hello"', site.pages.first.output
    assert_equal "/hello.json", site.pages.first.url
    assert_equal "HTML <p>Hello</p>\n", output("hello.html")
  end

  def test_nested_layouts_prefer_the_current_format_and_keep_layout_data_separate
    write("_layouts/event.html", "---\nlayout: base\nlabel: html\n---\n{{ layout.label }}")
    write("_layouts/event.json", "---\nlayout: base\nlabel: json\n---\n{{ layout.label }}")
    write("_layouts/base.html", "HTML [{{ content }}] {{ layout.label }}")
    write("_layouts/base.json", "JSON [{{ content }}] {{ layout.label }}")

    build

    assert_equal "HTML [html] html", output("index.html")
    assert_equal "JSON [json] json", output("index.json")
  end

  def test_parent_without_a_matching_format_uses_the_primary_parent
    write("_layouts/event.json", "---\nlayout: base\n---\nJSON")
    write("_layouts/base.html", "BASE {{ content }}")

    build

    assert_equal "BASE JSON", output("index.json")
  end

  def test_layout_cycles_terminate_independently_for_each_format
    write("_layouts/event.html", "---\nlayout: event\n---\nHTML")
    write("_layouts/event.json", "---\nlayout: event\n---\nJSON")

    build

    assert_equal "HTML", output("index.html")
    assert_equal "JSON", output("index.json")
  end

  def test_multiple_non_html_formats_use_the_selected_layout_extension
    File.unlink(File.join(@source, "_layouts/event.html"))
    write("_layouts/event.xml", "XML {{ content }}")

    build

    assert_equal '"Hello"', output("index.json")
    assert_equal "XML <p><strong>Hello</strong></p>\n", output("index.xml")
    refute_path_exists File.join(@destination, "index.html")
  end

  def test_single_non_html_layout_keeps_existing_output_extension
    File.unlink(File.join(@source, "_layouts/event.html"))

    build

    assert_equal '"Hello"', output("index.html")
    refute_path_exists File.join(@destination, "index.json")
  end

  def test_pages_without_layouts_and_assets_do_not_gain_outputs
    write("plain.md", "---\nlayout: null\n---\nPlain")
    write("style.scss", "---\nlayout: event\n---\na { color: red; }")

    build

    assert_path_exists File.join(@destination, "plain.html")
    assert_path_exists File.join(@destination, "style.css")
    refute_path_exists File.join(@destination, "plain.json")
    refute_path_exists File.join(@destination, "style.json")
  end

  def test_cleaner_retains_outputs_then_removes_obsolete_formats
    build
    write("_layouts/event.xml", "XML")
    build
    assert_path_exists File.join(@destination, "index.json")
    assert_path_exists File.join(@destination, "index.xml")

    File.unlink(File.join(@source, "_layouts/event.xml"))
    build
    refute_path_exists File.join(@destination, "index.xml")
    assert_path_exists File.join(@destination, "index.json")
  end

  def test_incremental_build_retains_unchanged_alternate_outputs
    build("incremental" => true)
    before = File.mtime(File.join(@destination, "index.json"))
    site = build("incremental" => true)

    assert_equal '"Hello"', output("index.json")
    assert_equal before, File.mtime(File.join(@destination, "index.json"))
    refute site.regenerator.regenerate?(site.pages.first)
  end

  def test_incremental_build_restores_a_missing_alternate_output
    build("incremental" => true)
    File.unlink(File.join(@destination, "index.json"))

    build("incremental" => true)

    assert_equal '"Hello"', output("index.json")
  end

  def test_incremental_build_updates_changed_alternate_layouts
    build("incremental" => true)
    write("_layouts/event.json", "CHANGED")

    build("incremental" => true)

    assert_equal "CHANGED", output("index.json")
  end

  def test_incremental_build_discovers_added_and_removed_formats
    build("incremental" => true)
    write("_layouts/event.xml", "XML")
    build("incremental" => true)
    assert_equal "XML", output("index.xml")

    File.unlink(File.join(@source, "_layouts/event.xml"))
    build("incremental" => true)
    refute_path_exists File.join(@destination, "index.xml")
    assert_equal '"Hello"', output("index.json")
  end

  def test_site_overrides_theme_layouts_per_extension
    theme = File.join(@source, "theme-layouts")
    write("theme-layouts/event.html", "THEME HTML")
    write("theme-layouts/event.xml", "THEME XML")
    site = new_site
    reader = LayoutReader.new(site)
    allow(reader).to receive(:theme_layout_directory).and_return(theme)
    site.layouts = reader.read

    assert_equal "HTML {{ content }}", site.layouts["event"].content
    assert_equal "THEME XML", site.layout_variants["event"][".xml"].content
  end

  def test_removed_format_does_not_keep_forcing_incremental_regeneration
    build("incremental" => true)
    File.unlink(File.join(@source, "_layouts/event.json"))
    build("incremental" => true)

    site = build("incremental" => true)

    refute site.regenerator.regenerate?(site.pages.first)
    refute_path_exists File.join(@destination, "index.json")
  end

  def test_explicit_renderer_layouts_do_not_pick_unrelated_formats
    site = build
    page = site.pages.first
    page.content = "Content"
    page.renderer.layouts = { "event" => site.layout_variants["event"][".json"] }

    assert_equal '"Content"', page.renderer.run
    assert_empty page.layout_outputs
  end

  def test_plugin_replacing_a_layout_is_respected
    site = build
    write("_layouts/custom.html", "CUSTOM")
    site.layouts["event"] = Layout.new(site, File.join(@source, "_layouts"), "custom.html")

    assert_equal "CUSTOM", site.pages.first.renderer.run
    assert_empty site.pages.first.layout_outputs
  end

  def test_doctor_detects_conflicts_with_alternate_outputs
    write("index.json", "static JSON")
    site = build
    conflicts = Commands::Doctor.send(:destination_map, site)

    assert_equal 2, conflicts[File.join(@destination, "index.json")].size
  end

  def test_plugin_replacing_a_parent_layout_applies_to_every_format
    write("_layouts/event.html", "---\nlayout: base\n---\nHTML")
    write("_layouts/event.json", "---\nlayout: base\n---\nJSON")
    write("_layouts/base.html", "BASE HTML")
    write("_layouts/base.json", "BASE JSON")
    write("_layouts/custom.html", "CUSTOM {{ content }}")
    site = build
    site.layouts["base"] = Layout.new(site, File.join(@source, "_layouts"), "custom.html")
    page = site.pages.first

    assert_equal "CUSTOM HTML", page.renderer.run
    assert_equal "CUSTOM JSON", page.layout_outputs[".json"]
  end

  def test_explicit_renderer_layouts_do_not_select_unrelated_parent_formats
    write("_layouts/event.json", "---\nlayout: base\n---\nJSON")
    write("_layouts/base.html", "BASE HTML {{ content }}")
    write("_layouts/base.json", "BASE JSON {{ content }}")
    site = build
    page = site.pages.first
    page.renderer.layouts = { "event" => site.layout_variants["event"][".json"] }

    assert_equal "BASE HTML JSON", page.renderer.run
    assert_empty page.layout_outputs
  end

  def test_doctor_detects_alternate_outputs_differing_only_by_case
    write("INDEX.JSON", "---\n---\nOTHER")
    site = build

    assert Commands::Doctor.urls_only_differ_by_case(site)
  end

  private

  def write(path, content)
    target = File.join(@source, path)
    FileUtils.mkdir_p(File.dirname(target))
    File.write(target, content)
  end

  def output(path)
    File.read(File.join(@destination, path))
  end

  def build(overrides = {})
    new_site(overrides).tap(&:process)
  end

  def new_site(overrides = {})
    configuration = Jekyll.configuration({
      "source"      => @source,
      "destination" => @destination,
      "quiet"       => true,
    }.merge(overrides))
    Jekyll::Site.new(configuration)
  end
end
