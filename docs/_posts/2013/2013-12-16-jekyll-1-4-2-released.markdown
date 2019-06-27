---
title: 'Jekyll 1.4.2 Released'
date: 2013-12-16 19:48:13 -0500
author: parkr
version: 1.4.2
category: release
---

This release fixes [a regression][] where Maruku fenced code blocks were turned
off, instead of the previous default to on. We've added a new default
configuration to our `maruku` config key: `fenced_code_blocks` and set it to
default to `true`.

If you do not wish to use Maruku fenced code blocks, you may turn this option
off in your site's configuration file.

[a regression]: https://github.com/jekyll/jekyll/pull/1830
