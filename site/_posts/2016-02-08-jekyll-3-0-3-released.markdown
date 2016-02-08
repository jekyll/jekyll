---
layout: news_item
title: 'Jekyll 3.0.3 Released'
date: 2016-02-08 10:39:08 -0800
author: parkr
version: 3.0.3
categories: [release]
---

[GitHub Pages upgraded to Jekyll 3.0.2][1] last week and there has been a
joyous reception so far! This release is to address some bugs that affected
some users during the cut-over. The fixes include:

* Fix problem where outputting to a folder would have two extensions
* Handle tildes (`~`) in filenames properly
* Fix issue when comparing documents without dates
* Include line numbers in liquid error output

Read more on the [changelog](/docs/history/#v3-0-3) with links to the
related patches.

Please keep [submitting bugs][2] as you find them! Please do take a look
[in our various help resources](/help/) before filing a bug and use [our
forum][3] for asking questions and getting help on a specific problem
you're having.

Happy Jekylling!

[1]: https://github.com/blog/2100-github-pages-now-faster-and-simpler-with-jekyll-3-0
[2]: {{ site.repository }}/issues
[3]: https://talk.jekyllrb.com/
