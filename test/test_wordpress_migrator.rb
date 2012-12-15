require 'helper'
require 'jekyll/migrators/wordpress'
require 'htmlentities'

class TestWordpressMigrator < Test::Unit::TestCase
  should "clean slashes from slugs" do
    test_title = "blogs part 1/2"
    assert_equal("blogs-part-1-2", Jekyll::WordPress.sluggify(test_title))
  end
end
