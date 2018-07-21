---
title: 'Jekyll turns 3.5, oh my!'
date: 2017-06-15 17:32:32 -0400
author: parkr
version: 3.5.0
categories: [release]
---

Good news! Nearly 400 commits later, Jekyll 3.5.0 has been released into
the wild. Some new shiny things you might want to test out:

- Jekyll now uses Liquid 4, the latest! It comes with whitespace control, new filters `concat` and `compact`, loop performance improvements and [many fixes](https://github.com/Shopify/liquid/blob/master/History.md#400--2016-12-14--branch-4-0-stable)
- Themes can specify runtime dependencies (in their gemspecs) and we'll require those. This makes it easier for theme writers to use plugins.
- Speaking of themes, we'll properly handle the discrepancy between a convertible file in the local site and a static file in the theme. Overriding a file locally now doesn't matter if it's convertible or static.
- Pages, posts, and other documents can now access layout variables via `{% raw %}{{ layout }}{% endraw %}`.
- The `gems` key in the `_config.yml` is now `plugins`. This is backwards-compatible, as Jekyll will gracefully upgrade `gems` to `plugins` if you use the former.
- Filters like `sort` now allow you to sort based on a subvalue, e.g. `{% raw %}{% assign sorted = site.posts | sort: "image.alt_text" %}{% endraw %}`.
- You can now create tab-separated data files.
- Using `layout: none` will now produce a file with no layout. Equivalent to `layout: null`, with the exception that `none` is a truthy value and won't be overwritten by front matter defaults.
- No more pesky errors if your URL contains a colon (sorry about those!)
- We now automatically exclude the `Gemfile` from the site manifest when compiling your site. No more `_site/Gemfile`!
- We fixed a bug where abbreviated post dates were ignored, e.g. `_posts/2016-4-4-april-fourth.md`.

And [so much more!](/docs/history/)

There was a huge amount of effort put into this release by our maintainers,
especially @pathawks, @DirtyF, and @pup. Huge thanks to them for ushering
this release along and keeping the contributions flowing! Jekyll wouldn't
work without the tireless dedication of our team captains & maintainers.
Thank you, all!

A huge thanks as well to our contributors to this release: Adam Hollett, Aleksander Kuś, Alfred Myers, Anatoliy Yastreb, Antonio Argote, Ashton Hellwig, Ashwin Maroli, Ben Balter, BlueberryFoxtrot, Brent Yi, Chris Finazzo, Christoph Päper, Christopher League, Chun Fei Lung, Colin, David Zhang, Eric Leong, Finn Ellis, Florian Thomas, Frank Taillandier, Hendrik Schneider, Henry Kobin, Ivan Storck, Jakub Klímek, Jan Pobořil, Jeff Puckett, Jonathan Hooper, Kaligule, Kevin Funk, Krzysztof Szafranek, Liu Cheng, Lukasz Brodowski, Marc Bruins, Marcelo Canina, Martin Desrumaux, Mer, Nate, Oreonax, Parker Moore, Pat Hawks, Pedro Lamas, Phil Nash, Ricardo N Feliciano, Ricky Han, Roger Sheen, Ryan Lue, Ryan Streur, Shane Neuville, Sven Meyer, Tom Johnson, William Entriken, Yury V. Zaytsev, Zarino Zappia, dyang, jekylltools, sean delaney, zenHeart

Please file any bugs with detailed replication instructions if you find any
bugs. Better yet, submit a patch if you find the bug in the code and know
how to fix it! :heart:

Happy Jekylling! :tada:
