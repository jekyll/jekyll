require 'helper'

class TestSass < Test::Unit::TestCase
  def site_configuration(overrides = {})
    Jekyll::Configuration::DEFAULTS.deep_merge(overrides).deep_merge({
      "source" => source_dir,
      "destination" => dest_dir
    })
  end

  def converter(overrides = {})
    Jekyll::Converters::Sass.new(site_configuration({"sass" => overrides}))
  end

  def sass_content
    <<-SASS
$font-stack: Helvetica, sans-serif
body
  font-family: $font-stack
  font-color: fuschia
SASS
  end

  def scss_content
    <<-SCSS
$font-stack: Helvetica, sans-serif;
body {
  font-family: $font-stack;
  font-color: fuschia;
}
SCSS
  end

  def css_output
    <<-CSS
body {\n  font-family: Helvetica, sans-serif;\n  font-color: fuschia; }
CSS
  end

  context "converting sass" do
    should "produce CSS" do
      assert_equal css_output, converter.convert(sass_content)
    end
  end

  context "converting SCSS" do
    should "produce CSS" do
      assert_equal css_output, converter.convert(scss_content)
    end
  end

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
  end
end
