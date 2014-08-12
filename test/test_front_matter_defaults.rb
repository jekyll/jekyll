require 'helper'

class TestFrontMatterDefaults < Test::Unit::TestCase

  context "A site with full front matter defaults" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "scope" => {
            "path" => "contacts",
            "type" => "page"
          },
          "values" => {
            "key" => "val"
          }
        }]
      }))
      @site.process
      @affected = @site.pages.find { |page| page.relative_path == "/contacts/bar.html" }
      @not_affected = @site.pages.find { |page| page.relative_path == "about.html" }
    end

    should "affect only the specified path and type" do
      assert_equal @affected.data["key"], "val"
      assert_equal @not_affected.data["key"], nil
    end
  end

  context "A site with front matter defaults with no type" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "scope" => {
            "path" => "win"
          },
          "values" => {
            "key" => "val"
          }
        }]
      }))
      @site.process
      @affected = @site.posts.find { |page| page.relative_path =~ /^\/win/ }
      @not_affected = @site.pages.find { |page| page.relative_path == "about.html" }
    end

    should "affect only the specified path and all types" do
      assert_equal @affected.data["key"], "val"
      assert_equal @not_affected.data["key"], nil
    end
  end

  context "A site with front matter defaults with no path and a deprecated type" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "scope" => {
            "type" => "page"
          },
          "values" => {
            "key" => "val"
          }
        }]
      }))
      @site.process
      @affected = @site.pages
      @not_affected = @site.posts
    end

    should "affect only the specified type and all paths" do
      assert_equal @affected.reject { |page| page.data["key"] == "val" }, []
      assert_equal @not_affected.reject { |page| page.data["key"] == "val" }, @not_affected
    end
  end

  context "A site with front matter defaults with no path" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "scope" => {
            "type" => "pages"
          },
          "values" => {
            "key" => "val"
          }
        }]
      }))
      @site.process
      @affected = @site.pages
      @not_affected = @site.posts
    end

    should "affect only the specified type and all paths" do
      assert_equal @affected.reject { |page| page.data["key"] == "val" }, []
      assert_equal @not_affected.reject { |page| page.data["key"] == "val" }, @not_affected
    end
  end

  context "A site with front matter defaults with no path or type" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "scope" => {
          },
          "values" => {
            "key" => "val"
          }
        }]
      }))
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
      @site = Site.new(Jekyll.configuration({
        "source"      => source_dir,
        "destination" => dest_dir,
        "defaults" => [{
          "values" => {
            "key" => "val"
          }
        }]
      }))
      @site.process
      @affected = @site.pages
      @not_affected = @site.posts
    end

    should "affect all types and paths" do
      assert_equal @affected.reject { |page| page.data["key"] == "val" }, []
      assert_equal @not_affected.reject { |page| page.data["key"] == "val" }, []
    end
  end

end
