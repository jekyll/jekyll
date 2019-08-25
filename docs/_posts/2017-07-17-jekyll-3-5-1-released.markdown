---
title: 'Jekyll 3.5.1 Released'
date: 2017-07-17 12:40:37 -0400
author: parkr
version: 3.5.1
category: release
---

We've released a few bugfixes in the form of v3.5.1 today:

- Some plugins stopped functioning properly due to a NoMethodError for `registers` on NilClass. That's been fixed.
- A bug in `relative_url` when `baseurl` is `nil` caused URL's to come out wrong. Squashed.
- Static files' liquid representations should now have all the keys you were expecting when serialized into JSON.

We apologize for the breakages! We're working diligently to improve how we test our plugins with Jekyll core to prevent breakages in the future.

More details in [the history](/docs/history/#v3-5-1). Many thanks to all the contributors to Jekyll v3.5.1: Adam Voss, ashmaroli, Ben Balter, Coby Chapple, Doug Beney, Fadhil, Florian Thomas, Frank Taillandier, James, jaybe, Joshua Byrd, Kevin Plattret, & Robert Jäschke.

Happy Jekylling!
