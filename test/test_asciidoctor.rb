require File.dirname(__FILE__) + '/helper'

class TestAsciidoctor < Test::Unit::TestCase

  context "Default hardbreaks disabled w/ asciidoc section, no hardbreaks attribute" do
    setup do
      config = {
        'asciidoc'         => 'asciidoctor',
        'asciidoctor'      => {}
        }
      @asciidoc = Converters::AsciiDoc.new config
    end
    
    should "not preserve single line breaks in HTML output" do 
      assert_equal "<div class=\"paragraph\">\n<p>line1\nline2</p>\n</div>", @asciidoc.convert("line1\nline2").strip.gsub(/^ *(\n|(?=[^ ]))/, '')
    end
  end

  context "Asciidoctor with hardbreaks enabled" do
    setup do
      config = {
        'asciidoc'      => 'asciidoctor',
        'asciidoctor'   => {
          'hardbreaks'  => '' # default
        }
      }
      @asciidoc = Converters::AsciiDoc.new config
    end
    
    should "preserve single line breaks in HTML output" do 
      assert_equal "<div class=\"paragraph\">\n<p>line1<br>\nline2</p>\n</div>", @asciidoc.convert("line1\nline2").strip.gsub(/^ *(\n|(?=[^ ]))/, '')
    end
  end

  context "Asciidoctor with title enabled" do
    setup do
      config = {
        'asciidoc'      => 'asciidoctor',
        'asciidoctor'   => {
          'notitle!'    => '' # default
        }
      }
      @asciidoc = Converters::AsciiDoc.new config
    end
    
    should "shows title as h1 heading" do 
      assert_equal "<h1>Header</h1>", @asciidoc.convert("= Header").strip.gsub(/^ *(\n|(?=[^ ]))/, '')
    end
  end

end
