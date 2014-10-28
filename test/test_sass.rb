require 'helper'

class TestSass < Test::Unit::TestCase
  context "converting Sass page" do
    setup do
      @site = Jekyll::Site.new(Jekyll.configuration({
        "source" => source_dir,
        "destination" => dest_dir
      }))
      @site.process
    end

    context "for importing partials" do
      setup do
        @file_path = dest_dir("css/main.css")
      end

      should "import SCSS partial" do
        assert_equal ".half {\n  width: 50%; }\n", File.read(@file_path)
      end

      should "register the SCSS converter" do
        assert !!@site.getConverterImpl(Jekyll::Converters::Scss), "SCSS converter implementation should exist."
      end

      should "register the Sass converter" do
        assert !!@site.getConverterImpl(Jekyll::Converters::Sass), "Sass converter implementation should exist."
      end
    end

    context "for fingerprinted URL" do
      setup do
        @fingerprint = "2a3566184226031fbd615d26327872e7"
        @file_path = dest_dir("css/main-fingerprint-#{@fingerprint}.css")
      end

      should "create the file" do
        assert File.exist?(@file_path)
      end

      should "convert SCSS" do
        expected = <<-END
.half {
  width: 50%; }

p {
  background-image: url("/css/main-fingerprint-#{@fingerprint}.css"); }
        END
        assert_equal expected, File.read(@file_path)
      end

      should "create the fingerprint from the result of the conversion, but before liquid parsing" do
        content = <<-END
.half {
  width: 50%; }

p {
  background-image: url("{{ page.url }}"); }
        END
        assert @file_path.include?(Digest::MD5.hexdigest(content))
      end
    end
  end
end
