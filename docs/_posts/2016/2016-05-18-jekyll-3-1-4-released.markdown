---
title: 'Jekyll 3.1.4 "Stability Sam" Released'
date: 2016-05-18 16:50:37 -0700
author: parkr
version: 3.1.4
category: release
---

Hey Jekyllites!

Today, we released v3.1.4 in an effort to bring more stability to the v3.1.x series. This bugfix release consists of:

* A fix for `layout` in Liquid where values would carry over from one document to the next
* A fix for `layout` in Liquid where a parent layout (e.g. `default` or `base`) would overwrite the metadata of the child layout (e.g. `post` or `special`).
* A fix where `page.excerpt` referencing its excerpt would cause an infinite loop of recursive horror.
* We added `Configuration.from` and the great permalink fix from [v3.0.4](/news/2016/04/19/jekyll-3-0-4-released/) to the v3.1.x series
* `site.collections` in Liquid is now sorted alphabetically by label, so `docs` shows up before `posts` reliably.

The fixes for `layout` may not be seamless for everyone, but we believe they will be the "right thing to do" going forward.

We are alwawys striving to make Jekyll more straight-forward to use. Please do open an issue if you believe an aspect of Jekyll's user experience isn't up to par.

For a full history of our changes, [see the changelog](/docs/history/#v3-1-4).

As always, Happy Jekylling!
