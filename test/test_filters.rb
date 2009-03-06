require File.dirname(__FILE__) + '/helper'

class TestFilters < Test::Unit::TestCase
  class JekyllFilter
    include Jekyll::Filters
  end

  context "filters" do
    setup do
      @filter = JekyllFilter.new
    end

    should "textilize with simple string" do
      assert_equal "<p>something <strong>really</strong> simple</p>", @filter.textilize("something *really* simple")
    end

    should "convert array to sentence string with no args" do
      assert_equal "", @filter.array_to_sentence_string([])
    end

    should "convert array to sentence string with one arg" do
      assert_equal "1", @filter.array_to_sentence_string([1])
      assert_equal "chunky", @filter.array_to_sentence_string(["chunky"])
    end

    should "convert array to sentence string with two args" do
      assert_equal "1 and 2", @filter.array_to_sentence_string([1, 2])
      assert_equal "chunky and bacon", @filter.array_to_sentence_string(["chunky", "bacon"])
    end

    should "convert array to sentence string with multiple args" do
      assert_equal "1, 2, 3, and 4", @filter.array_to_sentence_string([1, 2, 3, 4])
      assert_equal "chunky, bacon, bits, and pieces", @filter.array_to_sentence_string(["chunky", "bacon", "bits", "pieces"])
    end

    should "escape xml with ampersands" do
      assert_equal "AT&amp;T", @filter.xml_escape("AT&T")
      assert_equal "&lt;code&gt;command &amp;lt;filename&amp;gt;&lt;/code&gt;", @filter.xml_escape("<code>command &lt;filename&gt;</code>")
    end
  end
end
