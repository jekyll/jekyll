require File.dirname(__FILE__) + '/helper'

class TestTags < Test::Unit::TestCase

  def create_post(content, override = {})
    stub(Jekyll).configuration do
      Jekyll::DEFAULTS.merge({'pygments' => true}).merge(override)
    end
    site = Site.new(Jekyll.configuration)
    info = { :filters => [Jekyll::Filters], :registers => { :site => site } }

    @result = Liquid::Template.parse(content).render({}, info)
    @result = site.markdown(@result)
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
      assert_match %{<pre>test\n</pre>}, @result
    end
  end

  context "post content has highlight tag with UTF character" do
    setup do
      fill_post("Æ")
    end

    should "render markdown with pygments line handling" do
      assert_match %{<pre>Æ\n</pre>}, @result
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

    context "using Maruku" do
      setup do
        create_post(@content)
      end

      should "parse correctly" do
        assert_match %{<em>FIGHT!</em>}, @result
        assert_match %{<em>FINISH HIM</em>}, @result
      end
    end

    context "using RDiscount" do
      setup do
        create_post(@content, 'markdown' => 'rdiscount')
      end

      should "parse correctly" do
        assert_match %{<em>FIGHT!</em>}, @result
        assert_match %{<em>FINISH HIM</em>}, @result
      end
    end
  end
end
