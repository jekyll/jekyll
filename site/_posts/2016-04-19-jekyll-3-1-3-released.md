---
layout: news_item
title: 'Jekyll 3.1.3 Released'
date: 2016-04-19 10:26:16 -0700
author: parkr
version: 3.1.3
categories: [release]
---

v3.1.3 is a patch release which fixes the follow two issues:

- Front matter defaults may not have worked for collection documents and posts due to a problem where they were looked up by their URL rather than their path relative to the site source
- Running `jekyll serve` with SSL enabled was broken due to a bad configuration.

Both of these issues have been resolved. For more information, check out [the full history](/docs/history/#v3-1-3).

Happy Jekylling!

