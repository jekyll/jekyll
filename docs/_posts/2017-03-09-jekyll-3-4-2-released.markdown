---
title: 'Jekyll 3.4.2 Released'
date: 2017-03-09 15:41:57 -0500
author: parkr
version: 3.4.2
categories: [release]
---

Another one-PR patch update, though without the same [lessons as for the
previous release]({% link _posts/2017-03-02-jekyll-3-4-1-released.markdown %}).

This release includes a beneficial change for a number of plugins:
**static files now respect front matter defaults**.

You might be asking yourself: "why would static files, files that are
static files explicitly because they *don't* have front matter, want
to respect front matter?" That's a great question. Let me illustrate
with an example.

Let's look at `jekyll-sitemap`. This plugin generates a list of documents,
pages, and static files, and some metadata for them in an XML file for a
Google/Yahoo/Bing/DuckDuckGo crawler to consume. If you don't want a given
file in this list, you set `sitemap: false` in front matter. But
what about static files, which don't have front matter? Before this
release, they could not be excluded because they had no properties in YAML
other than [the ones we explicitly assigned](https://github.com/jekyll/jekyll/blob/v3.4.1/lib/jekyll/static_file.rb#L98-L106).
So if you had a PDF you didn't want to be in your sitemap, you couldn't use
`jekyll-sitemap`.

With this release, you can now set [front matter
defaults](/docs/configuration/front-matter-defaults/) for static files:

```yaml
defaults:
  -
    scope:
      path: "pdfs/"
    values:
      sitemap: false
```

Now, for every file in the Liquid `site.static_files` loop which is in the
folder `pdfs/`, you'll see `sitemap` equal to `false`.

Many thanks to @benbalter for coming up with the solution and ensuring
sitemaps everywhere are filled with just the right content.

As always, if you notice any bugs, please search the issues and file one if
you can't find another related to your issue.

Happy Jekylling!
