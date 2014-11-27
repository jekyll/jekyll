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
      assert_equal @metadata.metadata[@path]["mtime"], File.mtime(@path)
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
      assert_equal @metadata.metadata[@path]["mtime"], File.mtime(@path)
    end
  end
end
