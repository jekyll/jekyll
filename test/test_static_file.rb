# frozen_string_literal: true

require "helper"

class TestStaticFile < JekyllUnitTest
  def make_dummy_file(filename)
    File.write(source_dir(filename), "some content")
  end

  def modify_dummy_file(filename)
    string = "some content"
    offset = string.size
    File.write(source_dir(filename), "more content", offset)
  end

  def remove_dummy_file(filename)
    File.delete(source_dir(filename))
  end

  def setup_static_file(base, dir, name)
    Dir.chdir(@site.source) { StaticFile.new(@site, base, dir, name) }
  end

  def setup_static_file_with_collection(base, dir, name, metadata)
    site = fixture_site("collections" => { "foo" => metadata })
    Dir.chdir(site.source) do
      StaticFile.new(site, base, dir, name, site.collections["foo"])
    end
  end

  def setup_static_file_with_defaults(base, dir, name, defaults)
    site = fixture_site("defaults" => defaults)
    Dir.chdir(site.source) do
      StaticFile.new(site, base, dir, name)
    end
  end

  context "A StaticFile" do
    setup do
      clear_dest
      @site = fixture_site
      @filename = "static_file.txt"
      make_dummy_file(@filename)
      @static_file = setup_static_file(@site.source, "", @filename)
    end

    teardown do
      remove_dummy_file(@filename) if File.exist?(source_dir(@filename))
    end

    should "return a simple string on inspection" do
      static_file = setup_static_file("root", "dir", @filename)
      assert_equal "#<Jekyll::StaticFile @relative_path=\"dir/#{@filename}\">", static_file.inspect
    end

    should "have a source file path" do
      static_file = setup_static_file("root", "dir", @filename)
      assert_equal "root/dir/#{@filename}", static_file.path
    end

    should "ignore a nil base or dir" do
      assert_equal "dir/#{@filename}", setup_static_file(nil, "dir", @filename).path
      assert_equal "base/#{@filename}", setup_static_file("base", nil, @filename).path
    end

    should "have a destination relative directory without a collection" do
      static_file = setup_static_file("root", "dir/subdir", "file.html")
      assert_nil static_file.type
      assert_equal "dir/subdir/file.html", static_file.url
      assert_equal "dir/subdir", static_file.destination_rel_dir
    end

    should "have a destination relative directory with a collection" do
      static_file = setup_static_file_with_collection(
        "root",
        "_foo/dir/subdir",
        "file.html",
        "output" => true
      )
      assert_equal :foo, static_file.type
      assert_equal "/foo/dir/subdir/file.html", static_file.url
      assert_equal "/foo/dir/subdir", static_file.destination_rel_dir
    end

    should "use its collection's permalink template for destination relative directory" do
      static_file = setup_static_file_with_collection(
        "root",
        "_foo/dir/subdir",
        "file.html",
        "output" => true, "permalink" => "/:path/"
      )
      assert_equal :foo, static_file.type
      assert_equal "/dir/subdir/file.html", static_file.url
      assert_equal "/dir/subdir", static_file.destination_rel_dir
    end

    should "be writable by default" do
      static_file = setup_static_file("root", "dir/subdir", "file.html")
      assert(static_file.write?,
             "static_file.write? should return true by default")
    end

    should "use the _config.yml defaults to determine writability" do
      defaults = [{
        "scope"  => { "path" => "private" },
        "values" => { "published" => false },
      }]
      static_file = setup_static_file_with_defaults(
        "root",
        "private/dir/subdir",
        "file.html",
        defaults
      )
      assert(!static_file.write?,
             "static_file.write? should return false when _config.yml sets " \
             "`published: false`")
    end

    should "respect front matter defaults" do
      defaults = [{
        "scope"  => { "path" => "" },
        "values" => { "front-matter" => "default" },
      }]

      static_file = setup_static_file_with_defaults "", "", "file.pdf", defaults
      assert_equal "default", static_file.data["front-matter"]
    end

    should "include front matter defaults in to_liquid" do
      defaults = [{
        "scope"  => { "path" => "" },
        "values" => { "front-matter" => "default" },
      }]

      static_file = setup_static_file_with_defaults "", "", "file.pdf", defaults
      hash = static_file.to_liquid
      assert hash.key? "front-matter"
      assert_equal "default", hash["front-matter"]
    end

    should "know its last modification time" do
      assert_equal File.stat(@static_file.path).mtime.to_i, @static_file.mtime
    end

    should "only set modified time if not a symlink" do
      expect(File).to receive(:symlink?).and_return(true)
      expect(File).not_to receive(:utime)
      @static_file.write(dest_dir)

      allow(File).to receive(:symlink?).and_call_original
    end

    should "known if the source path is modified, when it is" do
      sleep 1
      modify_dummy_file(@filename)
      assert @static_file.modified?
    end

    should "known if the source path is modified, when it's not" do
      @static_file.write(dest_dir)
      sleep 1 # wait, else the times are still the same
      assert !@static_file.modified?
    end

    should "known whether to write the file to the filesystem" do
      assert @static_file.write?, "always true, with current implementation"
    end

    should "be able to write itself to the destination directory" do
      assert @static_file.write(dest_dir)
    end

    should "be able to convert to liquid" do
      expected = {
        "basename"      => "static_file",
        "name"          => "static_file.txt",
        "extname"       => ".txt",
        "modified_time" => @static_file.modified_time,
        "path"          => "/static_file.txt",
        "collection"    => nil,
      }
      assert_equal expected, @static_file.to_liquid.to_h
    end

    should "jsonify its liquid drop instead of itself" do
      assert_equal @static_file.to_liquid.to_json, @static_file.to_json
    end
  end
end
