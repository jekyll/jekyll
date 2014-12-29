require 'helper'

class TestSass < Test::Unit::TestCase
  context "importing partials" do
    setup do
      @site = Jekyll::Site.new(Jekyll.configuration({
        "source" => source_dir,
        "destination" => dest_dir
      }))
      @site.process
      @test_css_file = dest_dir("css/main.css")
    end

    should "import SCSS partial" do
      assert_equal ".half {\n  width: 50%; }\n", File.read(@test_css_file)
    end

    should "register the SCSS converter" do
      assert !!@site.find_converter_instance(Jekyll::Converters::Scss), "SCSS converter implementation should exist."
    end

    should "register the Sass converter" do
      assert !!@site.find_converter_instance(Jekyll::Converters::Sass), "Sass converter implementation should exist."
    end
  end
end
