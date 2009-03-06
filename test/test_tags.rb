require File.dirname(__FILE__) + '/helper'

class TestTags < Test::Unit::TestCase
  context "tagging" do
    setup do
      @content = <<CONTENT
---
layout: post
title: This is a test

---
This document results in a markdown error with maruku
{% highlight ruby %}
puts "hi"

puts "bye"
{% endhighlight %}

CONTENT
    end

    should "render markdown with pygments line handling" do
      Jekyll.pygments = true
      Jekyll.content_type = :markdown

      result = Liquid::Template.parse(@content).render({}, [Jekyll::Filters])
      result = Jekyll.markdown_proc.call(result)
      assert_no_match(/markdown\-html\-error/,result)
    end
  end
end
