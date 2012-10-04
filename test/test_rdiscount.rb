require 'helper'

class TestRdiscount < Test::Unit::TestCase

  context "rdiscount" do
    setup do
      config = {
        'markdown' => 'rdiscount',
        'rdiscount' => { 'extensions' => ['smart', 'generate_toc'], 'toc_token' => '{:toc}' }
      }
      @markdown = MarkdownConverter.new config
    end

    should "pass rdiscount extensions" do
      assert_equal "<p>&ldquo;smart&rdquo;</p>", @markdown.convert('"smart"').strip
    end

    should "render toc" do
      assert_equal "<h1 id=\"Header+1\">Header 1</h1>\n\n<h2 id=\"Header+2\">Header 2</h2>\n\n<p>\n <ul>\n <li><a href=\"#Header+1\">Header 1</a>\n  <ul>\n  <li><a href=\"#Header+2\">Header 2</a>  </li>\n  </ul>\n </li>\n </ul>\n\n</p>", @markdown.convert("# Header 1\n\n## Header 2\n\n{:toc}").strip
    end
  end
end
