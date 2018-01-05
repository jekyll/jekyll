---
title: "Jekyll 3.7.0 Released"
description: "Jekyll 3.7.0 brings LiveReload, a directory for your collections and much more…"
date: 2018-01-02 11:21:40 +0100
author: DirtyF
version: 3.7.0
categories: [release]
---

We're happy to release a new minor for the new year.
Here are a few of the latest additions from our contributors:

 * LiveReload is available as an option during development: with `jekyll serve --livereload` no more manual page refresh. A big thanks to @awood for this feature and to @andreyvit, LiveReload author.
 * New `collections_dir` configuration option allows you to store all your [collections](/docs/collections) in a single folder. Your source root folder should now look cleaner :sparkles: .
 * If you're using a [gem-based theme](/docs/themes/) in coordination with the `--incremental` option, you should notice some significant speed during the regeneration process, we did see build time went down **from 12s to 2s** with @mmistakes [minimal-mistakes theme](https://github.com/mmistakes/minimal-mistakes) during our tests.
 * Jekyll will now check to determine whether host machine has internet connection.
 * A new `latin` option is available to better [handle URLs slugs](/docs/templates/#options-for-the-slugify-filter).
 * And of course many bug fixes and updates to our documentation — which you can now search thanks to our friends @Algolia.
 * [Full history is here](/docs/history/#v3-7-0).

This release wouldn't have been possible without all the following people:

Aaron Borden, Alex Tsui, Alex Wood, Alexey Pelykh, Andrew Dassonville, Angelika Tyborska, Ankit Singhaniya, Ashwin Maroli, bellvat, Brandon Dusseau, Chris Finazzo, Doug Beney, Dr. Wolfram Schroers, Edward Shen, Florian Thomas, Frank Taillandier, Gert-jan Theunissen, Goulven Champenois, János Rusiczki, Jed Fox, Johannes Müller, Jon Anning, Jonathan Hooper, Jordon Bedwell, Junko Suzuki, Kacper Duras, Kenton Hansen, Kewin Dousse, Matt Rogers, Maximiliano Kotvinsky, mrHoliday, Olivia, Parker Moore, Pat Hawks, Sebastian Kulig, Vishesh Ruparelia, Xiaoiver and Yashu Mittal.

A big thanks to everyone!

Oh, one last thing…

### :pray: upgrade your Ruby

Prepare for the next major update, as next major version Jekyll 4.0 will drop support for Ruby 2.1 and 2.2.

> Ruby 2.2 is now under the state of the security maintenance phase, until the end of the March of 2018. After the date, maintenance of Ruby 2.2 will be ended. We recommend you start planning migration to newer versions of Ruby, such as 2.4 or 2.3. — [Ruby Core Team](https://www.ruby-lang.org/en/news/2017/12/14/ruby-2-2-9-released/)

We strongly encourage you to upgrade to at least Ruby 2.4.x [like our friends at GitHub Pages](https://pages.github.com/versions/) or even go with [Ruby 2.5](https://www.ruby-lang.org/en/news/2017/12/25/ruby-2-5-0-released/).

Happy new year to all from the Jekyll team!
