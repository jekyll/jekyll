---
layout: news_item
title: 'Jekyll 3.1.0 Released'
date: 2016-01-24 13:16:12 -0800
author: parkr
version: 3.1.0
categories: [release]
---

Happy weekend! To make your weekend all the better, we have just released
v3.1.0 of Jekyll.

There are _lots_ of great performance improvements, including a huge one
which is to use Liquid drops instead of hashes. Much of the slowness in
Jekyll is due to Jekyll making lots of objects it doesn't need to make.
By making these objects only as they're needed, we can speed up Jekyll
considerably!

Some other highlights:

* Fix: `permalink`s with non-HTML extensions will not be honored
* Fix: `jekyll clean` now accepts build flags like `--source`.
* Enhancement: `include` tags can now accept multiple liquid variables
* Feature: adds new `sample` liquid tag which gets random element from an array
* Fix: Jekyll will read in files with YAML front matter that has extraneous
spaces after the first line
* Enhancement: extract the `title` attribute from the filename for
collection items without a date
* Fix: gracefully handle empty configuration files

... and [a whole bunch more](/docs/history/#v3-1-0)!

Please [file a bug]({{ site.repository }}/issues/new?title=Jekyll+3.1.0+Issue:)
if you encounter any issues! As always, [Jekyll Talk](https://talk.jekyllrb.com)
is the best place to get help if you're encountering a problem.

Special thanks to all our amazing contributors who helped make v3.1.0 a
possibility:

Alex J Best, Alexander Köplinger, Alfred Xing, Alistair Calder, Atul
Bhosale, Ben Orenstein, Chi Trung Nguyen, Conor O'Callaghan, Craig P.
Motlin, Dan K, David Burela, David Litvak Bruno, Decider UI, Ducksan Cho,
Florian Thomas, James Wen, Jordon Bedwell, Joseph Wynn, Kakoma, Liam
Bowers, Mike Neumegen, Nick Quaranto, Nielsen Ramon, Olivér Falvai, Pat
Hawks, Paul Robert Lloyd, Pedro Euko, Peter Suschlik, Sam Volin, Samuel
Wright, Sasha Friedenberg, Tim Cuthbertson, Vincent Wochnik, William
Entriken, Zshawn Syed, chrisfinazzo, ducksan cho, leethomas,
midnightSuyama, musoke, and rebornix

Happy Jekylling!
