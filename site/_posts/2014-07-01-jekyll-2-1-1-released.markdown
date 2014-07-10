---
layout: news_item
title: 'Jekyll 2.1.1 Released'
date: 2014-07-01 20:16:43 -0400
author: parkr
version: 2.1.1
categories: [release]
---

This is a minor release for Jekyll 2.1.0. It fixes a couple bugs and
introduces fixes for a couple security-related issues.

It covers two security vulnerabilities:

1. One in the reading of data
2. One in the `layouts` setting

They were identified in Jekyll 1.5.1 and has been confirmed as patched
in this version and the version used by GitHub Pages. If you are in the
business of building Jekyll sites, please ensure you upgrade to 2.1.1 as
soon as possible.

For more, check out [`jekyll/jekyll#2563`](https://github.com/jekyll/jekyll/pull/2563).

Additionally, the dependency on Maruku has been loosened and a bug was
fixed with document URLs.

As always, check out the [full changelog](/docs/history/) for more info!

Happy Jekylling!
