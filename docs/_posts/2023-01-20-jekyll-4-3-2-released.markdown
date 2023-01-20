---
title: 'Jekyll 4.3.2 Released'
date: 2023-01-20 23:00:00 +0530
author: ashmaroli
version: 4.3.2
category: release
---

Hello Jekyllers!

This is a small release containing fixes for some issues that came to our attention after the
release of v4.3.1:
  - Our `link` tag had a significant performance regression with the release of v4.3.0 solely due
    to a change related to `Jekyll::Site#each_site_file`. The new patch restores previous performance
    while maintaining the enhancements introduced in v4.3.0.
  - The tables printed out on running a build with the `--profile` did not stop including the
    misleading `TOTALS` row as advertised in the release-notes for v4.3.0. The row has been removed
    completely now.
  - `jekyll-sass-converter-3.0.0` that shipped in the interim was not happy with our blank-site
    scaffolding (from running `jekyll new <path> --blank`) having a `main.scss` stylesheet template
    *import* a Sass partial *also named* `main.scss`. So the partial has been renamed to `base.scss`.

That's about it for this release. Depending on whether you use the features patched in this release,
you may either wait for v4.4.0 (releasing in the near future) to update your Gemfile or, download
the latest release right away! :)

Happy Jekyllin'!!
