---
title: 'Jekyll 3.8.3 Released'
date: 2018-06-05 09:00:00 -0500
author: pathawks
version: 3.8.3
category: release
---

This release fixes a regression in 3.8 where collections with `published: false`
do not show when using the `--unpublished` flag.

Thanks to @philipbelesky for reporting and fixing this issue; collections with
`published: false` now behave the same way as Posts.
