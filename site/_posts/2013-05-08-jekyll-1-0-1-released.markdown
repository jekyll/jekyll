---
layout: news_item
title: "Jekyll 1.0.1 Released"
date: "2013-05-08 23:46:11 +0200"
author: parkr
version: 1.0.1
categories: [release]
---

Hot on the trails of v1.0, v1.0.1 is out! Here are the highlights:

* Add newer `language-` class name prefix to code blocks ([#1037][])
* Commander error message now preferred over process abort with incorrect args ([#1040][])
* Do not force use of toc_token when using generate_toc in RDiscount ([#1048][])
* Make Redcarpet respect the pygments configuration option ([#1053][])
* Fix the index build with LSI ([#1045][])
* Don't print deprecation warning when no arguments are specified. ([#1041][])
* Add missing `</div>` to site template used by `new` subcommand, fixed typos in code ([#1032][])

See the [History][] page for more information on this release.

{% assign issue_numbers = "1037|1040|1048|1053|1045|1041|1032" | split: "|" %}
{% for issue in issue_numbers %}
[#{{ issue }}]: {{ site.repository }}/issues/{{ issue }}
{% endfor %}

[History]: /docs/history/#101__20130508
