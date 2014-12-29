require 'helper'

class TestRdiscount < Test::Unit::TestCase

  context "rdiscount" do
    setup do
      config = {
        'markdown' => 'rdiscount',
        'rdiscount' => { 'extensions' => ['smart', 'generate_toc'], 'toc_token' => '{:toc}' }
      }
      @markdown = Converters::Markdown.new config
    end

    should "pass rdiscount extensions" do
      assert_equal "<p>&ldquo;smart&rdquo;</p>", @markdown.convert('"smart"').strip
    end

    should "render toc" do
      toc = <<-TOC
<a name="Header.1"></a>
<h1>Header 1</h1>

<a name="Header.2"></a>
<h2>Header 2</h2>

<p><ul>
 <li><a href="#Header.1">Header 1</a>
 <ul>
  <li><a href="#Header.2">Header 2</a></li>
 </ul>
 </li>
</ul>

</p>
TOC
      assert_equal toc.strip, @markdown.convert("# Header 1\n\n## Header 2\n\n{:toc}").strip
    end
  end
end
