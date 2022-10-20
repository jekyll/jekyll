---
title: 'Jekyll 4.3.0 Released'
date: 2022-10-20 10:20:22 -0500
author: ashmaroli
version: 4.3.0
category: release
---

Hello Jekyllers!

The Jekyll team is happy to announce the release of `v4.3.0` shipping with some nice improvements and bug-fixes.

## Improvements

### Dependencies

- Gem `webrick` is now a listed dependency. You no longer have to add the gem to your Gemfile when using Jekyll with
Ruby 3.0 or newer.
- You may now use Rouge v4 or continue using Rouge v3.x by explicitly mentioning the version in your Gemfile.
- Support for gem `tzinfo` v2 and non-half-hour offsets have been added.
- You will be able to use v3 of `jekyll-sass-converter` when it ships.

### Builds

- Added support for bundling and loading data files from within a theme-gem similar to existing theme-gem contents.
- Changes to data files at source will now be respected during incremental builds.
- `site.static_files` now include static files within a collection.
- You may now configure converters for CSV data.
- `.jekyll-cache` or its equivalent custom cache directory will be automatically ignored by Git.
- Vendor the current latest mime-types dataset for use with local development server.

{% raw %}
### Liquid Templates

- `basename` attribute of documents are now exposed to Liquid as `name`, for example `{{ page.name }}`. Excerpts delegate
to associated document attribute.
- Top-level variable `{{ theme }}` introduced to expose gemspec details of theme-gem. (Valid only when using theme-gem)
{% endraw %}

## Bug-fixes

Some noteworthy bug-fixes include:

- Respect `BUNDLE_GEMFILE` when loading Jekyll plugins via Bundler.
- Prevent loading versions older than kramdown-2.3.1 as a security measure.
- Trigger livereloading even if the site has *no pages*.
- Ensure the expected class of theme config is returned following a merger.
- Enable BOM encoding only if configured encoding is 'UTF-8'.
- Respect server protocol while injecting livereload script.
- The table output for `--profile` stops printing incorrect "TOTALS" row.

[The full list of changes](/docs/history/#v4-3-0) may be perused if interested.

As always, we are grateful to the many contributors that helped improve the project codebase and documentation:

<small>Ashwin Maroli, Frank Taillandier, Matt Rogers, Parker Moore, Kelvin M. Klann, Josh Soref, Youssef Boulkaid,
Emily Grace Seville, Robert Martin, jaybe@jekyll, Ben Keith, Jonathan Darrer, Kaben, Mike Kasberg, Moncef Belyamani,
Phil Ross, Sesh Sadasivam, Adam Bell, Alaz Tetik, Alex Malaszkiewicz, Alex Saveau, Andreas Deininger, Andrew Davis,
Andrew Gutekanst, Andrii Abramov, Aram Akhavan, Atlas Cove, Attaphong Rattanaveerachanon, Ben Whetton, Chris Keefe,
Clayton Smith, Craig H Maynard, Curious Cat, Daniel Haim, Daniel Kehoe, Daryl Hepting, David Bruant, David Zhang,
Edson Jiménez, Eric Cousineau, Gary, Giuseppe Bertone, Ikko Ashimine, JJ, JT, Jeff Wilcox, Jeffrey Veen,
Jesse van der Pluijm, John Losito, Kantanat-Stamp, Kirstin Heidler, Korbs, Laurence Andrews, Liam Bigelow, Maik Riechert,
Meet Gor, Meg Gutshall, Michael Gerzabek, MichaelCordingley, Miguel Brandão, Nahin Khan, Nemo, Nicholas Paxford,
Nick Coish, Otto Urpelainen, Parikshit87, Phil Kirlin, Qasim Qureshi, Ricardo N Feliciano, Rishi Raj Jain, SNVMK,
SaintMalik, Sampath Sukesh Ravolaparthi, Shannon Kularathna, Shyam Mohan K, Takuya N, Tejas Bubane, Toshimaru, Tyler887,
Vinhas Kevin, alena-ko, fauno, lm, lucafrance, nusu, shorty, なつき</small>

---

### Announcement

I would like to inform you that following this release, Jekyll will start developing towards a v5.0 milestone that will
**definitely contain breaking changes**. I have set up a [tentative roadmap at the GitHub repository][roadmap] to give everyone
a glimpse of the PROBABLE OUTCOME. Towards that end, we will no longer accept documentation fixes on `master`. The `4.3-stable`
branch will be used to build and deploy the site for https://jekyllrb.com.

Jekyll 3.x series is now under security-maintenance phase. Only security patches will be released when necessary.

Jekyll 4.x series will continue receiving bug-fixes and security-patches only. Depending on the state of progress towards v5.0,
there will be *at least* one minor version release serving as a transitionary version containing deprecations and bridge code
to ease the eventual upgrade to v5.0.

[roadmap]: {{ site.repository }}/issues/9156

---

That is all for now.
Happy Jekyllin'!!
