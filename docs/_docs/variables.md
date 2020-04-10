---
title: Variables
permalink: /docs/variables/
---

Jekyll traverses your site looking for files to process. Any files with
[front matter](/docs/front-matter/) are subject to processing. For each of these
files, Jekyll makes a variety of data available via [Liquid](/docs/liquid/).
The following is a reference of the available data.

## Global Variables

{% include docs_variables_table.html scope=site.data.jekyll_variables.global %}

## Site Variables

{% include docs_variables_table.html scope=site.data.jekyll_variables.site %}

## Page Variables

{% include docs_variables_table.html scope=site.data.jekyll_variables.page %}

{: .note}
**ProTip™: Use Custom Front Matter**{:.title}<br>
Any custom front matter that you specify will be available under
<code>page</code>. For example, if you specify <code>custom_css: true</code>
in a page’s front matter, that value will be available as <code>page.custom_css</code>.
<br>
If you specify front matter in a layout, access that via <code>layout</code>.
For example, if you specify <code>class: full_page</code> in a layout’s front matter,
that value will be available as <code>layout.class</code> in the layout and its parents.

## Paginator

{% include docs_variables_table.html scope=site.data.jekyll_variables.paginator %}

{: .note .info}
**Paginator variable availability**{:.title}<br>
These are only available in index files, however they can be located in a subdirectory,
such as <code>/blog/index.html</code>.
