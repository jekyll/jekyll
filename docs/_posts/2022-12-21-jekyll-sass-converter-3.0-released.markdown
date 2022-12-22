---
title: Jekyll Sass Converter 3.0 Released
date: 2022-12-21 17:52:15 +0530
author: ashmaroli
category: community
---

Jekyll Sass Converter 3.0 shipped recently and is available to those using Jekyll 4.3 and above. This release contains major changes.
Specifically, the plugin has **stopped using `sassc` for converting your Sass partials and stylesheets** into CSS files.
Instead, the converter now uses the `sass-embedded` gem acting as an interface to Dart Sass, which is the current primary
implementation of Sass under active development. The secondary implementation `libsass` which the `sassc` gem interfaced
with has been deprecated by its developers.

However, Dart Sass isn't *fully compatible* with older Ruby Sass workflow.

## Requirements

- Minimum Ruby Version: `Ruby 2.6.0` (all platforms).
- Minimum Rubygems Version: `3.3.22` (for Linux-based platforms).

## Migration Guide

### Dropped `implmentation` Option

In `v3.0.x`, `sass-embedded` is the only supported Sass implmentation, and therefore the config option
`sass.implementation` introduced in `v2.2.0` has been removed.


### Dropped `add_charset` Option

The converter will no longer emit `@charset "UTF-8";` or a `U+FEFF` (byte-order marker) for `sassify` and `scssify`
Jekyll filters and hence the redundant option `sass.add_charset` is no longer active.


### Dropped `line_comments` Option

`sass-embedded` does not support `sass.line_comments` option.


### Dropped support of importing files with non-standard extension names

`sass-embedded` only allows importing files that have extension names of `.sass`, `.scss` or `.css`. SCSS syntax in
files with `.css` extension name will result in a syntax error.


### Dropped support of importing files relative to site source

In `v2.x`, the Converter allowed imports using paths relative to site source directory, even if the site source
directory is not present in Sass' `load_paths` option. This is a side effect of a bug in the converter, which will remain as is in
`v2.x` due to its usage in the wild.

In `v3.x`, imports using paths relative to site source directory will not work out of box. To allow these imports, `.`
(meaning current directory, or site source directory) need to be explicitly listed under `load_paths` option.


### Dropped support of importing files with the same filename as their parent file

In `v2.x`, the Converter allowed imports of files with the same filename as their parent file from `sass_dir` or
`load_paths`. This is a side effect of a bug in the Converter, which will remain as is in `v2.x` due to its usage in the
wild.

In `v3.x`, imports using the same filename of parent file will create a circular import. To fix such imports, rename
either of the files, or use complete relative path from the parent file.


### Behavioral Differences in Sass Implementation

There are a few intentional behavioral differences between Dart Sass and Ruby Sass. Please refer
[Behavioral Differences from Ruby Sass][behavioral-differences] for details.

[behavioral-differences]: https://github.com/sass/dart-sass#behavioral-differences-from-ruby-sass
