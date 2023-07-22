---
title: 'Jekyll 4.3.1 Released'
date: 2022-10-26 19:09:42 +0530
author: ashmaroli
version: 4.3.1
category: release
---

Hello Jekyllers!

We're shipping `v4.3.1` containing fixes for two issues with v4.3.0:
  - Jekyll now respects user-defined `name` attribute for collection documents when accessed in Liquid templates.
  - Revert the changes made to trigger incremental rebuilds when data files are changed.

Thanks to the users who took the time to report the issues to us.
Happy Jekyllin'

P.S. Development towards v5 has taken a back seat as of now. I plan on releasing a v4.4.0 instead.
That said, please feel free to comment on the [tentative roadmap to v5][roadmap].

[roadmap]: {{ site.repository }}/issues/9156
