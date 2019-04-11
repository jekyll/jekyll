# frozen_string_literal: true

require "helper"

class TestCollections < JekyllUnitTest
  context "an evil collection" do
    setup do
      @collection = Jekyll::Collection.new(fixture_site, "../../etc/password")
    end

    should "sanitize the label name" do
      assert_equal "....etcpassword", @collection.label
    end

    should "have a sanitized relative path name" do
      assert_equal "_....etcpassword", @collection.relative_directory
    end

    should "have a sanitized full path" do
      assert_equal @collection.directory, source_dir("_....etcpassword")
    end
  end

  context "a simple collection" do
    setup do
      @collection = Jekyll::Collection.new(fixture_site, "methods")
    end

    should "sanitize the label name" do
      assert_equal "methods", @collection.label
    end

    should "have default URL template" do
      assert_equal "/:collection/:path:output_ext", @collection.url_template
    end

    should "contain no docs when initialized" do
      assert_empty @collection.docs
    end

    should "know its relative directory" do
      assert_equal "_methods", @collection.relative_directory
    end

    should "know the full path to itself on the filesystem" do
      assert_equal @collection.directory, source_dir("_methods")
    end

    context "when turned into Liquid" do
      should "have a label attribute" do
        assert_equal "methods", @collection.to_liquid["label"]
      end

      should "have a docs attribute" do
        assert_equal [], @collection.to_liquid["docs"]
      end

      should "have a files attribute" do
        assert_equal [], @collection.to_liquid["files"]
      end

      should "have a directory attribute" do
        assert_equal @collection.to_liquid["directory"], source_dir("_methods")
      end

      should "have a relative_directory attribute" do
        assert_equal "_methods", @collection.to_liquid["relative_directory"]
      end

      should "have a output attribute" do
        assert_equal false, @collection.to_liquid["output"]
      end
    end

    should "know whether it should be written or not" do
      assert_equal false, @collection.write?
      @collection.metadata["output"] = true
      assert_equal true, @collection.write?
      @collection.metadata.delete "output"
    end
  end

  context "with no collections specified" do
    setup do
      @site = fixture_site
      @site.process
    end

    should "contain only the default collections" do
      expected = {}
      refute_equal expected, @site.collections
      refute_nil @site.collections
    end
  end

  context "a collection with permalink" do
    setup do
      @site = fixture_site(
        "collections" => {
          "methods" => {
            "permalink" => "/awesome/:path/",
          },
        }
      )
      @site.process
      @collection = @site.collections["methods"]
    end

    should "have custom URL template" do
      assert_equal "/awesome/:path/", @collection.url_template
    end
  end

  context "with a collection" do
    setup do
      @site = fixture_site(
        "collections" => ["methods"]
      )
      @site.process
      @collection = @site.collections["methods"]
    end

    should "create a Hash mapping label to Collection instance" do
      assert @site.collections.is_a?(Hash)
      refute_nil @site.collections["methods"]
      assert @site.collections["methods"].is_a? Jekyll::Collection
    end

    should "collects docs in an array on the Collection object" do
      assert @site.collections["methods"].docs.is_a? Array
      @site.collections["methods"].docs.each do |doc|
        assert doc.is_a? Jekyll::Document
        assert_includes %w(
          _methods/configuration.md
          _methods/sanitized_path.md
          _methods/collection/entries
          _methods/site/generate.md
          _methods/site/initialize.md
          _methods/um_hi.md
          _methods/escape-+\ #%20[].md
          _methods/yaml_with_dots.md
          _methods/3940394-21-9393050-fifif1323-test.md
          _methods/trailing-dots...md
        ), doc.relative_path
      end
    end

    should "not include files from base dir which start with an underscore" do
      refute_includes @collection.filtered_entries, "_do_not_read_me.md"
    end

    should "not include files which start with an underscore in a subdirectory" do
      refute_includes @collection.filtered_entries, "site/_dont_include_me_either.md"
    end

    should "not include the underscored files in the list of docs" do
      refute_includes @collection.docs.map(&:relative_path), "_methods/_do_not_read_me.md"
      refute_includes @collection.docs.map(&:relative_path),
                      "_methods/site/_dont_include_me_either.md"
    end
  end

  context "with a collection with metadata" do
    setup do
      @site = fixture_site(
        "collections" => {
          "methods" => {
            "foo" => "bar",
            "baz" => "whoo",
          },
        }
      )
      @site.process
      @collection = @site.collections["methods"]
    end

    should "extract the configuration collection information as metadata" do
      expected = { "foo" => "bar", "baz" => "whoo" }
      assert_equal expected, @collection.metadata
    end
  end

  context "with a collection with metadata to sort items by attribute" do
    setup do
      @site = fixture_site(
        "collections" => {
          "methods"   => {
            "output" => true,
          },
          "tutorials" => {
            "output"  => true,
            "sort_by" => "lesson",
          },
        }
      )
      @site.process
      @tutorials_collection = @site.collections["tutorials"]

      @actual_array = @tutorials_collection.docs.map(&:relative_path)
    end

    should "sort documents in a collection with 'sort_by' metadata set to a " \
           "FrontMatter key 'lesson'" do
      default_tutorials_array = %w(
        _tutorials/dive-in-and-publish-already.md
        _tutorials/extending-with-plugins.md
        _tutorials/getting-started.md
        _tutorials/graduation-day.md
        _tutorials/lets-roll.md
        _tutorials/tip-of-the-iceberg.md
      )
      tutorials_sorted_by_lesson_array = %w(
        _tutorials/getting-started.md
        _tutorials/lets-roll.md
        _tutorials/dive-in-and-publish-already.md
        _tutorials/tip-of-the-iceberg.md
        _tutorials/extending-with-plugins.md
        _tutorials/graduation-day.md
      )
      refute_equal default_tutorials_array, @actual_array
      assert_equal tutorials_sorted_by_lesson_array, @actual_array
    end
  end

  context "with a collection with metadata to rearrange items" do
    setup do
      @site = fixture_site(
        "collections" => {
          "methods"   => {
            "output" => true,
          },
          "tutorials" => {
            "output" => true,
            "order"  => [
              "getting-started.md",
              "lets-roll.md",
              "dive-in-and-publish-already.md",
              "tip-of-the-iceberg.md",
              "graduation-day.md",
              "extending-with-plugins.md",
            ],
          },
        }
      )
      @site.process
      @tutorials_collection = @site.collections["tutorials"]

      @actual_array = @tutorials_collection.docs.map(&:relative_path)
    end

    should "sort documents in a collection in the order outlined in the config file" do
      default_tutorials_array = %w(
        _tutorials/dive-in-and-publish-already.md
        _tutorials/extending-with-plugins.md
        _tutorials/getting-started.md
        _tutorials/graduation-day.md
        _tutorials/lets-roll.md
        _tutorials/tip-of-the-iceberg.md
      )
      tutorials_rearranged_in_config_array = %w(
        _tutorials/getting-started.md
        _tutorials/lets-roll.md
        _tutorials/dive-in-and-publish-already.md
        _tutorials/tip-of-the-iceberg.md
        _tutorials/graduation-day.md
        _tutorials/extending-with-plugins.md
      )
      refute_equal default_tutorials_array, @actual_array
      assert_equal tutorials_rearranged_in_config_array, @actual_array
    end
  end

  context "in safe mode" do
    setup do
      @site = fixture_site(
        "collections" => ["methods"],
        "safe"        => true
      )
      @site.process
      @collection = @site.collections["methods"]
    end

    should "include the symlinked file as it resolves to inside site.source" do
      assert_includes @collection.filtered_entries, "um_hi.md"
      refute_includes @collection.filtered_entries, "/um_hi.md"
    end

    should "include the symlinked file from site.source in the list of docs" do
      # no support for including symlinked file on Windows
      skip_if_windows "Jekyll does not currently support symlinks on Windows."

      assert_includes @collection.docs.map(&:relative_path), "_methods/um_hi.md"
    end
  end

  context "with dots in the filenames" do
    setup do
      @site = fixture_site(
        "collections" => ["with.dots"],
        "safe"        => true
      )
      @site.process
      @collection = @site.collections["with.dots"]
    end

    should "exist" do
      refute_nil @collection
    end

    should "contain one document" do
      assert_equal 4, @collection.docs.size
    end

    should "allow dots in the filename" do
      assert_equal "_with.dots", @collection.relative_directory
    end

    should "read document in subfolders with dots" do
      assert(
        @collection.docs.any? { |d| d.path.include?("all.dots") }
      )
    end
  end

  context "a collection with included dotfiles" do
    setup do
      @site = fixture_site(
        "collections" => {
          "methods" => {
            "permalink" => "/awesome/:path/",
          },
        },
        "include"     => %w(.htaccess .gitignore)
      )
      @site.process
      @collection = @site.collections["methods"]
    end

    should "contain .htaccess file" do
      assert(@collection.files.any? { |d| d.name == ".htaccess" })
    end

    should "contain .gitignore file" do
      assert(@collection.files.any? { |d| d.name == ".gitignore" })
    end

    should "have custom URL in static file" do
      assert(
        @collection.files.any? { |d| d.url.include?("/awesome/with.dots/") }
      )
    end
  end
end
