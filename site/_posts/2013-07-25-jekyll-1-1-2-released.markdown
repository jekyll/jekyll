---
layout: news_item
title: "Jekyll 1.1.2 Released"
date: "2013-07-25 09:08:38 +0200"
author: parkr
version: 1.1.2
categories: [release]
---

Version 1.1.2 fixes a minor, but nonetheless important security vulnerability affecting several third-party Jekyll plugins. If your Jekyll site does not use plugins, you may, but are not required to upgrade at this time.

Community and custom plugins extending the `Liquid::Drop` class may inadvertently disclose some system information such as directory structure or software configuration to users with access to the Liquid templating system.

We recommend you upgrade to Jekyll v1.1.2 immediately if you use `Liquid::Drop` plugins on your Jekyll site.

Many thanks for [Ben Balter](https://github.com/benbalter) for alerting us to the problem
and [submitting a patch][1349] so quickly.

[230]: https://github.com/Shopify/liquid/pull/230
[1349]: {{ site.repository }}/issues/1349
