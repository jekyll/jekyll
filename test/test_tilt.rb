require 'helper'

class TestTilt < Test::Unit::TestCase
  context "tilt" do
    setup do
      @config = Jekyll.configuration({"source" => source_dir, "destination" => dest_dir})
      @converter = Converters::Tilt.new @config
    end

    context "when matching tilt converter" do
      %w[
        .ad .adoc .asciidoc .rdoc .wiki .creole .mediawiki .mw .slim .mab .radius
        .sass .scss .less .coffee .builder .yajl .rcsv
      ].each do |extname|
        should "return match the tilt converter" do
          assert @converter.matches(extname)
        end
      end
    end

    context "converting content" do
      context "converting asciidoc" do

      end
    end

    context "when determining output extension" do
      %w[.ad .adoc .asciidoc .rdoc .wiki .creole .mediawiki .mw .slim .mab .radius].each do |extname|
        should "return '.html' output ext for #{extname}" do
          assert_equal ".html", @converter.output_ext(extname)
        end
      end

      %w[.sass .scss .less].each do |extname|
        should "return '.css' output ext for #{extname}" do
          assert_equal ".css", @converter.output_ext(extname)
        end
      end

      %w[.coffee].each do |extname|
        should "return '.js' output ext for #{extname}" do
          assert_equal ".js", @converter.output_ext(extname)
        end
      end

      %w[.builder].each do |extname|
        should "return '.xml' output ext for #{extname}" do
          assert_equal ".xml", @converter.output_ext(extname)
        end
      end

      %w[.yajl].each do |extname|
        should "return '.json' output ext for #{extname}" do
          assert_equal ".json", @converter.output_ext(extname)
        end
      end

      %w[.rcsv].each do |extname|
        should "return '.csv' output ext for #{extname}" do
          assert_equal ".csv", @converter.output_ext(extname)
        end
      end
    end
  end
end
