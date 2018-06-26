# frozen_string_literal: true

require "helper"

class TestFrontMatterDefaults < JekyllUnitTest
  context "A site with full front matter defaults" do
    setup do
      @site = fixture_site({
        "defaults" => [{
          "scope"  => {
            "path" => "contacts",
            "type" => "page",
          },
          "values" => {
            "key" => "val",
          },
        },],
      })
      @output = capture_output { @site.process }
      @affected = @site.pages.find { |page| page.relative_path == "contacts/bar.html" }
      @not_affected = @site.pages.find { |page| page.relative_path == "about.html" }
    end

    should "affect only the specified path and type" do
      assert_equal @affected.data["key"], "val"
      assert_nil @not_affected.data["key"]
    end

    should "not call Dir.glob block" do
      refute_includes @output, "Globbed Scope Path:"
    end
  end

  context "A site with full front matter defaults (glob)" do
    setup do
      @site = fixture_site({
        "defaults" => [{
          "scope"  => {
            "path" => "contacts/*.html",
            "type" => "page",
          },
          "values" => {
            "key" => "val",
          },
        },],
      })
      @output = capture_output { @site.process }
      @affected = @site.pages.find { |page| page.relative_path == "contacts/bar.html" }
      @not_affected = @site.pages.find { |page| page.relative_path == "about.html" }
    end

    should "affect only the specified path and type" do
      assert_equal @affected.data["key"], "val"
      assert_nil @not_affected.data["key"]
    end

    should "call Dir.glob block" do
      assert_includes @output, "Globbed Scope Path:"
    end
  end

  context "A site with front matter type pages and an extension" do
    setup do
      @site = fixture_site({
        "defaults" => [{
          "scope"  => {
            "path" => "index.html",
          },
          "values" => {
            "key" => "val",
          },
        },],
      })

      @site.process
      @affected = @site.pages.find { |page| page.relative_path == "index.html" }
      @not_affected = @site.pages.find { |page| page.relative_path == "about.html" }
    end

    should "affect only the specified path" do
      assert_equal @affected.data["key"], "val"
      assert_nil @not_affected.data["key"]
    end
  end

  context "A site with front matter defaults with no type" do
    setup do
      @site = fixture_site({
        "defaults" => [{
          "scope"  => {
            "path" => "win",
          },
          "values" => {
            "key" => "val",
          },
        },],
      })

      @site.process
      @affected = @site.posts.docs.find { |page| page.relative_path =~ %r!win\/! }
      @not_affected = @site.pages.find { |page| page.relative_path == "about.html" }
    end

    should "affect only the specified path and all types" do
      assert_equal @affected.data["key"], "val"
      assert_nil @not_affected.data["key"]
    end
  end

  context "A site with front matter defaults with no path and a deprecated type" do
    setup do
      @site = fixture_site({
        "defaults" => [{
          "scope"  => {
            "type" => "page",
          },
          "values" => {
            "key" => "val",
          },
        },],
      })

      @site.process
      @affected = @site.pages
      @not_affected = @site.posts.docs
    end

    should "affect only the specified type and all paths" do
      assert_equal @affected.reject { |page| page.data["key"] == "val" }, []
      assert_equal @not_affected.reject { |page| page.data["key"] == "val" },
                   @not_affected
    end
  end

  context "A site with front matter defaults with no path" do
    setup do
      @site = fixture_site({
        "defaults" => [{
          "scope"  => {
            "type" => "pages",
          },
          "values" => {
            "key" => "val",
          },
        },],
      })
      @site.process
      @affected = @site.pages
      @not_affected = @site.posts.docs
    end

    should "affect only the specified type and all paths" do
      assert_equal @affected.reject { |page| page.data["key"] == "val" }, []
      assert_equal @not_affected.reject { |page| page.data["key"] == "val" },
                   @not_affected
    end
  end

  context "A site with front matter defaults with no path or type" do
    setup do
      @site = fixture_site({
        "defaults" => [{
          "scope"  => {
          },
          "values" => {
            "key" => "val",
          },
        },],
      })
      @site.process
      @affected = @site.pages
      @not_affected = @site.posts
    end

    should "affect all types and paths" do
      assert_equal @affected.reject { |page| page.data["key"] == "val" }, []
      assert_equal @not_affected.reject { |page| page.data["key"] == "val" }, []
    end
  end

  context "A site with front matter defaults with no scope" do
    setup do
      @site = fixture_site({
        "defaults" => [{
          "values" => {
            "key" => "val",
          },
        },],
      })
      @site.process
      @affected = @site.pages
      @not_affected = @site.posts
    end

    should "affect all types and paths" do
      assert_equal @affected.reject { |page| page.data["key"] == "val" }, []
      assert_equal @not_affected.reject { |page| page.data["key"] == "val" }, []
    end
  end

  context "A site with front matter defaults with quoted date" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults"    => [{
          "values" => {
            "date" => "2015-01-01 00:00:01",
          },
        },],
      }))
    end

    should "not raise error" do
      @site.process
    end

    should "parse date" do
      @site.process
      date = Time.parse("2015-01-01 00:00:01")
      assert(@site.pages.find { |page| page.data["date"] == date })
      assert(@site.posts.find { |page| page.data["date"] == date })
    end
  end
end
