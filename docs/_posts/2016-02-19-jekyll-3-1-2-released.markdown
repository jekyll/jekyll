---
title: 'Jekyll 3.1.2 Released!'
date: 2016-02-19 15:24:00 -0800
author: parkr
version: 3.1.2
category: release
---

Happy Friday from sunny California! Today, we're excited to announce the release of Jekyll v3.1.2, which comes with some crucial bug fixes:

* If a syntax error is encountered by Liquid, it will now print the line number.
* A nasty war between symbols and strings in our configuration hash caused kramdown syntax highlighting to break. That has been resolved; you stand victorious!
* A tilde at the beginning of a filename will no longer crash Jekyll.
* The `titleize` filter mistakenly dropped words that were already capitalized. Fixed!
* Permalinks which end in a slash will now always output as a folder with an `index.html` inside.

Nitty-gritty details, like always, are available in the [history](/docs/history/).

Thanks to those who contributed to this release: Alfred Xing, atomicules, bojanland, Brenton Horne, Carlos Garcés, Cash Costello, Chris, chrisfinazzo, Daniel Schildt, Dean Attali, Florian Thomas, Jordon Bedwell, Juuso Mikkonen, Katya Demidova, lonnen, Manabu Sakai, Michael Lee, Michael Lyons, Mitesh Shah, Nicolas Hoizey, Parker Moore, Pat Hawks, Prayag Verma, Robert Martin, Suriyaa Kudo, and toshi.
