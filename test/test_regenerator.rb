# frozen_string_literal: true

require "helper"

class TestRegenerator < JekyllUnitTest
  context "The site regenerator" do
    setup do
      FileUtils.rm_rf(source_dir(".jekyll-metadata"))

      @site = fixture_site(
        "collections" => {
          "methods" => {
            "output" => true,
          },
        }
      )

      @site.read
      @page = @site.pages.first
      @post = @site.posts.first
      @document = @site.docs_to_write.first
      @asset_file = @site.pages.find(&:asset_file?)
      @regenerator = @site.regenerator
    end

    should "regenerate documents and assets if changed or not in metadata" do
      assert @regenerator.regenerate?(@page)
      assert @regenerator.regenerate?(@post)
      assert @regenerator.regenerate?(@document)
      assert @regenerator.regenerate?(@asset_file)
    end

    should "regenerate if not changed" do
      # Process files
      @regenerator.regenerate?(@page)
      @regenerator.regenerate?(@post)
      @regenerator.regenerate?(@document)
      @regenerator.regenerate?(@asset_file)

      @regenerator.write_metadata

      # these should pass, since nothing has changed, and the
      # loop above made sure the designations exist
      assert @regenerator.regenerate?(@page)
      assert @regenerator.regenerate?(@post)
      assert @regenerator.regenerate?(@document)
    end

    should "regenerate if destination missing" do
      # Process files
      @regenerator.regenerate?(@page)
      @regenerator.regenerate?(@post)
      @regenerator.regenerate?(@document)
      @regenerator.regenerate?(@asset_file)

      @regenerator.write_metadata
      @regenerator = Regenerator.new(@site)

      # make sure the files don't actually exist
      [@page, @post, @document, @asset_file].each do |item|
        if item.respond_to?(:destination)
          dest = item.destination(@site.dest)
          File.unlink(dest) if File.exist?(dest)
        end
      end

      # while nothing has changed, the output files were not
      # generated, so they still need to be regenerated
      assert @regenerator.regenerate?(@page)
      assert @regenerator.regenerate?(@post)
      assert @regenerator.regenerate?(@document)
    end

    should "always regenerate asset files" do
      assert @regenerator.regenerate?(@asset_file)
    end

    should "always regenerate objects that don't respond to :path" do
      assert @regenerator.regenerate?(Object.new)
    end

    should "not create .jekyll-metadata" do
      refute File.file?(source_dir(".jekyll-metadata"))
    end
  end
end
