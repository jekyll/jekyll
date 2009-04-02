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
      stub(Jekyll).configuration do
        Jekyll::DEFAULTS.merge({'pygments' => true})
      end
      site = Site.new(Jekyll.configuration)
      info = { :filters => [Jekyll::Filters], :registers => { :site => site } }

      result = Liquid::Template.parse(@content).render({}, info)
      result = site.markdown(result)
      assert_no_match(/markdown\-html\-error/,result)
    end
  end
end
