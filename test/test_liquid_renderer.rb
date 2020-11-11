# frozen_string_literal: true

require "helper"

class TestLiquidRenderer < JekyllUnitTest
  context "profiler" do
    setup do
      @site = Site.new(site_configuration)
      @renderer = @site.liquid_renderer
    end

    should "return a table with profiling results" do
      @site.process

      output = @renderer.stats_table

      # rubocop:disable Layout/LineLength
      expected = [
        %r!^\| Filename\s+|\s+Count\s+|\s+Bytes\s+|\s+Time$!,
        %r!^\+(?:-+\+){4}$!,
        %r!^\|_posts/2010-01-09-date-override\.markdown\s+|\s+\d+\s+|\s+\d+\.\d{2}K\s+|\s+\d+\.\d{3}$!,
      ]
      # rubocop:enable Layout/LineLength

      expected.each do |regexp|
        assert_match regexp, output
      end
    end

    should "normalize paths of rendered items" do
      site = fixture_site("theme" => "test-theme")
      MockRenderer = Class.new(Jekyll::LiquidRenderer) { public :normalize_path }
      renderer = MockRenderer.new(site)

      assert_equal "feed.xml", renderer.normalize_path("/feed.xml")
      assert_equal(
        "_layouts/post.html",
        renderer.normalize_path(site.in_source_dir("_layouts", "post.html"))
      )
      assert_equal(
        "test-theme/_layouts/page.html",
        renderer.normalize_path(site.in_theme_dir("_layouts", "page.html"))
      )
      assert_equal(
        "my_plugin-0.1.0/lib/my_plugin/layout.html",
        renderer.normalize_path(
          "/users/jo/blog/vendor/bundle/ruby/2.4.0/gems/my_plugin-0.1.0/lib/my_plugin/layout.html"
        )
      )
      assert_equal(
        "test_plugin-0.1.0/lib/test_plugin/layout.html",
        renderer.normalize_path(
          "C:/Ruby2.4/lib/ruby/gems/2.4.0/gems/test_plugin-0.1.0/lib/test_plugin/layout.html"
        )
      )
    end
  end
end
