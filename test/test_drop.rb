require "helper"

class TestDrop < JekyllUnitTest
  context "a document drop" do
    setup do
      @site = fixture_site({
        "collections" => ["methods"]
      })
      @site.process
      @document = @site.collections["methods"].docs.detect do |d|
        d.relative_path == "_methods/configuration.md"
      end
      @drop = @document.to_liquid
    end

    should "raise KeyError if key is not found and no default provided" do
      assert_raises KeyError do
        @drop.fetch("not_existing_key")
      end
    end

    should "fetch value without default" do
      assert_equal "Jekyll.configuration", @drop.fetch("title")
    end

    should "fetch default if key is not found" do
      assert_equal "default", @drop.fetch("not_existing_key", "default")
    end

    should "fetch default boolean value correctly" do
      assert_equal false, @drop.fetch("bar", false)
    end

    should "fetch default value from block if key is not found" do
      assert_equal "default bar", @drop.fetch("bar") { |el| "default #{el}" }
    end

    should "fetch default value from block first if both argument and block given" do
      assert_equal "baz", @drop.fetch("bar", "default") { "baz" }
    end
  end
end
