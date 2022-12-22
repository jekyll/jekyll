# frozen_string_literal: true

require "helper"

class TestSass < JekyllUnitTest
  context "importing partials" do
    setup do
      @site = Jekyll::Site.new(Jekyll.configuration(
                                 "source"      => source_dir,
                                 "destination" => dest_dir
                               ))
      @site.process
      @test_css_file = dest_dir("css/main.css")
    end

    should "import SCSS partial" do
      result = <<~CSS
        .half {
          width: 50%;
        }

        /*# sourceMappingURL=main.css.map */
      CSS
      assert_equal result.rstrip, File.read(@test_css_file)
    end

    should "register the SCSS converter" do
      message = "SCSS converter implementation should exist."
      refute !@site.find_converter_instance(Jekyll::Converters::Scss), message
    end

    should "register the Sass converter" do
      message = "Sass converter implementation should exist."
      refute !@site.find_converter_instance(Jekyll::Converters::Sass), message
    end
  end
end
