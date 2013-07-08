---
layout: news_item
title: "Jekyll 1.0.3 Released"
date: "2013-06-07 21:02:13 +0200"
author: parkr
version: 1.0.3
categories: [releases, general]
---

_(Take a look at the [History][] page in the docs for more detailed information.)_

v1.0.3 contains some key enhancements and bug fixes:

- Fail with non-zero exit code when MaRuKu errors ([#1190][]) or Liquid errors ([#1121][])
- Add support for private gists to `gist` tag ([#1189][])
- Add `--force` option to `jekyll new` ([#1115][])
- Fix compatibility with `exclude` and `include` with pre-1.0 Jekyll ([#1114][])
- Fix pagination issue regarding `File.basename` and `page:num` ([#1063][])

{% assign issue_numbers = "1190|1121|1189|1115|1114|1063" | split: "|" %}
{% for issue in issue_numbers %}
[#{{ issue }}]: https://github.com/mojombo/jekyll/issues/{{ issue }}
{% endfor %}

[History]: /docs/history/#103__20130607
