# coding: utf-8

require 'helper'

class TestRouge < Test::Unit::TestCase

  def create_post(content, override = {}, converter_class = Jekyll::Converters::Markdown)
    stub(Jekyll).configuration do
      site_configuration({
        "highlighter" => "rouge"
      }.merge(override))
    end
    site = Site.new(Jekyll.configuration)

    if override['read_posts']
      site.read_posts('')
    end

    info = { :filters => [Jekyll::Filters], :registers => { :site => site } }
    @converter = site.converters.find { |c| c.class == converter_class }
    payload = { "highlighter_prefix" => @converter.highlighter_prefix,
                "highlighter_suffix" => @converter.highlighter_suffix }

    @result = Liquid::Template.parse(content).render!(payload, info)
    @result = @converter.convert(@result)
  end

  def fill_post(code, override = {})
    content = <<CONTENT
{% highlight text %}
#{code}
{% endhighlight %}
{% highlight text linenos %}
#{code}
{% endhighlight %}
CONTENT
    create_post(content, override)
  end

  def highlight_block_with_opts(options_string)
    Jekyll::Tags::HighlightBlock.parse('highlight', options_string, ["test", "{% endhighlight %}", "\n"], {})
  end

  context "post content has highlight tag" do
    setup do
      fill_post("test")
    end

    should "render markdown with rouge" do
      assert_match %{<pre><code class="language-text" data-lang="text">test</code></pre>}, @result
    end

    should "render markdown with rouge with line numbers" do
      assert_match %{<pre><code class="language-text" data-lang="text"><table style="border-spacing: 0"><tbody><tr><td class="gutter gl" style="text-align: right"><pre class="lineno">1</pre></td><td class="code"><pre>test<span class="w">\n</span></pre></td></tr></tbody></table></code></pre>}, @result
    end
  end

end
