require 'helper'

class TestRedcarpet < Test::Unit::TestCase
  context "redcarpet" do
    setup do
      @config = {
        'redcarpet' => { 'extensions' => ['smart', 'strikethrough', 'filter_html'] },
        'markdown' => 'redcarpet'
      }
      @markdown = Converters::Markdown.new @config
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

    context "with pygments enabled" do
      setup do
        @markdown = Converters::Markdown.new @config.merge({ 'highlighter' => 'pygments' })
      end

      should "render fenced code blocks with syntax highlighting" do
        assert_equal "<div class=\"highlight\"><pre><code class=\"language-ruby\" data-lang=\"ruby\"><span class=\"nb\">puts</span> <span class=\"s2\">&quot;Hello world&quot;</span></code></pre></div>", @markdown.convert(
          <<-EOS
```ruby
puts "Hello world"
```
          EOS
        ).strip
      end
    end

    context "with pygments enabled" do
      setup do
        @markdown = Converters::Markdown.new @config.merge({
          'highlighter' => 'pygments',
          'tags' => { 'highlight' => { 'linenos' => true } }
        })
      end

      should "render fenced code blocks with syntax highlighting and line numbers" do
        assert_equal "<div class=\"highlight\"><pre><code class=\"language-ruby\" data-lang=\"ruby\"><span class=\"lineno\">1</span> <span class=\"nb\">puts</span> <span class=\"s2\">&quot;Hello world&quot;</span></code></pre></div>", @markdown.convert(
          <<-EOS
```ruby
puts "Hello world"
```
          EOS
        ).strip
      end
    end

    context "with rouge enabled" do
      setup do
        @markdown = Converters::Markdown.new @config.merge({ 'highlighter' => 'rouge' })
      end

      should "render fenced code blocks with syntax highlighting" do
        assert_equal "<div class=\"highlight\"><pre><code class=\"language-ruby\" data-lang=\"ruby\"><span class=\"nb\">puts</span> <span class=\"s2\">\"Hello world\"</span></code></pre></div>", @markdown.convert(
          <<-EOS
```ruby
puts "Hello world"
```
          EOS
        ).strip
      end
    end

    context "with rouge enabled " do
      setup do
        @markdown = Converters::Markdown.new @config.merge({
          'highlighter' => 'rouge',
          'tags' => { 'highlight' => { 'linenos' => true } }
        })
      end

      should "render fenced code blocks with syntax highlighting and line numbers" do
        assert_equal "<div class=\"highlight\"><pre><code class=\"language-ruby\" data-lang=\"ruby\"><table style=\"border-spacing: 0\"><tbody><tr><td class=\"gutter gl\" style=\"text-align: right\"><pre class=\"lineno\">1</code></pre></td><td class=\"code\"><pre><span class=\"nb\">puts</span> <span class=\"s2\">\"Hello world\"</span>\n</pre></td></tr></tbody></table>\n</pre></div>", @markdown.convert(
          <<-EOS
```ruby
puts "Hello world"
```
          EOS
        ).strip
      end
    end

    context "without any highlighter" do
      setup do
        @markdown = Converters::Markdown.new @config.merge({ 'highlighter' => nil })
      end

      should "render fenced code blocks without syntax highlighting" do
        assert_equal "<div class=\"highlight\"><pre><code class=\"language-ruby\" data-lang=\"ruby\">puts &quot;Hello world&quot;</code></pre></div>", @markdown.convert(
          <<-EOS
```ruby
puts "Hello world"
```
          EOS
        ).strip
      end
    end
  end
end
