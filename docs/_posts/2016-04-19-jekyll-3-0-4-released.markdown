---
title: 'Jekyll 3.0.4 Released'
date: 2016-04-19 10:26:12 -0700
author: parkr
version: 3.0.4
categories: [release]
---

v3.0.4 is a patch release which fixes the follow two issues:

- Front matter defaults may not have worked for collection documents and posts due to a problem where they were looked up by their URL rather than their path relative to the site source
- Configuration for the posts permalink might be borked when a user specified a value for `collections.posts.permalink` directly. This forced the use of `permalink` at the top level, which also affected pages. To configure a permalink _just for posts_, you can do so with:

{% highlight yaml %}
collections:
  posts:
    output: true
    permalink: /blog/:year/:title/
{% endhighlight %}

Both of these issues have been resolved. For more information, check out [the full history](/docs/history/#v3-0-4).

Happy Jekylling!
