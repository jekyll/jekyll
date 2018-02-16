# frozen_string_literal: true

require "helper"

class TestRdiscount < JekyllUnitTest
  context "rdiscount" do
    setup do
      if jruby?
        then skip(
          "JRuby does not perform well with CExt, test disabled."
        )
      end

      config = {
        "markdown"  => "rdiscount",
        "rdiscount" => {
          "toc_token"  => "{:toc}",
          "extensions" => %w(smart generate_toc),
        },
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
      assert_equal toc.strip,
                   @markdown.convert("# Header 1\n\n## Header 2\n\n{:toc}").strip
    end
  end
end
