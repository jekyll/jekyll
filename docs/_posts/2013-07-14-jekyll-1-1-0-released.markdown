---
title: "Jekyll 1.1.0 Released"
date: "2013-07-14 19:38:02 +0200"
author: parkr
version: 1.1.0
category: release
---

After a month of hard work, the Jekyll core team is excited to announce the release of
Jekyll v1.1.0! This latest release of Jekyll brings some really exciting new additions:

- Add `docs` subcommand to read Jekyll's docs when offline. ([#1046][])
- Support passing parameters to templates in `include` tag ([#1204][])
- Add support for Liquid tags to post excerpts ([#1302][])
- Fix pagination for subdirectories ([#1198][])
- Provide better error reporting when generating sites ([#1253][])
- Latest posts first in non-LSI `related_posts` ([#1271][])

See the [GitHub Release][] page for more a more detailed changelog for this release.

{% assign issue_numbers = "1046|1204|1302|1198|1171|1118|1098|1215|1253|1271" | split: "|" %}
{% for issue in issue_numbers %}
[#{{ issue }}]: {{ site.repository }}/issues/{{ issue }}
{% endfor %}

[GitHub Release]: {{ site.repository }}/releases/tag/v1.1.0
