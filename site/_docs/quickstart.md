---
layout: docs
title: Quick-start guide
permalink: /docs/quickstart/
---

For the impatient, here's how to get a boilerplate Jekyll site up and running.

{% highlight bash %}
~/myblog $ gem install bundler
# => Now create a Gemfile (bundle init)
~/myblog $ bundle install
~/$ bundle exec jekyll new myblog
~/myblog $ bundle exec jekyll serve
# => Now browse to http://localhost:4000
{% endhighlight %}

If you wish to install jekyll into the current directory, you can do so by
alternatively running `bundle exec jekyll new .` instead of a new directory name.

That's nothing, though. The real magic happens when you start creating blog
posts, using the front matter to control templates and layouts, and taking
advantage of all the awesome configuration options Jekyll makes available.

If you're running into problems, ensure you have all the [requirements
installed][Installation].

[Installation]: /docs/installation/
