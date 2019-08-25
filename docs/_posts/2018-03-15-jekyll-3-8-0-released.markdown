---
title: 'Jekyll 3.8.0 Released'
date: 2018-04-19 19:45:15 +0530
author: ashmaroli
version: 3.8.0
category: release
---

Aloha Jekyllers!! :wave:

After months of toiling on the codebase and shipping a couple of release-candidates, the Jekyll Team is delighted to finally
present `v3.8.0`, packed with optimizations, improvements, some new features and a couple of bug-fixes. Yay!!!

Under the hood, Jekyll has undergone many minor changes that will allow it to run more performantly in the coming years. :smiley:
Rest assured, our users should see minor improvements in their site's build times.

Speaking of improvements, users running a site containing a huge amount of posts or those who like to use our `where` filter
frequently in a single template, are going to see a massive reduction in their total build times!! :tada:

Hold on, this version is not just about optimizations, there are some new features as well..:
  * Detect non-existent variables and filters specified in a template by enabling `strict_variables` and `strict_filters` under the
  `liquid` key in your config file.
  * Allow *date filters* to output ordinal days.
  * `jekyll doctor` now warns you if you have opted for custom `collections_dir` but placed `_posts` directory outside that
  directory.

..and yes, a couple of bug-fixes, notably:
  * Jekyll now handles future-dated documents properly.
  * Jekyll is able to handle Liquid blocks intelligently in excerpts.
  * A few methods that were *not meant to be publically accessible* have been entombed properly.
  * A few bugs that still plagued our `collections_dir` feature from `v3.7` got crushed.

As always, the full list of changes since last release can be viewed [here](/docs/history/#v3-8-0).

A big thanks to the following people who contributed to our repository with pull-requests that improved our codebase, documentation
and tests:

Ana María Martínez Gómez, Antonio Argote, Ashwin Maroli, Awjin Ahn, Ben Balter, Benjamin Høegh, Christian Oliff, Damien Solodow,
David Zhang, Delson Lima, Eric Cornelissen, Florian Thomas, Frank Taillandier, Heinrich Hartmann, Jakob Vad Nielsen, John Eismeier,
Kacper Duras, KajMagnus, Mario Cekic, Max Vilimpoc, Michael H, Mike Kasberg, Parker Moore, Pat Hawks, Paweł Kuna, Robert Riemann,
Roger Rohrbach, Semen Zhydenko, Stefan Dellmuth, Tim Carry, olivia, and steelman.

Happy Jekylling!! :sparkles:
