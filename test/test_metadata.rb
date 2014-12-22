require 'helper'

class TestMetadata < Test::Unit::TestCase
  context "The site metadata" do
    setup do
      FileUtils.rm_rf(source_dir(".jekyll-metadata"))

      @site = Site.new(Jekyll.configuration({
        "source" => source_dir,
        "destination" => dest_dir
      }))

      @site.process
      @path = @site.in_source_dir(@site.pages.first.path)
      @metadata = @site.metadata
    end

    should "store modification times" do
      assert_equal File.mtime(@path), @metadata.metadata[@path]["mtime"]
    end

    should "cache processed entries" do
      assert @metadata.cache[@path]
    end

    should "write to the metadata file" do
      @metadata.clear
      @metadata.add(@path)
      @metadata.write
      assert File.file?(source_dir(".jekyll-metadata"))
    end

    should "read from the metadata file" do
      @metadata = Metadata.new(@site)
      assert_equal File.mtime(@path), @metadata.metadata[@path]["mtime"]
    end

    # Methods

    should "be able to add a path to the metadata" do
      @metadata.clear
      @metadata.add(@path)
      assert_equal File.mtime(@path), @metadata.metadata[@path]["mtime"]
      assert_equal [], @metadata.metadata[@path]["deps"]
      assert @metadata.cache[@path]
    end

    should "return true on nonexistent path" do
      @metadata.clear
      assert @metadata.add("/bogus/path.md")
      assert @metadata.regenerate?("/bogus/path.md")
    end

    should "be able to force a path to regenerate" do
      @metadata.clear
      @metadata.force(@path)
      assert @metadata.cache[@path]
      assert @metadata.regenerate?(@path)
    end

    should "be able to clear metadata and cache" do
      @metadata.clear
      @metadata.add(@path)
      assert_equal 1, @metadata.metadata.length
      assert_equal 1, @metadata.cache.length
      @metadata.clear
      assert_equal 0, @metadata.metadata.length
      assert_equal 0, @metadata.cache.length
    end

    should "not regenerate a path if it is not modified" do
      @metadata.clear
      @metadata.add(@path)
      @metadata.write
      @metadata = Metadata.new(@site)

      assert !@metadata.regenerate?(@path)
    end

    should "not regenerate if path in cache is false" do
      @metadata.clear
      @metadata.add(@path)
      @metadata.write
      @metadata = Metadata.new(@site)

      assert !@metadata.regenerate?(@path)
      assert !@metadata.cache[@path]
      assert !@metadata.regenerate?(@path)
    end

    should "regenerate if path in not in metadata" do
      @metadata.clear
      @metadata.add(@path)

      assert @metadata.regenerate?(@path)
    end

    should "regenerate if path in cache is true" do
      @metadata.clear
      @metadata.add(@path)

      assert @metadata.regenerate?(@path)
      assert @metadata.cache[@path]
      assert @metadata.regenerate?(@path)
    end

    should "regenerate if file is modified" do
      @metadata.clear
      @metadata.add(@path)
      @metadata.metadata[@path]["mtime"] = Time.at(0)
      @metadata.write
      @metadata = Metadata.new(@site)

      assert_not_same File.mtime(@path), @metadata.metadata[@path]["mtime"]
      assert @metadata.regenerate?(@path)
    end

    should "regenerate if dependency is modified" do
      @metadata.clear
      @metadata.add(@path)
      @metadata.write
      @metadata = Metadata.new(@site)

      @metadata.add_dependency(@path, "new.dependency")
      assert_equal ["new.dependency"], @metadata.metadata[@path]["deps"]
      assert @metadata.regenerate?("new.dependency")
      assert @metadata.regenerate?(@path)
    end

    should "regenerate everything if metadata is disabled" do
      @site.config["full_rebuild"] = true
      @metadata.clear
      @metadata.add(@path)
      @metadata.write
      @metadata = Metadata.new(@site)

      assert @metadata.regenerate?(@path)
    end
  end
end
