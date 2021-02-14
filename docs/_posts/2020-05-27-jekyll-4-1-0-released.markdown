---
title: 'Jekyll 4.1.0 Released'
date: 2020-05-27 15:20:30 +0530
author: ashmaroli
version: 4.1.0
category: release

filters_linked_to:
- where expression
- find expression
- find
- number of words
---

Hello Jekyllers!

It's time for yet another release that includes enhancements, optimizations and bug-fixes. Highlights of this release
are:

* Jekyll now supports rendering excerpts for *pages* in addition to documents and posts.
* The [`where_exp`][where-expression-filter] filter got enhanced.  Earlier, one could just use either `and` or `or` once
per expression. Now, one may use those binary operators multiple times in the filter's expression.
* Jekyll has a new set of filters based on *its flavor* of the `where` and `where_exp` filters. Named
[`find`][find-filter] and [`find_exp`][find-expression-filter] filters respectively, they work similar to their ancestors
except that they return **the first object** that satisfies the given conditions.
* Jekyll's [`number_of_words`][number-of-words-filter] filter can now take an optional argument to better count words
of text containing Chinese, Japanese or Korean characters.
* One may now use `:slugified_categories` in their permalink configurations to generate a more apt URL (categories are
downcased and non-alphanumeric characters replaced by dashes) for their for posts and documents.
* The logic for *slugifying* a given string has been enhanced to support more Unicode characters.
* If you face issues from Jekyll importing a config file bundled within a theme, you can now disable the import entirely
by setting `ignore_theme_config: true` in your site's configuration file.
* If you face issues from Jekyll's disk-caching feature, you can now disable the mechanism without opting to build in
`safe` mode, by either setting `disable_disk_cache: true` in your configuration file or by passing the CLI switch
`--disable-disk-cache` to `jekyll build` or `jekyll serve` commands.
* When you build a site with the `--profile` switch, Jekyll will now additionally output a small table showing the amount
of time taken during various stages of the *build process*.
* Jekyll's development server now supports certificates based on Elliptic-curve cryptography.

For the interest of plugin authors:
* Excerpts won't be generated for `Jekyll::Page` subclasses automatically unless such instances have an `excerpt` key in
their `data` hash.

For the interest of gem-based theme authors:
* From `v4.1.0` onwards, a newly generated theme workspace (via `jekyll new-theme ...`) will have the gemspec configured
to bundle a `_config.yml` at the root of the workspace. If you don't wish to include the configuration file in the
released gem, please remove `|_config\.yml` from the regular expression in the gemspec.

{% for filter in page.filters_linked_to %}
{% assign filter_slug = filter | slugify %}
[{{ filter_slug }}-filter]: {{ filter_slug | prepend: '/docs/liquid/filters/#' | relative_url }}
{% endfor %}

### Have questions?

Please reach out on our [community forum](https://talk.jekyllrb.com)


### Thank you!! :bow:

We are thankful to our community for all the contributions that helped shape this release.
Special thanks to the following 78 contributors (in alphabetical order) who made this release possible and took the time
to submit a pull request:

Aaron Adams, Aaron K Redshaw, Alexandre Zanni, Anindita Basu, Arthur Zey, Artyom Tokachev, Ashwin Maroli, Atlas Cove,
Ben Stolovitz, Billy Kong, Christian Oliff, codenitpicker, csquare, Damien St Pierre, Daniel Leidert, David Zhang,
ddocs, dgolant, dkalev, Dmitry Egorov, dotnetCarpenter, Edward Thomson, Eric Knibbe, Frank Taillandier, Gabriel Rubens,
Gareth Mcshane, Grzegorz Kaczorek, guanicoe, Harry Wood, HTeuMeuLeu, iBug, İsmail Arılık, Itay Shakury, Ivan Gromov,
Ivan Raszl, J·Y, James Buckley, Jason Taylor, JC, jeffreytse, Johan Wigert, jonas-krummenacher, Justin Jia,
Kayce Basques, Kieran Barker, Leo, Liam Bigelow, lizharris, Lizzy Kate, Luis Puente, Mark Bennett, Matt Penna,
Matt Rogers, matt swanson, Max Chadwick, michaelcurrin, Mike Kasberg, Mike Neumegen, Muhammed Salih, Nikhil Benesch,
Paramdeo Singh, Patrik Eriksson, Phil Nash, Philip Eriksson, R.P. Pedraza, Radoslav Karlík, Riccardo Porreca,
sharath Kumar, Simone Arpe, Takashi Udagawa, Tobias Klüpfel, Toby Glei, vhermecz, Viktor Szakats, Ward Sandler, wzy,
XhmikosR, Zlatan Vasović.
