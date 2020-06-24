---
title: 'Jekyll 4.1.1 Released'
date: 2020-06-24 16:45:35 +0530
author: ashmaroli
version: 4.1.1
category: release
---

Jekyll 4.1.0 brought two notable changes: *Page-excerpts* and *Liquid Drop for Page objects*.
However these seemingly benign changes had unexpected adverse side-effects which did not figure in our tests.

The Core team decided that the best way forward is to revert introduction of the Liquid drop for Pages but push back
generating excerpts for pages behind a flag until `v5.0`.

Page-excerpts are henceforth an opt-in experimental feature which can be enabled by setting `page_excerpts: true` in
your configuration file. Due to its experimental nature, we have narrowed the scope for page-excerpts to limit their
negative effect on builds. Excerpts will not be generated for pages that *do not* output into an HTML file even if
`page_excerpts: true` has been set in the configuration file.

Another known issue with page-excerpts is that an infinite loop is created in certain use-cases such as any construct
that involves iterating through `site.pages` directly within a `Jekyll::Page` instance. A couple of examples would be
having a variant of either of the following code blocks inside a page source, say `index.markdown` or `about.markdown`:

{% raw %}

```liquid
{% for entry in site.pages %}
  {{ entry.name }}
{% endfor %}
```

```liquid
{{ site.pages | sort: 'title' }}
```

{% endraw %}

Therefore, we advise caution when opting to use the page-excerpt feature.
