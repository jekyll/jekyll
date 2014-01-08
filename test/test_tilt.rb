require 'helper'

class TestTilt < Test::Unit::TestCase

  def config
    @config ||= Jekyll.configuration({"source" => source_dir, "destination" => dest_dir})
  end

  def converter
    @converter ||= Converters::Tilt.new(@config)
  end

  def compare_output(relative_path, expected_output)
    converter.current_filename = fixture_path(relative_path)
    assert_equal expected_output, converter.convert(fixture(relative_path))
  end

  context "tilt" do
    context "when matching extnames to the Tilt converter" do
      should "match asciidoc extnames" do
        assert converter.matches(".ad")
        assert converter.matches(".adoc")
        assert converter.matches(".asciidoc")
      end

      should "match rdoc extname" do
        assert converter.matches(".rdoc")
      end

      should "match (media)wiki extnames" do
        assert converter.matches(".wiki")
        assert converter.matches(".mediawiki")
        assert converter.matches(".mw")
      end

      should "match slim extname" do
        assert converter.matches(".slim")
      end

      should "match Sass extnames" do
        assert converter.matches(".sass")
        assert converter.matches(".scss")
      end

      should "match less extname" do
        assert converter.matches(".less")
      end

      should "match coffeescript extname" do
        assert converter.matches(".coffee")
      end

      should "match creole extname" do
        assert converter.matches(".creole")
      end

      should "match mab extname" do
        assert converter.matches(".mab")
      end

      should "match radius extname" do
        assert converter.matches(".radius")
      end

      should "match builder extname" do
        assert converter.matches(".builder")
      end
    end

    context "converting content" do
      should "convert asciidoc" do
        compare_output("tilt/sample.asciidoc", "<div class=\"sect1\">\n<h2 id=\"_software\">Software</h2>\n<div class=\"sectionbody\">\n<div class=\"paragraph\">\n<p>You can install <em>package-name</em> using\nthe <code>gem</code> command:</p>\n</div>\n<div class=\"literalblock\">\n<div class=\"content\">\n<pre>gem install package-name</pre>\n</div>\n</div>\n</div>\n</div>")
      end

      should "convert rdoc" do
        compare_output("tilt/sample.rdoc", "\n<h2 id=\"label-Paragraphs\">Paragraphs</h2>\n\n<p>This is how a paragraph looks.  Since it is difficult to generate good\ncontent for paragraphs I have chosen to use <a\nhref=\"http://rikeripsum.com\">Riker Ipsum</a> for nonsense filler content. \nIn the previous sentence you can see how a link is formatted.</p>\n")
      end

      should "convert wiki" do
        compare_output("tilt/sample.mediawiki", "\n\n<h2><span class=\"editsection\">&#91;<a href=\"?section=Section\" title=\"Edit section: Section\">edit</a>&#93;</span> <a name=\"Section\"></a><span class=\"mw-headline\" id=\"Section\">Section</span></h2>\n\n\n\n<p>A single newline has no\neffect on the layout.\n</p>\n<p>Indentation as used on talk pages:\n<dl><dd>Each colon at the start of a line</dd></dl>\n</p>")
      end

      should "convert slim" do
        compare_output("tilt/sample.slim", "<!DOCTYPE html><html><head><title>Slim Examples</title></head></html>")
      end

      should "convert sass" do
        compare_output("tilt/sample.sass", ".lala {\n  font-size: 10px; }\n")
      end

      should "convert scss" do
        compare_output("tilt/sample.scss", ".lala {\n  font-size: 10px; }\n")
      end

      should "convert less" do
        compare_output("tilt/sample.less", "#header {\n  color: #4d926f;\n}\n")
      end

      should "convert CoffeeScript" do
        compare_output("tilt/sample.coffee", "(function() {\n  var hi;\n\n  hi = {\n    um: function() {\n      return console.log(\"yes\");\n    }\n  };\n\n}).call(this);\n")
      end

      should "convert creole" do
        compare_output("tilt/sample.creole", "<p>This is <strong>creole <em>markup</em></strong></p>")
      end

      should "convert mab" do
        compare_output("tilt/sample.mab", "<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/><title>Products</title></head><body><p style=\"color: green\">Notice</p>content</body></html>")
      end

      should "convert builder" do
        compare_output("tilt/sample.builder", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<my_elements>\n  <myitem>\n    <my_element_name>element_value</my_element_name>\n  </myitem>\n</my_elements>\n")
      end
    end

    context "when determining output extension" do
      %w[.ad .adoc .asciidoc .rdoc .wiki .creole .mediawiki .mw .slim .mab .radius].each do |extname|
        should "return '.html' output ext for #{extname}" do
          assert_equal ".html", converter.output_ext(extname)
        end
      end

      %w[.sass .scss .less].each do |extname|
        should "return '.css' output ext for #{extname}" do
          assert_equal ".css", converter.output_ext(extname)
        end
      end

      %w[.coffee].each do |extname|
        should "return '.js' output ext for #{extname}" do
          assert_equal ".js", converter.output_ext(extname)
        end
      end

      %w[.builder].each do |extname|
        should "return '.xml' output ext for #{extname}" do
          assert_equal ".xml", converter.output_ext(extname)
        end
      end
    end
  end
end
