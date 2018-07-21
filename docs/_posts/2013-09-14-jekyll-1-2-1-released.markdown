---
title: 'Jekyll 1.2.1 Released'
date: 2013-09-14 20:46:50 -0400
author: parkr
version: 1.2.1
categories: [release]
---

Quick turnover, anyone? A [recent incompatibility with Liquid
v2.5.2](https://github.com/jekyll/jekyll/pull/1525) produced a nasty bug in
which `include` tags were not rendered properly within `if` blocks.

This release also includes a better handling of detached servers (prints pid and
the command for killing the process). **Note**: the `--detach` flag and
`--watch` flags are presently incompatible in 1.2.x. Fix for that coming soon!

For a full list of the fixes in this release, check out [the change
log](/docs/history/)!
