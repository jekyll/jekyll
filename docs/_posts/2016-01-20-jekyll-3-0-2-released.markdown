---
title: 'Jekyll 3.0.2 Released'
date: 2016-01-20 14:08:18 -0800
author: parkr
version: 3.0.2
categories: [release]
---

A crucial bug was found in v3.0.1 which caused invalid post dates to go
unnoticed in the build chain until the error that popped up was unhelpful.
v3.0.2 [throws errors as you'd expect](https://github.com/jekyll/jekyll/issues/4375)
when there is a post like `_posts/2016-22-01-future.md` or a post has an
invalid date like `date: "tuesday"` in their front matter.

This should make the experience of working with Jekyll just a little
better.

Happy Jekylling!
