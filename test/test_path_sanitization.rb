require 'helper'

class TestPathSanitization < JekyllUnitTest
  context "on Windows with absolute source" do
    setup do
      @source = "C:/Users/xmr/Desktop/mpc-hc.org"
      @dest   = "./_site/"
      allow(Dir).to receive(:pwd).and_return("C:/Users/xmr/Desktop/mpc-hc.org")
    end
    should "strip drive name from path" do
      assert_equal "C:/Users/xmr/Desktop/mpc-hc.org/_site", Jekyll.sanitized_path(@source, @dest)
    end

    should "strip just the initial drive name" do
      assert_equal "/tmp/foobar/jail/..c:/..c:/..c:/etc/passwd", Jekyll.sanitized_path("/tmp/foobar/jail", "..c:/..c:/..c:/etc/passwd")
    end
  end

  should "escape tilde" do
    assert_equal source_dir("~hi.txt"), Jekyll.sanitized_path(source_dir, "~hi.txt")
    assert_equal source_dir("files", "~hi.txt"), Jekyll.sanitized_path(source_dir, "files/../files/~hi.txt")
  end

  should "remove path traversals" do
    assert_equal source_dir("files", "hi.txt"), Jekyll.sanitized_path(source_dir, "f./../../../../../../files/hi.txt")
  end
end
