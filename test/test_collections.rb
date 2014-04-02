require 'helper'

class TestCollections < Test::Unit::TestCase

  context "with no collections specified" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "source"      => source_dir,
        "destination" => dest_dir
      }))
      @site.process
    end

    should "not contain any collections" do
      assert_nil @site.collections
    end
  end

  context "with a collection" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "collections" => ["methods"],
        "source"      => source_dir,
        "destination" => dest_dir
      }))
      @site.process
    end

    should "create a Hash on Site with the label mapped to the instance of the Collection" do
      assert @site.collections.is_a?(Hash)
      assert_not_nil @site.collections["methods"]
      assert @site.collections["methods"].is_a? Jekyll::Collection
    end

    should "collects docs in an array on the Collection object" do
      assert @site.collections["methods"].docs.is_a? Array
      @site.collections["methods"].docs.each do |doc|
        assert doc.is_a? Jekyll::Document
        assert_include %w[
          _methods/configuration.md
          _methods/sanitized_path.md
          _methods/site/generate.md
          _methods/site/initialize.md
          _methods/um_hi.md
        ], doc.relative_path
      end
    end
  end

  context "in safe mode" do
    setup do
      @site = Site.new(Jekyll.configuration({
        "collections" => ["methods"],
        "safe"        => true,
        "source"      => source_dir,
        "destination" => dest_dir
      }))
      @site.process
      @collection = @site.collections["methods"]
    end

    should "not allow symlinks" do
      assert !@collection.allowed_document?(File.join(@collection.directory, "um_hi.md"))
    end

    should "not include the symlinked file in the list of docs" do
      assert_not_include %w[_methods/um_hi.md], @collection.docs.map(&:relative_path)
    end
  end

end
