require 'helper'

class TestSass < Test::Unit::TestCase
  def site_configuration(overrides = {})
    Jekyll::Configuration::DEFAULTS.deep_merge(overrides).deep_merge({
      "source" => source_dir,
      "destination" => dest_dir
    })
  end

  def converter(overrides = {})
    Jekyll::Sass.new(site_configuration({"sass" => overrides}))
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

  context "matching file extensions" do
    should "match .scss files" do
      assert converter.matches(".scss")
    end

    should "match .sass files" do
      assert converter.matches(".sass")
    end
  end

  context "determining the output file extension" do
    should "output .css file extension" do
      assert_equal ".css", converter.output_ext(".sass")
    end
  end

  context "when building configurations" do
    should "not allow caching in safe mode" do
      verter = converter
      verter.instance_variable_get(:@config)["safe"] = true
      assert_equal false, verter.sass_configs[:cache]
    end

    should "allow caching in unsafe mode" do
      assert_equal true, converter.sass_configs[:cache]
    end

    should "set the load paths to the _sass dir relative to site source" do
      assert_equal [source_dir("_sass")], converter.sass_configs[:load_paths]
    end

    should "allow the user to specify a different sass dir" do
      assert_equal [source_dir("_scss")], converter({"sass_dir" => "_scss"}).sass_configs[:load_paths]
    end

    should "set syntax :scss when SCSS content" do
      assert_equal :scss, converter.sass_configs(scss_content)[:syntax]
    end

    should "set syntax :sass when Sass content" do
      assert_equal :sass, converter.sass_configs(sass_content)[:syntax]
    end

    should "default to :sass syntax when content is empty" do
      assert_equal :sass, converter.sass_configs[:syntax]
    end

    should "not allow sass_dirs outside of site source" do
      assert_equal source_dir("etc/passwd"), converter({"sass_dir" => "/etc/passwd"}).sass_dir_relative_to_site_source
    end

    should "override user-set syntax based on content" do
      assert_equal :sass, converter({"syntax" => :scss}).sass_configs(sass_content)[:syntax]
    end
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
end
