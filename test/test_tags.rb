require File.dirname(__FILE__) + '/helper'

class TestTags < Test::Unit::TestCase

  def create_post(code)
    stub(Jekyll).configuration do
      Jekyll::DEFAULTS.merge({'pygments' => true})
    end
    site = Site.new(Jekyll.configuration)
    info = { :filters => [Jekyll::Filters], :registers => { :site => site } }

    content = <<CONTENT
---
title: This is a test
---

This document results in a markdown error with maruku

{% highlight text %}
#{code}
{% endhighlight %}
CONTENT

    @result = Liquid::Template.parse(content).render({}, info)
    @result = site.markdown(@result)
  end

  context "post content has highlight tag" do
    setup do
      create_post("test")
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
      create_post("Æ")
    end

    should "render markdown with pygments line handling" do
      assert_match %{<pre>Æ\n</pre>}, @result
    end
  end
end
