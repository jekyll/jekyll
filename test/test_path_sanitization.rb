require 'helper'

class TestPathSanitization < Test::Unit::TestCase
  context "on Windows with absolute source" do
    setup do
      @source = "C:/Users/xmr/Desktop/mpc-hc.org"
      @dest   = "./_site/"
      stub(Dir).pwd { "C:/Users/xmr/Desktop/mpc-hc.org" }
    end
    should "strip drive name from path" do
      assert_equal "C:/Users/xmr/Desktop/mpc-hc.org/_site", Jekyll.sanitized_path(@source, @dest)
    end
  end
end
