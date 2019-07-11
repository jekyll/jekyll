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
        },
        "incremental" => true
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

    should "not regenerate if not changed" do
      # Process files
      @regenerator.regenerate?(@page)
      @regenerator.regenerate?(@post)
      @regenerator.regenerate?(@document)
      @regenerator.regenerate?(@asset_file)

      # we need to create the destinations for these files,
      # because regenerate? checks if the destination exists
      [@page, @post, @document, @asset_file].each do |item|
        next unless item.respond_to?(:destination)

        dest = item.destination(@site.dest)
        FileUtils.mkdir_p(File.dirname(dest))
        FileUtils.touch(dest)
      end
      @regenerator.write_metadata
      @regenerator = Regenerator.new(@site)

      # these should pass, since nothing has changed, and the
      # loop above made sure the designations exist
      assert !@regenerator.regenerate?(@page)
      assert !@regenerator.regenerate?(@post)
      assert !@regenerator.regenerate?(@document)
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
  end

  context "The site regenerator" do
    setup do
      FileUtils.rm_rf(source_dir(".jekyll-metadata"))
      @site = fixture_site(
        "incremental" => true
      )

      @site.read
      @post = @site.posts.first
      @regenerator = @site.regenerator
      @regenerator.regenerate?(@post)

      @layout_path = source_dir("_layouts/default.html")
    end

    teardown do
      File.rename(@layout_path + ".tmp", @layout_path)
    end

    should "handle deleted/nonexistent dependencies" do
      assert_equal 1, @regenerator.metadata.size
      path = @regenerator.metadata.keys[0]

      assert_exist @layout_path
      @regenerator.add_dependency(path, @layout_path)

      File.rename(@layout_path, @layout_path + ".tmp")
      refute File.exist?(@layout_path)

      @regenerator.clear_cache
      assert @regenerator.regenerate?(@post)
    end
  end

  context "The site metadata" do
    setup do
      FileUtils.rm_rf(source_dir(".jekyll-metadata"))

      @site = Site.new(Jekyll.configuration(
                         "source"      => source_dir,
                         "destination" => dest_dir,
                         "incremental" => true
                       ))

      @site.process
      @path = @site.in_source_dir(@site.pages.first.path)
      @regenerator = @site.regenerator
    end

    should "store modification times" do
      assert_equal File.mtime(@path), @regenerator.metadata[@path]["mtime"]
    end

    should "cache processed entries" do
      assert @regenerator.cache[@path]
    end

    should "clear the cache on clear_cache" do
      # @path will be in the cache because the
      # site will have processed it
      assert @regenerator.cache[@path]

      @regenerator.clear_cache
      expected = {}
      assert_equal expected, @regenerator.cache
    end

    should "write to the metadata file" do
      @regenerator.clear
      @regenerator.add(@path)
      @regenerator.write_metadata
      assert File.file?(source_dir(".jekyll-metadata"))
    end

    should "read from the metadata file" do
      @regenerator = Regenerator.new(@site)
      assert_equal File.mtime(@path), @regenerator.metadata[@path]["mtime"]
    end

    should "read legacy YAML metadata" do
      metadata_file = source_dir(".jekyll-metadata")
      @regenerator = Regenerator.new(@site)

      File.open(metadata_file, "w") do |f|
        f.write(@regenerator.metadata.to_yaml)
      end

      @regenerator = Regenerator.new(@site)
      assert_equal File.mtime(@path), @regenerator.metadata[@path]["mtime"]
    end

    should "not crash when reading corrupted marshal file" do
      metadata_file = source_dir(".jekyll-metadata")
      File.open(metadata_file, "w") do |file|
        file.puts Marshal.dump(:foo => "bar")[0, 5]
      end

      @regenerator = Regenerator.new(@site)
      assert_equal({}, @regenerator.metadata)
    end

    # Methods

    should "be able to add a path to the metadata" do
      @regenerator.clear
      @regenerator.add(@path)
      assert_equal File.mtime(@path), @regenerator.metadata[@path]["mtime"]
      assert_equal [], @regenerator.metadata[@path]["deps"]
      assert @regenerator.cache[@path]
    end

    should "return true on nonexistent path" do
      @regenerator.clear
      assert @regenerator.add("/bogus/path.md")
      assert @regenerator.modified?("/bogus/path.md")
    end

    should "be able to force a path to regenerate" do
      @regenerator.clear
      @regenerator.force(@path)
      assert @regenerator.cache[@path]
      assert @regenerator.modified?(@path)
    end

    should "be able to clear metadata and cache" do
      @regenerator.clear
      @regenerator.add(@path)
      assert_equal 1, @regenerator.metadata.length
      assert_equal 1, @regenerator.cache.length
      @regenerator.clear
      assert_equal 0, @regenerator.metadata.length
      assert_equal 0, @regenerator.cache.length
    end

    should "not regenerate a path if it is not modified" do
      @regenerator.clear
      @regenerator.add(@path)
      @regenerator.write_metadata
      @regenerator = Regenerator.new(@site)

      assert !@regenerator.modified?(@path)
    end

    should "not regenerate if path in cache is false" do
      @regenerator.clear
      @regenerator.add(@path)
      @regenerator.write_metadata
      @regenerator = Regenerator.new(@site)

      assert !@regenerator.modified?(@path)
      assert !@regenerator.cache[@path]
      assert !@regenerator.modified?(@path)
    end

    should "regenerate if path in not in metadata" do
      @regenerator.clear
      @regenerator.add(@path)

      assert @regenerator.modified?(@path)
    end

    should "regenerate if path in cache is true" do
      @regenerator.clear
      @regenerator.add(@path)

      assert @regenerator.modified?(@path)
      assert @regenerator.cache[@path]
      assert @regenerator.modified?(@path)
    end

    should "regenerate if file is modified" do
      @regenerator.clear
      @regenerator.add(@path)
      @regenerator.metadata[@path]["mtime"] = Time.at(0)
      @regenerator.write_metadata
      @regenerator = Regenerator.new(@site)

      refute_same File.mtime(@path), @regenerator.metadata[@path]["mtime"]
      assert @regenerator.modified?(@path)
    end

    should "regenerate if dependency is modified" do
      @regenerator.clear
      @regenerator.add(@path)
      @regenerator.write_metadata
      @regenerator = Regenerator.new(@site)

      @regenerator.add_dependency(@path, "new.dependency")
      assert_equal ["new.dependency"], @regenerator.metadata[@path]["deps"]
      assert @regenerator.modified?("new.dependency")
      assert @regenerator.modified?(@path)
    end

    should "not regenerate again if multiple dependencies" do
      multi_deps = @regenerator.metadata.select { |_k, v| v["deps"].length > 2 }
      multi_dep_path = multi_deps.keys.first

      assert @regenerator.metadata[multi_dep_path]["deps"].length > 2

      assert @regenerator.modified?(multi_dep_path)

      @site.process
      @regenerator.clear_cache

      refute @regenerator.modified?(multi_dep_path)
    end

    should "regenerate everything if metadata is disabled" do
      @site.config["incremental"] = false
      @regenerator.clear
      @regenerator.add(@path)
      @regenerator.write_metadata
      @regenerator = Regenerator.new(@site)

      assert @regenerator.modified?(@path)
    end
  end

  context "when incremental regeneration is disabled" do
    setup do
      FileUtils.rm_rf(source_dir(".jekyll-metadata"))
      @site = Site.new(Jekyll.configuration(
                         "source"      => source_dir,
                         "destination" => dest_dir,
                         "incremental" => false
                       ))

      @site.process
      @path = @site.in_source_dir(@site.pages.first.path)
      @regenerator = @site.regenerator
    end

    should "not create .jekyll-metadata" do
      refute File.file?(source_dir(".jekyll-metadata"))
    end
  end
end
