# coding: utf-8

require 'helper'

class TestTags < Test::Unit::TestCase

  def create_post(content, override = {}, converter_class = Jekyll::Converters::Markdown)
    stub(Jekyll).configuration do
      Jekyll::Configuration::DEFAULTS.deep_merge({'highlighter' => 'pygments'}).deep_merge(override)
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
---
title: This is a test
---

This document results in a markdown error with maruku

{% highlight text %}#{code}{% endhighlight %}
{% highlight text linenos %}#{code}{% endhighlight %}
CONTENT
    create_post(content, override)
  end

  context "language name" do
    should "match only the required set of chars" do
      r = Jekyll::Tags::HighlightBlock::SYNTAX
      assert_match r, "ruby"
      assert_match r, "c#"
      assert_match r, "xml+cheetah"
      assert_match r, "x.y"
      assert_match r, "coffee-script"

      assert_no_match r, "blah^"

      assert_match r, "ruby key=val"
      assert_match r, "ruby a=b c=d"
    end
  end

  context "initialized tag" do
    should "set the correct options" do
      tag = Jekyll::Tags::HighlightBlock.new('highlight', 'ruby ', ["test", "{% endhighlight %}", "\n"])
      assert_equal({}, tag.instance_variable_get(:@options))

      tag = Jekyll::Tags::HighlightBlock.new('highlight', 'ruby linenos ', ["test", "{% endhighlight %}", "\n"])
      assert_equal({ 'linenos' => 'inline' }, tag.instance_variable_get(:@options))

      tag = Jekyll::Tags::HighlightBlock.new('highlight', 'ruby linenos=table ', ["test", "{% endhighlight %}", "\n"])
      assert_equal({ 'linenos' => 'table' }, tag.instance_variable_get(:@options))

      tag = Jekyll::Tags::HighlightBlock.new('highlight', 'ruby linenos=table nowrap', ["test", "{% endhighlight %}", "\n"])
      assert_equal({ 'linenos' => 'table', 'nowrap' => true }, tag.instance_variable_get(:@options))

      tag = Jekyll::Tags::HighlightBlock.new('highlight', 'ruby linenos=table cssclass=hl', ["test", "{% endhighlight %}", "\n"])
      assert_equal({ 'cssclass' => 'hl', 'linenos' => 'table' }, tag.instance_variable_get(:@options))

      tag = Jekyll::Tags::HighlightBlock.new('highlight', 'Ruby ', ["test", "{% endhighlight %}", "\n"])
      assert_equal "ruby", tag.instance_variable_get(:@lang), "lexers should be case insensitive"
    end
  end

  context "post content has highlight tag" do
    setup do
      fill_post("test")
    end

    should "not cause a markdown error" do
      assert_no_match /markdown\-html\-error/, @result
    end

    should "render markdown with pygments" do
      assert_match %{<pre><code class="text">test\n</code></pre>}, @result
    end

    should "render markdown with pygments with line numbers" do
      assert_match %{<pre><code class="text"><span class="lineno">1</span> test\n</code></pre>}, @result
    end
  end

  context "post content has highlight with file reference" do
    setup do
      fill_post("./jekyll.gemspec")
    end

    should "not embed the file" do
      assert_match %{<pre><code class="text">./jekyll.gemspec\n</code></pre>}, @result
    end
  end

  context "post content has highlight tag with UTF character" do
    setup do
      fill_post("Æ")
    end

    should "render markdown with pygments line handling" do
      assert_match %{<pre><code class="text">Æ\n</code></pre>}, @result
    end
  end

  context "simple post with markdown and pre tags" do
    setup do
      @content = <<CONTENT
---
title: Maruku vs. RDiscount
---

_FIGHT!_

{% highlight ruby %}
puts "3..2..1.."
{% endhighlight %}

*FINISH HIM*
CONTENT
    end

    context "using Textile" do
      setup do
        create_post(@content, {}, Jekyll::Converters::Textile)
      end

      # Broken in RedCloth 4.1.9
      should "not textilize highlight block" do
        assert_no_match %r{3\.\.2\.\.1\.\.&quot;</span><br />}, @result
      end
    end

    context "using Maruku" do
      setup do
        create_post(@content)
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r{<em>FINISH HIM</em>}, @result
      end
    end

    context "using RDiscount" do
      setup do
        create_post(@content, 'markdown' => 'rdiscount')
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r{<em>FINISH HIM</em>}, @result
      end
    end

    context "using Kramdown" do
      setup do
        create_post(@content, 'markdown' => 'kramdown')
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r{<em>FINISH HIM</em>}, @result
      end
    end

    context "using Redcarpet" do
      setup do
        create_post(@content, 'markdown' => 'redcarpet')
      end

      should "parse correctly" do
        assert_match %r{<em>FIGHT!</em>}, @result
        assert_match %r{<em>FINISH HIM</em>}, @result
      end
    end
  end

  context "simple page with post linking" do
    setup do
      content = <<CONTENT
---
title: Post linking
---

{% post_url 2008-11-21-complex %}
CONTENT
      create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
    end

    should "not cause an error" do
      assert_no_match /markdown\-html\-error/, @result
    end

    should "have the url to the \"complex\" post from 2008-11-21" do
      assert_match %r{/2008/11/21/complex/}, @result
    end
  end

  context "simple page with nested post linking" do
    setup do
      content = <<CONTENT
---
title: Post linking
---

- 1 {% post_url 2008-11-21-complex %}
- 2 {% post_url /2008-11-21-complex %}
- 3 {% post_url es/2008-11-21-nested %}
- 4 {% post_url /es/2008-11-21-nested %}
CONTENT
      create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
    end

    should "not cause an error" do
      assert_no_match /markdown\-html\-error/, @result
    end

    should "have the url to the \"complex\" post from 2008-11-21" do
      assert_match %r{1\s/2008/11/21/complex/}, @result
      assert_match %r{2\s/2008/11/21/complex/}, @result
    end

    should "have the url to the \"nested\" post from 2008-11-21" do
      assert_match %r{3\s/2008/11/21/nested/}, @result
      assert_match %r{4\s/2008/11/21/nested/}, @result
    end
  end

  context "simple page with invalid post name linking" do
    should "cause an error" do
      content = <<CONTENT
---
title: Invalid post name linking
---

{% post_url abc2008-11-21-complex %}
CONTENT

      assert_raise ArgumentError do
        create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
      end
    end
  end

  context "gist tag" do
    context "simple" do
      setup do
        @gist = 358471
        content = <<CONTENT
---
title: My Cool Gist
---

{% gist #{@gist} %}
CONTENT
        create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
      end

      should "write script tag" do
        assert_match "<script src=\"https://gist.github.com/#{@gist}.js\">\s</script>", @result
      end
    end

    context "for private gist" do
      context "when valid" do
        setup do
          @gist = "mattr-/24081a1d93d2898ecf0f"
          @filename = "myfile.ext"
          content = <<CONTENT
  ---
  title: My Cool Gist
  ---

  {% gist #{@gist} #{@filename} %}
CONTENT
          create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
        end

        should "write script tag with specific file in gist" do
          assert_match "<script src=\"https://gist.github.com/#{@gist}.js?file=#{@filename}\">\s</script>", @result
        end
      end

      should "raise ArgumentError when invalid" do
        @gist = "mattr-24081a1d93d2898ecf0f"
        @filename = "myfile.ext"
        content = <<CONTENT
  ---
  title: My Cool Gist
  ---

  {% gist #{@gist} #{@filename} %}
CONTENT

        assert_raise ArgumentError do
          create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
        end
      end
    end

    context "with specific file" do
      setup do
        @gist = 358471
        @filename = 'somefile.rb'
        content = <<CONTENT
---
title: My Cool Gist
---

{% gist #{@gist} #{@filename} %}
CONTENT
        create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
      end

      should "write script tag with specific file in gist" do
        assert_match "<script src=\"https://gist.github.com/#{@gist}.js?file=#{@filename}\">\s</script>", @result
      end
    end

    context "with blank gist id" do
      should "raise ArgumentError" do
        content = <<CONTENT
---
title: My Cool Gist
---

{% gist %}
CONTENT

        assert_raise ArgumentError do
          create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
        end
      end
    end

    context "with invalid gist id" do
      should "raise ArgumentError" do
        invalid_gist = 'invalid'
        content = <<CONTENT
---
title: My Cool Gist
---

{% gist #{invalid_gist} %}
CONTENT

        assert_raise ArgumentError do
          create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
        end
      end
    end
  end

  context "include tag with parameters" do
    context "with one parameter" do
      setup do
        content = <<CONTENT
---
title: Include tag parameters
---

{% include sig.markdown myparam="test" %}

{% include params.html param="value" %}
CONTENT
        create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
      end

      should "correctly output include variable" do
        assert_match "<span id=\"include-param\">value</span>", @result.strip
      end

      should "ignore parameters if unused" do
        assert_match "<hr />\n<p>Tom Preston-Werner\ngithub.com/mojombo</p>\n", @result
      end
    end

    context "with invalid parameter syntax" do
      should "throw a ArgumentError" do
        content = <<CONTENT
---
title: Invalid parameter syntax
---

{% include params.html param s="value" %}
CONTENT
        assert_raise ArgumentError, 'Did not raise exception on invalid "include" syntax' do
          create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
        end

        content = <<CONTENT
---
title: Invalid parameter syntax
---

{% include params.html params="value %}
CONTENT
        assert_raise ArgumentError, 'Did not raise exception on invalid "include" syntax' do
          create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
        end
      end
    end

    context "with several parameters" do
      setup do
        content = <<CONTENT
---
title: multiple include parameters
---

{% include params.html param1="new_value" param2="another" %}
CONTENT
        create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
      end

      should "list all parameters" do
        assert_match '<li>param1 = new_value</li>', @result
        assert_match '<li>param2 = another</li>', @result
      end

      should "not include previously used parameters" do
        assert_match "<span id=\"include-param\"></span>", @result
      end
    end

    context "without parameters" do
      setup do
        content = <<CONTENT
---
title: without parameters
---

{% include params.html %}
CONTENT
        create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
      end

      should "include file with empty parameters" do
        assert_match "<span id=\"include-param\"></span>", @result
      end
    end

    context "without parameters within if statement" do
      setup do
        content = <<CONTENT
---
title: without parameters within if statement
---

{% if true %}{% include params.html %}{% endif %}
CONTENT
        create_post(content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
      end

      should "include file with empty parameters within if statement" do
        assert_match "<span id=\"include-param\"></span>", @result
      end
    end

    context "with fenced code blocks with backticks" do

      setup do
        content = <<CONTENT
```ruby
puts "Hello world"
```
CONTENT
        create_post(content, {
          'markdown' => 'maruku',
          'maruku' => {'fenced_code_blocks' => true}}
        )
      end

      # todo: if #112 is merged into maruku, update to remove the newlines inside code block
      should "render fenced code blocks" do
        assert_match %r{<pre class=\"ruby\"><code class=\"ruby\">\nputs &quot;Hello world&quot;\n</code></pre>}, @result.strip
      end
    end

    context "include missing file" do
      setup do
        @content = <<CONTENT
---
title: missing file
---

{% include missing.html %}
CONTENT
      end

      should "raise error relative to source directory" do
        exception = assert_raise IOError do
          create_post(@content, {'permalink' => 'pretty', 'source' => source_dir, 'destination' => dest_dir, 'read_posts' => true})
        end
        assert_equal 'Included file \'_includes/missing.html\' not found', exception.message
      end
    end

    context "include tag with variable and liquid filters" do
      setup do
        stub(Jekyll).configuration do
          Jekyll::Configuration::DEFAULTS.deep_merge({'pygments' => true}).deep_merge({'source' => source_dir, 'destination' => dest_dir})
        end

        site = Site.new(Jekyll.configuration)
        post = Post.new(site, source_dir, '', "2013-12-17-include-variable-filters.markdown")
        layouts = { "default" => Layout.new(site, source_dir('_layouts'), "simple.html")}
        post.render(layouts, {"site" => {"posts" => []}})
        @content = post.content
      end

      should "include file as variable with liquid filters" do
        assert_match %r{1 included}, @content
        assert_match %r{2 included}, @content
        assert_match %r{3 included}, @content
      end

      should "include file as variable and liquid filters with arbitrary whitespace" do
        assert_match %r{4 included}, @content
        assert_match %r{5 included}, @content
        assert_match %r{6 included}, @content
      end

      should "include file as variable and filters with additional parameters" do
        assert_match '<li>var1 = foo</li>', @content
        assert_match '<li>var2 = bar</li>', @content
      end
    end
  end
end
