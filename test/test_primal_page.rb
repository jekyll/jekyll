# frozen_string_literal: true

require "helper"

class TestPrimalPage < JekyllUnitTest
  def setup_page(*args)
    dir, file = args
    if file.nil?
      file = dir
      dir = ""
    end
    site = Site.new(
      Jekyll.configuration(
        "source" => File.expand_path("fixtures", __dir__)
      )
    )
    PrimalPage.new(site, site.source, dir, file)
  end

  context "YAML front matter" do
    should "parse the front matter correctly" do
      ret = setup_page("front_matter.erb").read_yaml
      assert_equal({ "test" => "good" }, ret)
    end

    should "not parse if the front matter is not at the start of the file" do
      ret = setup_page("broken_front_matter1.erb").read_yaml
      assert_equal({}, ret)
    end

    should "not parse if there is syntax error in front matter" do
      name = "broken_front_matter2.erb"
      out = capture_stderr do
        ret = setup_page(name).read_yaml
        assert_equal({}, ret)
      end
      assert_match(%r!YAML Exception!, out)
      assert_match(%r!#{name}!, out)
    end

    should "raise for broken front matter with `strict_front_matter` set" do
      page = setup_page("broken_front_matter2.erb")
      page.site.config["strict_front_matter"] = true
      assert_raises(Psych::SyntaxError) { page.read_yaml }
    end

    should "not allow ruby objects in YAML" do
      out = capture_stderr do
        setup_page("exploit_front_matter.erb")
      end
      refute_match(%r!undefined class\/module DoesNotExist!, out)
    end

    should "not parse if there is encoding error in file" do
      name = "broken_front_matter3.erb"
      out = capture_stderr do
        ret = setup_page(name).read_yaml(:encoding => "utf-8")
        assert_equal({}, ret)
      end
      assert_match(%r!invalid byte sequence in UTF-8!, out)
      assert_match(%r!#{name}!, out)
    end

    should "parse the front matter but show an error if permalink is empty" do
      assert_raises(Errors::InvalidPermalinkError) do
        setup_page("empty_permalink.erb")
      end
    end

    should "parse the front matter correctly without permalink" do
      out = capture_stderr do
        setup_page("front_matter.erb")
      end
      refute_match(%r!Invalid permalink!, out)
    end

    should "not parse Liquid if disabled in front matter" do
      page = setup_page("no_liquid.erb")
      assert_equal("{% raw %}{% endraw %}", page.content.strip)
    end
  end
end
