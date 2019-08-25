---
title: 'Jekyll 3.5.2 Released'
date: 2017-08-12 16:31:40 -0400
author: parkr
version: 3.5.2
category: release
---

3.5.2 is out with 6 great bug fixes, most notably one which should dramatically speed up generation of your site! In testing #6266, jekyllrb.com generation when from 18 seconds down to 8! Here is the full line-up of fixes:

  * Backport #6266 for v3.5.x: Memoize the return value of `Document#url` (#6301)
  * Backport #6247 for v3.5.x: kramdown: symbolize keys in-place (#6303)
  * Backport #6281 for v3.5.x: Fix `Drop#key?` so it can handle a nil argument (#6288)
  * Backport #6280 for v3.5.x: Guard against type error in `absolute_url` (#6287)
  * Backport #6273 for v3.5.x: delegate `StaticFile#to_json` to `StaticFile#to_liquid` (#6302)
  * Backport #6226 for v3.5.x: `Reader#read_directories`: guard against an entry not being a directory (#6304

A [full history](/docs/history/#v3-5-2) is available for your perusal. As always, please file bugs if you encounter them! Opening a pull request with a failing test for your expected behaviour is the easiest way for us to address the issue since we have a reproducible example to test again. Short of that, please fill out our issue template to the best of your ability and we'll try to get to it quickly!

Many thanks to our contributors without whom this release could not be
possible: Ben Balter & Kyle Zhao.

Happy Jekylling!
