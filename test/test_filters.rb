require File.dirname(__FILE__) + '/helper'

class TestFilters < Test::Unit::TestCase
  
  class JekyllFilter
    include Jekyll::Filters
  end
  
  def setup
    @filter = JekyllFilter.new
  end

  def test_array_to_sentence_string_with_no_args
    assert_equal "", @filter.array_to_sentence_string([])
  end

  def test_array_to_sentence_string_with_one_arg
    assert_equal "1", @filter.array_to_sentence_string([1])
    assert_equal "chunky", @filter.array_to_sentence_string(["chunky"])
  end
  
  def test_array_to_sentence_string_with_two_args
    assert_equal "1 and 2", @filter.array_to_sentence_string([1, 2])
    assert_equal "chunky and bacon", @filter.array_to_sentence_string(["chunky", "bacon"])
  end
  
  def test_array_to_sentence_string_with_multiple_args
    assert_equal "1, 2, 3, and 4", @filter.array_to_sentence_string([1, 2, 3, 4])
    assert_equal "chunky, bacon, bits, and pieces", @filter.array_to_sentence_string(["chunky", "bacon", "bits", "pieces"])
  end
  
  def test_xml_escape_with_ampersands
    assert_equal "AT&amp;T", @filter.xml_escape("AT&T")
    assert_equal "&lt;code&gt;command &amp;lt;filename&amp;gt;&lt;/code&gt;", @filter.xml_escape("<code>command &lt;filename&gt;</code>")
  end
  
end
