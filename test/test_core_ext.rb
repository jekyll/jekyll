require 'helper'

class TestCoreExt < Test::Unit::TestCase
  context "hash" do

    context "pluralized_array" do

      should "return empty array with no values" do
        data = {}
        assert_equal [], data.pluralized_array('tag', 'tags')
      end

      should "return empty array with no matching values" do
        data = { 'foo' => 'bar' }
        assert_equal [], data.pluralized_array('tag', 'tags')
      end

      should "return empty array with matching nil singular" do
        data = { 'foo' => 'bar', 'tag' => nil, 'tags' => ['dog', 'cat'] }
        assert_equal [], data.pluralized_array('tag', 'tags')
      end

      should "return single value array with matching singular" do
        data = { 'foo' => 'bar', 'tag' => 'dog', 'tags' => ['dog', 'cat'] }
        assert_equal ['dog'], data.pluralized_array('tag', 'tags')
      end

      should "return single value array with matching singular with spaces" do
        data = { 'foo' => 'bar', 'tag' => 'dog cat', 'tags' => ['dog', 'cat'] }
        assert_equal ['dog cat'], data.pluralized_array('tag', 'tags')
      end

      should "return empty array with matching nil plural" do
        data = { 'foo' => 'bar', 'tags' => nil }
        assert_equal [], data.pluralized_array('tag', 'tags')
      end

      should "return empty array with matching empty array" do
        data = { 'foo' => 'bar', 'tags' => [] }
        assert_equal [], data.pluralized_array('tag', 'tags')
      end

      should "return single value array with matching plural with single string value" do
        data = { 'foo' => 'bar', 'tags' => 'dog' }
        assert_equal ['dog'], data.pluralized_array('tag', 'tags')
      end

      should "return multiple value array with matching plural with single string value with spaces" do
        data = { 'foo' => 'bar', 'tags' => 'dog cat' }
        assert_equal ['dog', 'cat'], data.pluralized_array('tag', 'tags')
      end

      should "return single value array with matching plural with single value array" do
        data = { 'foo' => 'bar', 'tags' => ['dog'] }
        assert_equal ['dog'], data.pluralized_array('tag', 'tags')
      end

      should "return multiple value array with matching plural with multiple value array" do
        data = { 'foo' => 'bar', 'tags' => ['dog', 'cat'] }
        assert_equal ['dog', 'cat'], data.pluralized_array('tag', 'tags')
      end

    end

  end

  context "enumerable" do
    context "glob_include?" do
      should "return false with no glob patterns" do
        assert ![].glob_include?("a.txt")
      end

      should "return false with all not match path" do
        data = ["a*", "b?"]
        assert !data.glob_include?("ca.txt")
        assert !data.glob_include?("ba.txt")
      end

      should "return true with match path" do
        data = ["a*", "b?", "**/a*"]
        assert data.glob_include?("a.txt")
        assert data.glob_include?("ba")
        assert data.glob_include?("c/a/a.txt")
        assert data.glob_include?("c/a/b/a.txt")
      end
    end
  end
end
