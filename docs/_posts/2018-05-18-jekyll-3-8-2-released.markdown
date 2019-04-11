---
title: 'Jekyll 3.8.2 Released'
date: 2018-05-19 10:30:00 -0500
author: pathawks
version: 3.8.2
category: release
---

Hello Jekyllers!!

Today we are releasing `v3.8.2`, which fixes the way Jekyll generates excerpts
for posts when the first paragraph of the post contains Liquid tags that take
advantage of [Liquid's whitespace control feature][Liquid whitespace].

Big thanks to @kylebarbour, who first reported this issue and also very quickly
submitted a fix. Also thanks to @nickskalkin for making sure that we are using
the latest version of Rubocop to lint our code.

[Liquid whitespace]: https://shopify.github.io/liquid/basics/whitespace/
