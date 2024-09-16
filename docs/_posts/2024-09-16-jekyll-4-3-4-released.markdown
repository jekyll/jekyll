---
title: 'Jekyll 4.3.4 Released'
date: 2024-09-16 21:34:22 +0530
author: ashmaroli
version: 4.3.4
category: release
---

Hello Jekyllers!

Publishing a small bug-fix release with the following patches:

* Relax version-constraint on gem `wdm` in Gemfile created by `jekyll new`.
* Patch `Jekyll::Drops::ThemeDrop#root` to render absolute path to theme-gem only if `JEKYLL_ENV` is explicitly set
  to string `development`.

That is all for now.
Happy Jekyllin'!!
