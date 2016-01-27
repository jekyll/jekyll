require 'helper'

class TestURL < JekyllUnitTest
  context "The URL class" do

    should "throw an exception if neither permalink or template is specified" do
      assert_raises ArgumentError do
        URL.new(:placeholders => {})
      end
    end

    should "replace placeholders in templates" do
      assert_equal "/foo/bar", URL.new(
        :template => "/:x/:y",
        :placeholders => {:x => "foo", :y => "bar"}
      ).to_s
    end

    should "handle multiple of the same key in the template" do
      assert_equal '/foo/bar/foo/', URL.new(
        :template => "/:x/:y/:x/",
        :placeholders => {:x => "foo", :y => "bar"}
      ).to_s
    end

    should "use permalink if given" do
      assert_equal "/le/perma/link", URL.new(
        :template => "/:x/:y",
        :placeholders => {:x => "foo", :y => "bar"},
        :permalink => "/le/perma/link"
      ).to_s
    end

    should "replace placeholders in permalinks" do
      assert_equal "/foo/bar", URL.new(
        :template => "/baz",
        :permalink => "/:x/:y",
        :placeholders => {:x => "foo", :y => "bar"}
      ).to_s
    end

    should "handle multiple of the same key in the permalink" do
      assert_equal '/foo/bar/foo/', URL.new(
        :template => "/baz",
        :permalink => "/:x/:y/:x/",
        :placeholders => {:x => "foo", :y => "bar"}
      ).to_s
    end

    should "handle nil values for keys in the template" do
      assert_equal '/foo/bar/', URL.new(
        :template => "/:x/:y/:z/",
        :placeholders => {:x => "foo", :y => "bar", :z => nil}
      ).to_s
    end

    should "handle UrlDrop as a placeholder in addition to a hash" do
      site = fixture_site({
        "collections" => {
          "methods" => {
            "output" => true
          }
        },
      })
      site.read
      doc = site.collections["methods"].docs.find do |doc|
        doc.relative_path == "_methods/escape-+ #%20[].md"
      end
      assert_equal '/methods/escape-+-20/escape-20.html', URL.new(
        :template => '/methods/:title/:name:output_ext',
        :placeholders => doc.url_placeholders
      ).to_s
    end

  end
end
