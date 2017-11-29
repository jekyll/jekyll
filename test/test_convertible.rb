# frozen_string_literal: true

require "helper"
require "ostruct"

class TestConvertible < JekyllUnitTest
  context "YAML front matter" do
    setup do
      @convertible = OpenStruct.new(
        "site" => Site.new(Jekyll.configuration(
          "source" => File.expand_path("fixtures", __dir__)
        ))
      )
      @convertible.extend Jekyll::Convertible
      @base = File.expand_path("fixtures", __dir__)
    end

    should "parse the front matter correctly" do
      ret = @convertible.read_yaml(@base, "front_matter.erb")
      assert_equal({ "test" => "good" }, ret)
    end

    should "not parse if the front matter is not at the start of the file" do
      ret = @convertible.read_yaml(@base, "broken_front_matter1.erb")
      assert_equal({}, ret)
    end

    should "not parse if there is syntax error in front matter" do
      name = "broken_front_matter2.erb"
      out = capture_stderr do
        ret = @convertible.read_yaml(@base, name)
        assert_equal({}, ret)
      end
      assert_match(%r!YAML Exception!, out)
      assert_match(%r!#{File.join(@base, name)}!, out)
    end

    should "raise for broken front matter with `strict_front_matter` set" do
      name = "broken_front_matter2.erb"
      @convertible.site.config["strict_front_matter"] = true
      assert_raises(Psych::SyntaxError) do
        @convertible.read_yaml(@base, name)
      end
    end

    should "not allow ruby objects in YAML" do
      out = capture_stderr do
        @convertible.read_yaml(@base, "exploit_front_matter.erb")
      end
      refute_match(%r!undefined class\/module DoesNotExist!, out)
    end

    should "not parse if there is encoding error in file" do
      name = "broken_front_matter3.erb"
      out = capture_stderr do
        ret = @convertible.read_yaml(@base, name, :encoding => "utf-8")
        assert_equal({}, ret)
      end
      assert_match(%r!invalid byte sequence in UTF-8!, out)
      assert_match(%r!#{File.join(@base, name)}!, out)
    end

    should "parse the front matter but show an error if permalink is empty" do
      name = "empty_permalink.erb"
      assert_raises(Errors::InvalidPermalinkError) do
        @convertible.read_yaml(@base, name)
      end
    end

    should "parse the front matter correctly without permalink" do
      out = capture_stderr do
        @convertible.read_yaml(@base, "front_matter.erb")
      end
      refute_match(%r!Invalid permalink!, out)
    end
  end
end
