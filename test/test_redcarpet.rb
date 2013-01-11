require 'helper'

class TestRedcarpet < Test::Unit::TestCase
  context "redcarpet" do
    setup do
      config = {
        'redcarpet' => { 'extensions' => ['smart', 'strikethrough', 'filter_html'] },
        'markdown' => 'redcarpet'
      }
      @markdown = MarkdownConverter.new config
    end

    should "pass redcarpet options" do
      assert_equal "<h1>Some Header</h1>", @markdown.convert('# Some Header #').strip
    end
    
    should "pass redcarpet SmartyPants options" do
      assert_equal "<p>&ldquo;smart&rdquo;</p>", @markdown.convert('"smart"').strip
    end

    should "pass redcarpet extensions" do
      assert_equal "<p><del>deleted</del></p>", @markdown.convert('~~deleted~~').strip
    end

    should "pass redcarpet render options" do
      assert_equal "<p><strong>bad code not here</strong>: i am bad</p>", @markdown.convert('**bad code not here**: <script>i am bad</script>').strip
    end

    should "render fenced code blocks" do
      assert_equal "<div class=\"highlight\"><pre><code class=\"ruby\"><span class=\"nb\">puts</span> <span class=\"s2\">&quot;Hello world&quot;</span>\n</code></pre></div>", @markdown.convert(
        <<-EOS
```ruby
puts "Hello world"
```
EOS
      ).strip  
    end
  end
end
