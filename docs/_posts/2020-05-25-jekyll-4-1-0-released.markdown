---
title: 'Jekyll 4.1.0 Released'
date: 2020-05-25 19:25:30 +0530
author: ashmaroli
version: 4.1.0
category: release
---

Hello Jekyllers!

It's time for yet another release that includes enhancements, optimizations and bug-fixes. Highlights of this release
are:

* Jekyll now supports rendering excerpts for *pages* in addition to documents and posts.
* One may now use `:slugified_categories` in their permalink configurations to generate a more apt URL (categories are
downcased and non-alphanumeric characters replaced by dashes) for their for posts and documents.
* When you build a site with the `--profle` switch, Jekyll will now additionally output a small table showing the amount
of time taken during various stages of the *build process*.
* Jekyll's development server now supports certificates based on Elliptic-curve cryptography.
* The `where_exp` filter got enhanced.  Earlier, one could just use either `and` or `or` once per expression. Now, one
may use those binary operators multiple times in the filter's expression.
* Jekyll has a new set of filters based on *its flavor* of the `where` and `where_exp` filters. Named `find` and
`find_exp` filters respectively, they work similar to their ancestors except that they return **the first object** that
satisfies the given conditions.
* Jekyll's `number_of_words` filter can now take [an optional argument][filters-docs] to better count words of text
containing Chinese, Japanese or Korean characters.
* The logic for *slugifying* a given string has been enhanced to support more Unicode characters.
* If you face issues from Jekyll importing a config file bundled within a theme, you can now disable the import entirely
by setting `ignore_theme_config: true` in your site's configuration file.
* If you face issues from Jekyll's disk-caching feature, you can now disable the mechanism without opting to build in
`safe` mode, by either setting `disable_disk_cache: true` in your configuration file or by passing the CLI switch
`--disable-disk-cache` to `jekyll build` or `jekyll serve` commands.

For the interest of plugin authors:
* `Jekyll::Page` now uses a Liquid Drop to expose attributes for Liquid templates. However, its subclasses will continue
using the legacy `ATTRIBUTES_FOR_LIQUID` hash by default. More details in the [associated documentation][page-drop-docs]
* Excerpts won't be generated for `Jekyll::Page` subclasses automatically unless such instances have an `excerpt` key in
their `data` hash.

[filters-docs]: {{ 'docs/liquid/filters/' | relative_url }}
[page-drop-docs]: {{ 'docs/pages/#for-plugin-developers' | relative_url }}

For the interest of plugin authors:
* From `v4.1.0` onwards, a newly generated theme workspace (via `jekyll new-theme ...`) will have the gemspec configured
to bundle a `_config.yml` at the root of the workspace. If you don't wish to include the configuration file in the
released gem, please remove `|_config\.yml` from the regular expression in the gemspec.
