require 'helper'

class TestStaticFile < JekyllUnitTest
  def make_dummy_file(filename)
    File.write(source_dir(filename), "some content")
  end

  def modify_dummy_file(filename)
    offset = "some content".size
    File.write(source_dir(filename), "more content", offset)
  end

  def remove_dummy_file(filename)
    File.delete(source_dir(filename))
  end

  def setup_static_file(base, dir, name)
    StaticFile.new(@site, base, dir, name)
  end

  context "A StaticFile" do
    setup do
      clear_dest
      @old_pwd = Dir.pwd
      Dir.chdir source_dir
      @site = fixture_site
      @filename = "static_file.txt"
      make_dummy_file(@filename)
      @static_file = setup_static_file(nil, nil, @filename)
    end

    teardown do
      remove_dummy_file(@filename) if File.exist?(source_dir(@filename))
      Dir.chdir @old_pwd
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
      assert "dir/subdir", static_file.destination_rel_dir
    end

    should "know its last modification time" do
      assert_equal Time.new.to_i, @static_file.mtime
    end

    should "known if the source path is modified, when it is" do
      sleep 1
      modify_dummy_file(@filename)
      assert @static_file.modified?
    end

    should "known if the source path is modified, when its not" do
      @static_file.write(dest_dir)
      sleep 1 # wait, else the times are still the same
      assert !@static_file.modified?
    end

    should "known whether to write the file to the filesystem" do
      assert @static_file.write?, "always true, with current implementation"
    end

    should "be able to write itself to the desitination direcotry" do
      assert @static_file.write(dest_dir)
    end

    should "be able to convert to liquid" do
      expected = {
          "extname"       => ".txt",
          "modified_time" => @static_file.modified_time,
          "path"          => "/static_file.txt",
      }
      assert_equal expected, @static_file.to_liquid
    end
  end
end

