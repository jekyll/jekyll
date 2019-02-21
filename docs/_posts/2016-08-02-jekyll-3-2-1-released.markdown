---
title: 'Jekyll 3.2.1 Released with Fix for Windows'
date: 2016-08-02 13:20:11 -0700
author: parkr
version: 3.2.1
category: release
---

Well, 3.2.0 has been a success, but with one fatal flaw: it doesn't work on
Windows! Sorry, Windows users. Hot on the trail of 3.2.0, this release
should squash that :bug:. Sorry about that!

This release also fixes an issue when using [gem-based themes](/docs/themes/)
where the theme was rejected if it existed behind a symlink. This is a
common setup for the various ruby version managers, and for Ruby installed
via Homebrew. Props to @benbalter for fixing that up.

Thanks to the contributors for this release: Adam Petrie, Ben Balter,
Daniel Chapman, DirtyF, Gary Ewan Park, Jordon Bedwell, and Parker Moore.

As always, you can see our full changelog on [the History page](/docs/history/).

Happy Jekylling!
