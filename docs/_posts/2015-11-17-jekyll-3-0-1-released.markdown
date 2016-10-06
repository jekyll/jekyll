---
layout: news_item
title: 'Jekyll 3.0.1 Released'
date: 2015-11-17 22:04:39 -0800
author: parkr
version: 3.0.1
categories: [release]
---

Hey, folks! Bunch of bug fixes here. Notables:

* Only superdirectories of `_posts` will be categories.
* `:title` in permalink templates are now properly cased as before
* `.jekyll-metadata` being erroneously written when not using incremental build.
* Failure in liquid will now always fail the `jekyll` process.
* All hooks should now be properly registered & documented

And a bunch more changes which you can see over in the
[changelog](/docs/history).

Thanks to the 17 developers who contributed code and documentation to this
patch release: Alfred Xing, Christian Trosell, Jordan Thornquest, Jordon
Bedwell, Larry Fox, Lawrence Murray, Lewis Cowles, Matt Rogers, Nicole
White, Parker Moore, Paul Robert Lloyd, Sarah Kuehnle, Vincent Wochnik,
Will Norris, XhmikosR, chrisfinazzo, and rebornix.
