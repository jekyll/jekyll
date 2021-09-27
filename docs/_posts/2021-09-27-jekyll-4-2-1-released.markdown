---
title: "Jekyll 4.2.1 Released"
date: 2021-09-27 14:45:46 +0530
author: ashmaroli
version: 4.2.1
category: release
---

Hello Jekyllers!

The Jekyll team is happy to announce the release of `v4.2.1` which fixes a couple of
regressions introduced in `v4.2.0` and another bug inherited from Jekyll 3.

In `v4.2.0`, we decided to stop overriding {% raw %}`{{ site.url }}`{% endraw %} with
the *localhost* address when running the command `jekyll serve` with the default
*development* mode. While the intent behind the change was to avoid forcing users to
generate a *production build* separately by invoking `jekyll build`, it however had an
unforeseen consequence &mdash; absolute URLs for assets now pointed to
resources that were at times not yet been deployed to the configured `site.url`. That
broke the users' local development workflow.

`v4.2.0` also added a series of optimizations surrounding the generation of Liquid
representation for a site's standalone pages and layouts. However, that prevented
{% raw %}`{{ page.content }}`{% endraw %} and other mutable attributes from reflecting
the latest state of the requested attribute, thereby breaking the render of all resources
that were dependent on such mutable attributes.

The last fix included in this release addresses the issue where incremental regeneration
ignored changes to documents in collections when the site is configured to use a custom
`collections_dir` for all collections.

Special thanks to @benik for helping us understand the regression caused by the decision
to stop overriding `site.url` and proposing to revert the change. Another special thanks
to @pdmosses for helping us discover the regression surrounding Liquid representation of
pages by providing with a test repository.

<div style="padding:8px 0 2px;text-align:center;background:rgba(240,0,0,0.1)">
  :bouquet: <span style="margin:0 6px;font-size:0.75em;vertical-align:top">
  Dedicated to our colleague Frank who passed away recently</span> :bouquet:
</div>
