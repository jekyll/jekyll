require 'helper'

class TestPathSanitization < Test::Unit::TestCase
  context "Path sanitization" do
    setup do
      @base_dir = "/tmp/foobar/jail"
    end

    should "remove single relative pair" do
      assert_equal @base_dir + "/", Jekyll.sanitized_path(@base_dir, "css/..")
    end

    should "remove all dot path elements" do
      assert_equal @base_dir + "/_posts/news", Jekyll.sanitized_path(@base_dir, "_posts/projects/../blog/../news")
      assert_equal @base_dir + "/_posts", Jekyll.sanitized_path(@base_dir, "../_posts/./.")
      assert_equal @base_dir + "/", Jekyll.sanitized_path(@base_dir, "..")
      assert_equal @base_dir + "/_layouts/index.html", Jekyll.sanitized_path(@base_dir, "./_layouts/./index.html")
    end

    context "on Windows with absolute source" do
      setup do
        @source = "C:/Users/xmr/Desktop/mpc-hc.org"
        @dest   = "./_site/"
        stub(Dir).pwd { "C:/Users/xmr/Desktop/mpc-hc.org" }
      end
      should "strip drive name from path" do
        assert_equal "C:/Users/xmr/Desktop/mpc-hc.org/_site", Jekyll.sanitized_path(@source, @dest)
      end

      should "not change path case" do
        assert_equal @source + "/windows", Jekyll.sanitized_path(@source, "windows")
      end

      should "strip just the initial drive name" do
        assert_equal "/tmp/foobar/jail/..c:/..c:/..c:/etc/passwd", Jekyll.sanitized_path("/tmp/foobar/jail", "..c:/..c:/..c:/etc/passwd")
      end
    end
  end
end
