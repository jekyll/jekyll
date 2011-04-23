require File.dirname(__FILE__) + '/helper'

class TestTags < Test::Unit::TestCase

  def create_post(content, override = {}, markdown = true)
    stub(Jekyll).configuration do
      Jekyll::DEFAULTS.merge({'pygments' => true}).merge(override)
    end
    site = Site.new(Jekyll.configuration)
    info = { :filters => [Jekyll::Filters], :registers => { :site => site } }

    if markdown
      payload = {"content_type" => "markdown"}
    else
      payload = {"content_type" => "textile"}
    end

    @result = Liquid::Template.parse(content).render(payload, info)

    if markdown
      @result = site.markdown(@result)
    else
      @result = site.textile(@result)
    end
  end

  def fill_post(code, override = {})
    content = <<CONTENT
---
title: This is a test
---

This document results in a markdown error with maruku

{% highlight text %}
#{code}
{% endhighlight %}
CONTENT
    create_post(content, override)
  end

  context "post content has highlight tag" do
    setup do
      fill_post("test")
    end

    should "not cause a markdown error" do
      assert_no_match /markdown\-html\-error/, @result
    end

    should "render markdown with pygments line handling" do
      assert_match %{<pre><code class='text'>test\n</code></pre>}, @result
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
        create_post(@content, {}, false)
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
  end
end
