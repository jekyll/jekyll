# coding: utf-8

require 'helper'

class TestTags < Test::Unit::TestCase

  def create_post(content, override = {}, converter_class = Jekyll::MarkdownConverter)
    stub(Jekyll).configuration do
      Jekyll::DEFAULTS.deep_merge({'pygments' => true}).deep_merge(override)
    end
    site = Site.new(Jekyll.configuration)

    if override['read_posts']
      site.read_posts('')
    end

    info = { :filters => [Jekyll::Filters], :registers => { :site => site } }
    @converter = site.converters.find { |c| c.class == converter_class }
    payload = { "pygments_prefix" => @converter.pygments_prefix,
                "pygments_suffix" => @converter.pygments_suffix }

    @result = Liquid::Template.parse(content).render(payload, info)
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
      r = Jekyll::HighlightBlock::SYNTAX
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
    should "work" do
      tag = Jekyll::HighlightBlock.new('highlight', 'ruby ', ["test", "{% endhighlight %}", "\n"])
      assert_equal({}, tag.instance_variable_get(:@options))

      tag = Jekyll::HighlightBlock.new('highlight', 'ruby linenos ', ["test", "{% endhighlight %}", "\n"])
      assert_equal({ 'linenos' => 'inline' }, tag.instance_variable_get(:@options))

      tag = Jekyll::HighlightBlock.new('highlight', 'ruby linenos=table ', ["test", "{% endhighlight %}", "\n"])
      assert_equal({ 'linenos' => 'table' }, tag.instance_variable_get(:@options))

      tag = Jekyll::HighlightBlock.new('highlight', 'ruby linenos=table nowrap', ["test", "{% endhighlight %}", "\n"])
      assert_equal({ 'linenos' => 'table', 'nowrap' => true }, tag.instance_variable_get(:@options))

      tag = Jekyll::HighlightBlock.new('highlight', 'ruby linenos=table cssclass=hl', ["test", "{% endhighlight %}", "\n"])
      assert_equal({ 'cssclass' => 'hl', 'linenos' => 'table' }, tag.instance_variable_get(:@options))
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
      assert_match %{<pre><code class='text'>test\n</code></pre>}, @result
    end

    should "render markdown with pygments with line numbers" do
      assert_match %{<pre><code class='text'><span class='lineno'>1</span> test\n</code></pre>}, @result
    end
  end

  context "post content has highlight with file reference" do
    setup do
      fill_post("./jekyll.gemspec")
    end

    should "not embed the file" do
      assert_match %{<pre><code class='text'>./jekyll.gemspec\n</code></pre>}, @result
    end
  end

  context "post content has highlight tag with UTF character" do
    setup do
      fill_post("Æ")
    end

    should "render markdown with pygments line handling" do
      assert_match %{<pre><code class='text'>Æ\n</code></pre>}, @result
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
        create_post(@content, {}, Jekyll::TextileConverter)
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
end
