---
layout: news_item
title: 'Jekyll 2.5.2 Released'
date: 2014-11-12 18:49:08 -0800
author: parkr
version: 2.5.2
categories: [release]
---

A very minor release, 2.5.2 fixes a bug with path sanitation that 2.5.1
introduced. It also improves the `post_url` tag such that it checks the
posts' name (e.g. `2014-03-03-my-cool-post`) instead of a compiled time and
name. This fixes issues where posts are created and the day changes based
on timezone discrepancies.

[Full history here.](/docs/history/)

Happy Jekylling!
