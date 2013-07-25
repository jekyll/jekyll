---
layout: docs
title: Quick-start guide
prev_section: home
next_section: installation
permalink: /docs/quickstart/
---

For the impatient, here's how to get a boilerplate Jekyll site up and running.

{% highlight bash %}
~ $ gem install jekyll
~ $ jekyll new myblog
~ $ cd myblog
~/myblog $ jekyll serve
# => Now browse to http://localhost:4000
{% endhighlight %}

That's nothing, though. The real magic happens when you start creating blog
posts, using the front-matter to control templates and layouts, and taking
advantage of all the awesome configuration options Jekyll makes available.

<div class="note info">
  <h5>Redcarpet is the default Markdown engine for new sites</h5>
  <p>In Jekyll 1.1, we switched the default markdown engine for sites
     generated with <code>jekyll new</code> to Redcarpet</p>
</div>

If you're running into problems, ensure you have all the [requirements
installed][Installation].

[Installation]: /docs/installation/
