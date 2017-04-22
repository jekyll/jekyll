require "helper"

class TestSiteDrop < JekyllUnitTest
  context "a site drop" do
    setup do
      @site = fixture_site({
        "collections" => ["thanksgiving"],
      })
      @site.process
      @drop = @site.to_liquid.site
    end

    should "respond to `key?`" do
      assert @drop.respond_to?(:key?)
    end

    should "find a key if it's in the collection of the drop" do
      assert @drop.key?("thanksgiving")
    end

    should "return those plugins which are enabled" do
      enabled_plugins = %w(jemojii jekyll_test_plugin)
      allow(@site.plugin_manager).to receive(:enabled_plugins).and_return(enabled_plugins)

      assert @drop.plugins, enabled_plugins
    end
  end
end
