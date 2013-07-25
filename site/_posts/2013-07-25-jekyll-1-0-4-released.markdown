---
layout: news_item
title: "Jekyll 1.0.4 Released"
date: "2013-07-25 09:08:38 +0200"
author: parkr
version: 1.0.4
categories: [release]
---

This version contains a [very important security patch][230] for `Liquid::Drop` plugins
which granted access to all non-`Drop` entities within a `Drop`, which may include your
Rack configuration settings and many more pieces of private information which could be
used to exploit your system. We recommend you upgrade to v1.0.4 as quickly as possible if
you use `Liquid::Drop` plugins in your site.

Many thanks for [Ben Balter](http://github.com/benbalter) for alerting us to the problem
and [submitting a patch][1349] so quickly.

[230]: https://github.com/Shopify/liquid/pull/230
[1349]: https://github.com/mojombo/jekyll/issues/1349
