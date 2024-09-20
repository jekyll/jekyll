# frozen_string_literal: true

require "helper"

class TestConvertible < JekyllUnitTest
  class MockConvertible
    include Jekyll::Convertible

    attr_reader :site, :base, :relative_path, :path
    attr_accessor :data, :content

    def initialize(site:, name:)
      @site = site
      @base = site.source
      @name = name
      @path = File.join(base, name)
    end

    def mock_read(**opts)
      read_yaml(@base, @name, **opts)
    end
  end

  def fixture_convertible(name:, config: {})
    MockConvertible.new(
      :name => name,
      :site => Jekyll::Site.new(
        Jekyll.configuration({"source" => File.expand_path("fixtures", __dir__)}.merge(config))
      )
    )
  end

  context "YAML front matter" do
    should "parse the front matter correctly" do
      assert_equal(
        { "test" => "good" },
        fixture_convertible(:name => "front_matter.erb").mock_read
      )
    end

    should "not parse if the front matter is not at the start of the file" do
      assert_equal({}, fixture_convertible(:name => "broken_front_matter1.erb").mock_read)
    end

    should "not parse if there is syntax error in front matter" do
      convertible = fixture_convertible(:name => "broken_front_matter2.erb")
      out = capture_stderr do
        assert_equal({}, convertible.mock_read)
      end

      assert_match(%r!YAML Exception!, out)
      assert_match(%r!#{Regexp.escape(convertible.path)}!, out)
    end

    should "raise for broken front matter with `strict_front_matter` set" do
      assert_raises(Psych::SyntaxError) do
        fixture_convertible(
          :name   => "broken_front_matter2.erb",
          :config => { "strict_front_matter" => true }
        ).mock_read
      end
    end

    should "not allow ruby objects in YAML" do
      out = capture_stderr do
        fixture_convertible(:name => "exploit_front_matter.erb").mock_read
      end

      refute_match(%r!undefined class/module DoesNotExist!, out)
    end

    should "not parse if there is encoding error in file" do
      convertible = fixture_convertible(:name => "broken_front_matter3.erb")
      out = capture_stderr do
        assert_equal({}, convertible.mock_read(:encoding => "utf-8"))
      end

      assert_match(%r!invalid byte sequence in UTF-8!, out)
      assert_match(%r!#{Regexp.escape(convertible.path)}!, out)
    end

    should "parse the front matter but show an error if permalink is empty" do
      assert_raises(Errors::InvalidPermalinkError) do
        fixture_convertible(:name => "empty_permalink.erb").mock_read
      end
    end

    should "parse the front matter correctly without permalink" do
      out = capture_stderr do
        fixture_convertible(:name => "front_matter.erb").mock_read
      end

      refute_match(%r!Invalid permalink!, out)
    end

    should "not parse Liquid if disabled in front matter" do
      convertible = fixture_convertible(:name => "no_liquid.erb")
      convertible.mock_read

      assert_equal("{% raw %}{% endraw %}", convertible.content.strip)
    end
  end
end
