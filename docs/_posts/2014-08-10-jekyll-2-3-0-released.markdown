---
title: 'Jekyll 2.3.0 Released'
date: 2014-08-10 20:38:34 -0400
author: parkr
version: 2.3.0
categories: [release]
---

This latest release of Jekyll includes a slew of enhancements and bug
fixes. Some of the highlights:

* Strange bug around spacing/indentation should be resolved. [It was a
  curious bug indeed.](https://github.com/jekyll/jekyll/issues/2676)
* Pages, Posts, and Drafts can now be converted by multiple converters.
* Static files can now be safely included in collections. They'll be placed
  in a `collection.files` array. `collection.docs` still holds exclusively
  content with YAML front matter.
* Sass files can once again be rendered by Liquid. However, neither Sass
  nor CoffeeScript can ever have a layout. Bonus: `scssify` and `sassify`
  Liquid filters.
* Partial variables allowed now in the path argument of `include` calls
* We added a `jekyll help` command. Pass it a subcommand to see more info
  about that subcommand. Or don't, to see the help for `jekyll` itself.
* Lots of fixes to the site template we use for `jekyll new`, including
  converting the CSS into SCSS.
* The `jsonify` filter will now call `#to_liquid` for you
* Lots, lots more!

One change deserves special note. In [#2633][], subfolders *inside* a
`_posts` folder were processed and added as categories to the posts. It
turns out, this behaviour was unwanted by a large number of individuals, as
it is a handy way to organize posts. Ultimately, we decided to revert this
change in [#2705][], because it was a change in behaviour that was already
well-established (at least since Jekyll v0.7.0), and was convenient.

[#2633]: {{ site.repository }}/issues/2633
[#2705]: {{ site.repository }}/issues/2705

For more excellent CHANGELOG reading material, check out the [History
page](/docs/history/)! Happy Jekylling!
