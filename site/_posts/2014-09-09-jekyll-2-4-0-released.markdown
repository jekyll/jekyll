---
layout: news_item
title: 'A Wild Jekyll 2.4.0 Appeared!'
date: 2014-09-09 21:10:33 -0700
author: parkr
version: 2.4.0
categories: [release]
---

Well, lookie here! A new release of Jekyll! v2.4.0 contains lots of goodies, including some brilliant new additions:

- A new `relative_include` Liquid tag ([#2870]({{ site.repository }}/issues/2870))
- Render Liquid in CoffeeScript files ([#2830]({{ site.repository }}/issues/2830))
- Add 4 new array Liquid filters: `push`, `pop`, `shift`, and `unshift` ([#2895]({{ site.repository }}/pull/2895))
- Auto-enable watch on 'serve' ([#2858]({{ site.repository }}/issues/2858)). No more `-w`!
- Add `:title` and `:name` to collection URL template fillers ([#2864]({{ site.repository }}/issues/2864) & [#2799]({{ site.repository }}/issues/2799))
- Add support for CSV files in the `_data` directory ([#2761]({{ site.repository }}/issues/2761))
- Add `inspect` liquid filter ([#2867]({{ site.repository }}/issues/2867))
- Add a `slugify` Liquid filter ([#2880]({{ site.repository }}/issues/2880))

Some other wunderbar bug fixes in there as well. Check out the [full changelog](/docs/history/) for the whole scoop.

As always, many thanks to our amazing contributors who made this release possible: Chris Frederick, Garen Torikian, James Smith, Ruslan Korolev, Joel Glovier, Michael Kühnel, Minn Soe, Pat Hawks, Peter deHaan, Shu Uesugi, TJ, Zhuochun, Alfred Xing, nitoyon, Anatol Broder, Faruk AYDIN, Frederic Hemberger, and Gordon Gao. Thank you!!

Happy Jekylling!
