# frozen_string_literal: true

require "helper"

class TestCache < JekyllUnitTest
  context "cache_dir" do
    should "be within source_dir" do
      fixture_site.process
      assert File.directory?(source_dir(".jekyll-cache", "Jekyll", "Cache"))
      assert File.directory?(source_dir(".jekyll-cache", "Jekyll", "Cache", "Jekyll--Cache"))
    end

    should "be configurable" do
      default_cache_dir = source_dir(".jekyll-cache")
      FileUtils.rm_r(default_cache_dir) if File.directory?(default_cache_dir)

      site = fixture_site("cache_dir" => ".foo-cache")
      site.process
      refute File.directory?(source_dir(".jekyll-cache", "Jekyll", "Cache"))
      refute File.directory?(source_dir(".jekyll-cache", "Jekyll", "Cache", "Jekyll--Cache"))
      assert File.directory?(source_dir(".foo-cache", "Jekyll", "Cache"))
      assert File.directory?(source_dir(".foo-cache", "Jekyll", "Cache", "Jekyll--Cache"))

      FileUtils.rm_r(source_dir(".foo-cache"))
    end
  end

  context "cache instance" do
    setup do
      @test_cache = Jekyll::Cache.new("Foo::Bar")
      fixture_site.process

      assert Jekyll::Cache.base_cache.key?("Foo::Bar")
    end

    should "write to disk by default" do
      assert @test_cache.disk_cache_enabled?
    end

    should "allow stashing and retrieving a key and its value safely" do
      @test_cache.getset("lorem") { "ipsum" }
      assert_equal "ipsum", @test_cache.getset("lorem")
      assert_equal "ipsum", @test_cache["lorem"]

      @test_cache.getset("lorem") { "foobar" }

      assert @test_cache.key?("lorem")
      refute_equal "foobar", @test_cache.getset("lorem")
      refute_equal "foobar", @test_cache["lorem"]
    end
  end
end
