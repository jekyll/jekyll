---
layout: docs
title: Extras
prev_section: plugins
next_section: github-pages
permalink: /docs/extras/
---

There are a number of (optional) extra features that Jekyll supports that you
may want to install, depending on how you plan to use Jekyll.

## Alternative Markdown Processors

While Jekyll defaults to using kramdown for Markdown conversion, you may use one
of the other pre-defined markdown parsers or define your own.

### RDiscount

If you prefer to use [RDiscount](http://github.com/rtomayko/rdiscount) instead
of [kramdown](http://kramdown.gettalong.org/) for Markdown, just make sure you have
it installed:

{% highlight bash %}
$ [sudo] gem install rdiscount
{% endhighlight %}

And then specify RDiscount as the Markdown engine in your `_config.yml` file to
have Jekyll run with that option.

{% highlight yaml %}
# In _config.yml
markdown: rdiscount
{% endhighlight %}

### User-Defined

So, you're totally at odds with our four built-in markdown parsers, eh? No
sweat. You can define one as a plugin:

{% highlight ruby %}
require 'jekyll'
require 'some_renderer'

class Jekyll::Converters::Markdown::MyCustomParser
  def initialize(config)
    @site_config = config
  end

  def convert(content)
    # (this _must_ return the resulting String after the rendering)
    SomeRenderer.new(@site_config).to_html(content)
  end
end
{% endhighlight %}

Once you've got that setup, ask Jekyll to use your custom markdown parser in
your `_config.yml` file:

{% highlight yaml %}
markdown: MyCustomParser
{% endhighlight %}

(Note that this **is case-sensitive**, and is only the piece after
`Jekyll::Converters::Markdown`.) And there you are!
