---
title: 'Jekyll 3.9.2 Released'
date: 2022-03-27 13:20:00 -0700
author: parkr
version: 3.9.2
categories: [release]
---

Hey Jekyllers,

Quick bug-fix release for you all today:

1. Ruby 3.0 and 3.1 support :tada: (you will need to run `bundle add webrick` for `jekyll serve` to work)
2. `jekyll serve` will no longer inject a charset into the MIME type for
binary types
3. Incremental regeneration now handles includes in collection files
   correctly

That's all, Happy Jekylling!
