# frozen_string_literal: true

require "helper"

class TestURL < JekyllUnitTest
  context "The URL class" do
    should "throw an exception if neither permalink or template is specified" do
      assert_raises ArgumentError do
        URL.new(:placeholders => {})
      end
    end

    should "replace placeholders in templates" do
      assert_equal "/foo/bar", URL.new(
        :template     => "/:x/:y",
        :placeholders => { :x => "foo", :y => "bar" }
      ).to_s
    end

    should "handle multiple of the same key in the template" do
      assert_equal "/foo/bar/foo/", URL.new(
        :template     => "/:x/:y/:x/",
        :placeholders => { :x => "foo", :y => "bar" }
      ).to_s
    end

    should "use permalink if given" do
      assert_equal "/le/perma/link", URL.new(
        :template     => "/:x/:y",
        :placeholders => { :x => "foo", :y => "bar" },
        :permalink    => "/le/perma/link"
      ).to_s
    end

    should "replace placeholders in permalinks" do
      assert_equal "/foo/bar", URL.new(
        :template     => "/baz",
        :permalink    => "/:x/:y",
        :placeholders => { :x => "foo", :y => "bar" }
      ).to_s
    end

    should "handle multiple of the same key in the permalink" do
      assert_equal "/foo/bar/foo/", URL.new(
        :template     => "/baz",
        :permalink    => "/:x/:y/:x/",
        :placeholders => { :x => "foo", :y => "bar" }
      ).to_s
    end

    should "handle nil values for keys in the template" do
      assert_equal "/foo/bar/", URL.new(
        :template     => "/:x/:y/:z/",
        :placeholders => { :x => "foo", :y => "bar", :z => nil }
      ).to_s
    end

    should "handle UrlDrop as a placeholder in addition to a hash" do
      _, matching_doc = fixture_document("_methods/escape-+ #%20[].md")
      assert_equal "/methods/escape-+-20/escape-20.html", URL.new(
        :template     => "/methods/:title/:name:output_ext",
        :placeholders => matching_doc.url_placeholders
      ).to_s
    end

    should "check for key without trailing underscore" do
      _, matching_doc = fixture_document("_methods/configuration.md")
      assert_equal "/methods/configuration-configuration_methods_configuration", URL.new(
        :template     => "/methods/:name-:slug_:collection_:title",
        :placeholders => matching_doc.url_placeholders
      ).to_s
    end

    should "raise custom error when URL placeholder doesn't have key" do
      _, matching_doc = fixture_document("_methods/escape-+ #%20[].md")
      assert_raises NoMethodError do
        URL.new(
          :template     => "/methods/:headline",
          :placeholders => matching_doc.url_placeholders
        ).to_s
      end
    end
  end
end
