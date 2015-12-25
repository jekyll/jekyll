require 'helper'

<<<<<<< HEAD
<<<<<<< HEAD
class TestPathSanitization < JekyllUnitTest
=======
class TestPathSanitization < Test::Unit::TestCase
>>>>>>> jekyll/v1-stable
=======
class TestPathSanitization < Test::Unit::TestCase
>>>>>>> origin/v1-stable
  context "on Windows with absolute source" do
    setup do
      @source = "C:/Users/xmr/Desktop/mpc-hc.org"
      @dest   = "./_site/"
<<<<<<< HEAD
<<<<<<< HEAD
      allow(Dir).to receive(:pwd).and_return("C:/Users/xmr/Desktop/mpc-hc.org")
=======
      stub(Dir).pwd { "C:/Users/xmr/Desktop/mpc-hc.org" }
>>>>>>> jekyll/v1-stable
=======
      stub(Dir).pwd { "C:/Users/xmr/Desktop/mpc-hc.org" }
>>>>>>> origin/v1-stable
    end
    should "strip drive name from path" do
      assert_equal "C:/Users/xmr/Desktop/mpc-hc.org/_site", Jekyll.sanitized_path(@source, @dest)
    end

    should "strip just the initial drive name" do
      assert_equal "/tmp/foobar/jail/..c:/..c:/..c:/etc/passwd", Jekyll.sanitized_path("/tmp/foobar/jail", "..c:/..c:/..c:/etc/passwd")
    end
  end
end
