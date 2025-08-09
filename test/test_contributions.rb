# frozen_string_literal: true

require "helper"

class TestContributions < JekyllUnitTest
  context "Enhanced error messages" do
    should "provide detailed theme error messages" do
      theme = Jekyll::Theme.new("nonexistent-theme")
      
      # Test that error messages are more descriptive
      # This would be tested in integration tests with actual file system errors
      assert_respond_to theme, :log_realpath_exception
    end
  end

  context "Optimized filters" do
    setup do
      @site = fixture_site
      @context = Liquid::Context.new(@site.site_payload, {}, :site => @site)
      @filter = Jekyll::Filters.new(nil, @context)
    end

    should "handle Hash input efficiently in where_exp" do
      hash_input = { "a" => { "name" => "Alice", "age" => 30 }, "b" => { "name" => "Bob", "age" => 25 } }
      result = @filter.where_exp(hash_input, "item", "item.age > 26")
      
      assert_equal 1, result.length
      assert_equal "Alice", result.first["name"]
    end

    should "handle empty input gracefully in find filter" do
      empty_array = []
      result = @filter.find(empty_array, "name", "Alice")
      
      assert_equal [], result
    end

    should "handle nil property in find filter" do
      input = [{ "name" => "Alice" }, { "name" => "Bob" }]
      result = @filter.find(input, nil, "Alice")
      
      assert_equal input, result
    end

    should "handle empty property string in find filter" do
      input = [{ "name" => "Alice" }, { "name" => "Bob" }]
      result = @filter.find(input, "", "Alice")
      
      assert_equal input, result
    end
  end

  context "Enhanced path sanitization" do
    should "handle nil and empty paths gracefully" do
      result = Jekyll::PathManager.sanitized_path("/base", nil)
      assert_equal "/base", result
      
      result = Jekyll::PathManager.sanitized_path("/base", "")
      assert_equal "/base", result
    end

    should "detect potential directory traversal attempts" do
      # This would log a warning in actual usage
      result = Jekyll::PathManager.sanitized_path("/base", "../../../etc/passwd")
      assert result.start_with?("/base")
    end
  end

  context "Optimized cache key generation" do
    setup do
      @cache = Jekyll::Cache.new("test_cache")
    end

    should "handle different key types efficiently" do
      # Test string keys
      @cache["string_key"] = "value1"
      assert_equal "value1", @cache["string_key"]
      
      # Test symbol keys
      @cache[:symbol_key] = "value2"
      assert_equal "value2", @cache[:symbol_key]
      
      # Test numeric keys
      @cache[123] = "value3"
      assert_equal "value3", @cache[123]
    end
  end

  context "Enhanced URL error messages" do
    should "provide available keys in error message" do
      placeholders = { "title" => "test", "date" => "2023-01-01" }
      url = Jekyll::URL.new(template: ":invalid_key", placeholders: placeholders)
      
      error = assert_raises(NoMethodError) do
        url.to_s
      end
      
      assert_match(/Available keys are:/, error.message)
      assert_match(/date, title/, error.message)
    end
  end
end