---
layout: docs
title: Working with drafts
prev_section: posts
next_section: pages
permalink: /docs/drafts/
---

Drafts are posts without a date. They're posts you're still working on and don't want to
publish yet. Your drafts are kept in the `_drafts` directory, which is located under
the project root (as described in the [site structure](/docs/structure/) section).

{% highlight text %}
|-- _drafts/
|   |-- a-draft-post.md
{% endhighlight %}

Jekyll provides several commands for working with drafts.

To create a new draft, run the `jekyll draft` command from the project root.

{% highlight bash %}
$ jekyll draft "Working with drafts"
{% endhighlight %}

To publish the draft we just created, we can use the `jekyll publish` command.

{% highlight bash %}
$ jekyll publish working-with-drafts.markdown
{% endhighlight %}

To preview your site with drafts, simply run `jekyll serve` or `jekyll build` with
the `--drafts` switch.  Each will be assigned the value modification time of the draft file
for its date, and thus you will see currently edited drafts as the latest posts.
