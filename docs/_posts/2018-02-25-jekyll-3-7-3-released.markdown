---
title: 'Jekyll 3.7.3 Released'
date: 2018-02-25 13:02:08 +0530
author: ashmaroli
version: 3.7.3
categories: [release]
---

Hello Jekyllers!! :wave:

We're pleased to announce the release of `v3.7.3` which fixes a bug one might encounter while using `Jekyll - 3.7.x` along with a
Jekyll plugin that in turn uses the `I18n` library.

When [v3.7.0]({% link _posts/2018-01-02-jekyll-3-7-0-released.md %}) enhanced our `slugify` filter with a `latin` option, we also
hardcoded a default fallback locale for the `I18n` library to avoid an exception raised in the event the library fails to find
any locale. This led to issues with third-party i18n plugins for Jekyll, especially since the default locale got assigned before
the plugin was loaded, irrespective of whether the `slugify` filter was used.

Jekyll will henceforth set the default locale if and only if necessary.
