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

  context "base directory with the same start string as a file" do
    setup do
      @source = "/app"
      @dest = "./_site/"
      allow(Dir).to receive(:pwd).and_return(@source)
    end

    should "ensure files starting with the site source are in the source dir" do
      file = "apple-icon-precomposed.png"
      assert_equal "/app/#{file}", Jekyll.sanitized_path("/app",file)
    end

    should "ensure files not starting with the site source are in the source dir" do
      file = "some-other-such-thing-here.html"
      assert_equal "/app/#{file}", Jekyll.sanitized_path("/app",file)
    end
  end
end
