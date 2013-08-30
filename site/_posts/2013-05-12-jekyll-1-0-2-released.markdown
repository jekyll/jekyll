---
layout: news_item
title: "Jekyll 1.0.2 Released"
date: "2013-05-12 14:45:00 +0200"
author: parkr
version: 1.0.2
categories: [release]
---

v1.0.2 has some key bugfixes that optionally restore some behaviour from pre-1.0
releases, and fix some other annoying bugs:

* Backwards-compatibilize relative permalinks ([#1081][])
* Add `jekyll doctor` command to check site for any known compatibility problems ([#1081][])
* Deprecate old config `server_port`, match to `port` if `port` isn't set ([#1084][])
* Update pygments.rb and kramdon versions to 0.5.0 and 1.0.2, respectively ([#1061][], [#1067][])
* Fix issue when post categories are numbers ([#1078][])
* Add a `data-lang="<lang>"` attribute to Redcarpet code blocks ([#1066][])
* Catching that Redcarpet gem isn't installed ([#1059][])

See the [History][] page for more information on this release.

{% assign issue_numbers = "1059|1061|1066|1067|1078|1081|1084" | split: "|" %}
{% for issue in issue_numbers %}
[#{{ issue }}]: {{ site.repository }}/issues/{{ issue }}
{% endfor %}

[History]: /docs/history/#102__20130512
