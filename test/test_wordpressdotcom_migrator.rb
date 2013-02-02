require 'helper'
require 'jekyll/migrators/wordpressdotcom'

class TestWordpressDotComMigrator < Test::Unit::TestCase
  should "clean slashes from slugs" do
    test_title = "blogs part 1/2"
    assert_equal("blogs-part-1-2", Jekyll::WordpressDotCom.sluggify(test_title))
  end
end
