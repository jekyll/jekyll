---
layout: news_item
title: "Jekyll's Mid-Life Crisis (Or, Jekyll turns 2.5.0)"
date: 2014-11-05 10:48:22 -0800
author: parkr
version: 2.5.0
categories: [release]
---

A new day, a new release! Jekyll just turned 2.5.0 and has gained a lot of
wisdom along the way. This 2.5.0 release also comes just a few weeks after
Jekyll turned 6 years old! In fashion, we're celebrating this huge
milestone with a pretty big release. What's changed in 2.5.0? Here are some
highlights:

* Require plugins in the `:jekyll_plugins` Gemfile group (turned off with an environment variable)
* YAML Front Matter permalinks can now contain placeholders like `:name`. Check out all the placeholders on the [Permalinks docs page](/docs/permalinks/).
* The `jsonify` filter now deep-converts arrays to liquid.
* Shorted `build` and `serve` commands with `b` and `s` aliases, respectively
* WEBrick will now list your directory if it can't find an index file.
* Any enumerable can be used with the `where` filter.
* Performance optimizations thanks to @tmm1's [stackprof](https://github.com/tmm1/stackprof)
* Fix for Rouge's Redcarpet interface
* Security auditors will love this: path sanitation has now been centralized.
* Specify a log level with `JEKYLL_LOG_LEVEL`: debug, info, warn, or error.

...and a whole bunch of other fixes and enhancements you can read more
about in [the changelog!](/docs/history/)

As always, if you run into issues, please [check the issues]({{ site.repository }}/issues)
and [create an issue if one doesn't exist for the bug you encountered]({{ site.repository }}/issues/new).
If you just need some help, the extraordinary [jekyll help team is here for
you!]({{ site.help_url }})

*When was the [first commit to Jekyll](https://github.com/jekyll/jekyll/commit/d189e05d236769c1e5594af9db4d6eacb86fc16e)?
All the way back on October 19, 2008. It features interesting historical
tidbits, such as the old name for Jekyll was "autoblog", and was first
released via Rubyforge. What a difference 6 years has made!*

Thanks to the following contributors for making this release possible:

Parker Moore, XhmikosR, Alfred Xing, Ruslan Korolev, Pat Hawks,
chrisfinazzo, Mike Kruk, Tanguy Krotoff, Matt Hickford, Philipp Rudloff,
Rob Murray, Sean Collins, Seth Warburton, Tom Thorogood, Vasily Vasinov,
Veres Lajos, feivel, mitaa, nitoyon, snrbrnjna, tmthrgd, Bret Comnes,
Charles Baynham, Christian Mayer, Dan Croak, Frederic Hemberger, Glauco
Custódio, Igor Kapkov, and Kevin Ndung'u!
