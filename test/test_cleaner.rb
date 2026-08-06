# frozen_string_literal: true

require "helper"

class TestCleaner < JekyllUnitTest
  context "directory in keep_files" do
    setup do
      clear_dest

      FileUtils.mkdir_p(dest_dir("to_keep/child_dir"))
      FileUtils.touch(File.join(dest_dir("to_keep"), "index.html"))
      FileUtils.touch(File.join(dest_dir("to_keep/child_dir"), "index.html"))

      @site = fixture_site
      @site.keep_files = ["to_keep/child_dir"]

      @cleaner = Cleaner.new(@site)
      @cleaner.cleanup!
    end

    teardown do
      FileUtils.rm_rf(dest_dir("to_keep"))
    end

    should "keep the parent directory" do
      assert_exist dest_dir("to_keep")
    end

    should "keep the child directory" do
      assert_exist dest_dir("to_keep", "child_dir")
    end

    should "keep the file in the directory in keep_files" do
      assert_exist dest_dir("to_keep", "child_dir", "index.html")
    end

    should "delete the file in the directory not in keep_files" do
      refute_exist dest_dir("to_keep", "index.html")
    end
  end

  context "non-nested directory & similarly-named directory *not* in keep_files" do
    setup do
      clear_dest

      FileUtils.mkdir_p(dest_dir(".git/child_dir"))
      FileUtils.mkdir_p(dest_dir("username.github.io"))
      FileUtils.touch(File.join(dest_dir(".git"), "index.html"))
      FileUtils.touch(File.join(dest_dir("username.github.io"), "index.html"))

      @site = fixture_site
      @site.keep_files = [".git"]

      @cleaner = Cleaner.new(@site)
      @cleaner.cleanup!
    end

    teardown do
      FileUtils.rm_rf(dest_dir(".git"))
      FileUtils.rm_rf(dest_dir("username.github.io"))
    end

    should "keep the file in the directory in keep_files" do
      assert_path_exists(File.join(dest_dir(".git"), "index.html"))
    end

    should "delete the file in the directory not in keep_files" do
      refute_path_exists(File.join(dest_dir("username.github.io"), "index.html"))
    end

    should "delete the directory not in keep_files" do
      refute_path_exists(dest_dir("username.github.io"))
    end
  end

  context "glob pattern in keep_files" do
    setup do
      clear_dest
      FileUtils.mkdir_p(dest_dir)

      FileUtils.touch(dest_dir("keep_a.html"))
      FileUtils.touch(dest_dir("keep_b.html"))
      FileUtils.touch(dest_dir("delete_me.txt"))

      @site = fixture_site
      @site.keep_files = ["*.html"]

      @cleaner = Cleaner.new(@site)
      @cleaner.cleanup!
    end

    teardown do
      FileUtils.rm_f(dest_dir("keep_a.html"))
      FileUtils.rm_f(dest_dir("keep_b.html"))
      FileUtils.rm_f(dest_dir("delete_me.txt"))
    end

    should "keep files matching the glob pattern" do
      assert_path_exists(dest_dir("keep_a.html"))
      assert_path_exists(dest_dir("keep_b.html"))
    end

    should "delete files not matching the glob pattern" do
      refute_path_exists(dest_dir("delete_me.txt"))
    end
  end

  context "double-star glob pattern in keep_files" do
    setup do
      clear_dest

      FileUtils.mkdir_p(dest_dir("a", "b"))
      FileUtils.touch(dest_dir("a", "keep.html"))
      FileUtils.touch(dest_dir("a", "b", "keep.html"))
      FileUtils.touch(dest_dir("a", "delete_me.txt"))

      @site = fixture_site
      @site.keep_files = ["**/*.html"]

      @cleaner = Cleaner.new(@site)
      @cleaner.cleanup!
    end

    teardown do
      FileUtils.rm_rf(dest_dir("a"))
    end

    should "keep html files at any depth" do
      assert_path_exists(dest_dir("a", "keep.html"))
      assert_path_exists(dest_dir("a", "b", "keep.html"))
    end

    should "delete files not matching the pattern" do
      refute_path_exists(dest_dir("a", "delete_me.txt"))
    end
  end

  context "nested glob pattern in keep_files" do
    setup do
      clear_dest

      FileUtils.mkdir_p(dest_dir("cache"))
      FileUtils.touch(File.join(dest_dir("cache"), "data.json"))
      FileUtils.touch(File.join(dest_dir("cache"), "other.txt"))

      @site = fixture_site
      @site.keep_files = ["cache/*.json"]

      @cleaner = Cleaner.new(@site)
      @cleaner.cleanup!
    end

    teardown do
      FileUtils.rm_rf(dest_dir("cache"))
    end

    should "keep files matching the nested glob pattern" do
      assert_path_exists(dest_dir("cache", "data.json"))
    end

    should "delete files not matching the nested glob pattern" do
      refute_path_exists(dest_dir("cache", "other.txt"))
    end

    should "keep the parent directory of matched files" do
      assert_path_exists(dest_dir("cache"))
    end
  end

  context "destination path containing glob metacharacters" do
    setup do
      @weird_dest = temp_dir("jekyll-test[dest]")
      FileUtils.mkdir_p(@weird_dest)
    end

    teardown do
      FileUtils.rm_rf(@weird_dest)
    end

    context "with a literal entry in keep_files" do
      setup do
        FileUtils.touch(File.join(@weird_dest, "keep.html"))
        FileUtils.touch(File.join(@weird_dest, "delete_me.txt"))

        @site = fixture_site("destination" => @weird_dest)
        @site.keep_files = ["keep.html"]

        @cleaner = Cleaner.new(@site)
        @cleaner.cleanup!
      end

      should "keep files listed in keep_files" do
        assert_path_exists(File.join(@weird_dest, "keep.html"))
      end

      should "delete files not listed in keep_files" do
        refute_path_exists(File.join(@weird_dest, "delete_me.txt"))
      end
    end

    context "with a glob pattern in keep_files" do
      setup do
        FileUtils.touch(File.join(@weird_dest, "keep_a.html"))
        FileUtils.touch(File.join(@weird_dest, "keep_b.html"))
        FileUtils.touch(File.join(@weird_dest, "delete_me.txt"))

        @site = fixture_site("destination" => @weird_dest)
        @site.keep_files = ["*.html"]

        @cleaner = Cleaner.new(@site)
        @cleaner.cleanup!
      end

      should "keep files matching the glob pattern" do
        assert_path_exists(File.join(@weird_dest, "keep_a.html"))
        assert_path_exists(File.join(@weird_dest, "keep_b.html"))
      end

      should "delete files not matching the glob pattern" do
        refute_path_exists(File.join(@weird_dest, "delete_me.txt"))
      end
    end
  end

  context "directory containing no files and non-empty directories" do
    setup do
      clear_dest

      FileUtils.mkdir_p(source_dir("no_files_inside", "child_dir"))
      FileUtils.touch(source_dir("no_files_inside", "child_dir", "index.html"))

      @site = fixture_site
      @site.process

      @cleaner = Cleaner.new(@site)
      @cleaner.cleanup!
    end

    teardown do
      FileUtils.rm_rf(source_dir("no_files_inside"))
      FileUtils.rm_rf(dest_dir("no_files_inside"))
    end

    should "keep the parent directory" do
      assert_exist dest_dir("no_files_inside")
    end

    should "keep the child directory" do
      assert_exist dest_dir("no_files_inside", "child_dir")
    end

    should "keep the file" do
      assert_exist source_dir("no_files_inside", "child_dir", "index.html")
    end
  end
end
