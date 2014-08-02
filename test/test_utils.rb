require 'helper'

class TestUtils < Test::Unit::TestCase
  context "hash" do

    context "pluralized_array" do

      should "return empty array with no values" do
        data = {}
        assert_equal [], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      should "return empty array with no matching values" do
        data = { 'foo' => 'bar' }
        assert_equal [], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      should "return plural array with nil singular" do
        data = { 'foo' => 'bar', 'tag' => nil, 'tags' => ['dog', 'cat'] }
        assert_equal ['dog', 'cat'], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      should "return single value array with matching singular" do
        data = { 'foo' => 'bar', 'tag' => 'dog', 'tags' => ['dog', 'cat'] }
        assert_equal ['dog'], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      should "return single value array with matching singular with spaces" do
        data = { 'foo' => 'bar', 'tag' => 'dog cat', 'tags' => ['dog', 'cat'] }
        assert_equal ['dog cat'], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      should "return empty array with matching nil plural" do
        data = { 'foo' => 'bar', 'tags' => nil }
        assert_equal [], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      should "return empty array with matching empty array" do
        data = { 'foo' => 'bar', 'tags' => [] }
        assert_equal [], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      should "return single value array with matching plural with single string value" do
        data = { 'foo' => 'bar', 'tags' => 'dog' }
        assert_equal ['dog'], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      should "return multiple value array with matching plural with single string value with spaces" do
        data = { 'foo' => 'bar', 'tags' => 'dog cat' }
        assert_equal ['dog', 'cat'], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      should "return single value array with matching plural with single value array" do
        data = { 'foo' => 'bar', 'tags' => ['dog'] }
        assert_equal ['dog'], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

      should "return multiple value array with matching plural with multiple value array" do
        data = { 'foo' => 'bar', 'tags' => ['dog', 'cat'] }
        assert_equal ['dog', 'cat'], Utils.pluralized_array_from_hash(data, 'tag', 'tags')
      end

    end

  end

  context "The \`Utils.parse_date\` method" do
    should "parse a properly formatted date" do
      assert Utils.parse_date("2014-08-02 14:43:06 PDT").is_a? Time
    end

    should "throw an error if the input contains no date data" do
      assert_raise Jekyll::Errors::FatalException do
        Utils.parse_date("Blah")
      end
    end

    should "throw an error if the input is out of range" do
      assert_raise Jekyll::Errors::FatalException do
        Utils.parse_date("9999-99-99")
      end
    end

    should "throw an error with the default message if no message is passed in" do
      date = "Blah this is invalid"
      assert_raise Jekyll::Errors::FatalException, "Invalid date '#{date}': Input could not be parsed." do
        Utils.parse_date(date)
      end
    end

    should "throw an error with the provided message if a message is passed in" do
      date = "Blah this is invalid"
      message = "Aaaah, the world has exploded!"
      assert_raise Jekyll::Errors::FatalException, "Invalid date '#{date}': #{message}" do
        Utils.parse_date(date, message)
      end
    end
  end

end
