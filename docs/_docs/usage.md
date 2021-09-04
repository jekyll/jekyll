---
title:  Command Line Usage
permalink: /docs/usage/
---

The Jekyll gem makes a `jekyll` executable available to you in your terminal.

The `jekyll` program has several commands but the structure is always:

```
jekyll command [argument] [option] [argument_to_option]

Examples:
    jekyll new site/ --blank
    jekyll serve --config _alternative_config.yml
```

Typically you'll use `jekyll serve` while developing locally and `jekyll build` when you need to generate the site for production.

For a full list of options and their argument, see [Build Command Options](/docs/configuration/options/#build-command-options).

Here are some of the most common commands:

* `jekyll new PATH` - Creates a new Jekyll site with default gem-based theme at specified path. The directories will be created as necessary.
* `jekyll new PATH --blank` - Creates a new blank Jekyll site scaffold at specified path.
* `jekyll build` or `jekyll b` - Performs a one off build your site to `./_site` (by default).
* `jekyll serve` or `jekyll s` - Builds your site any time a source file changes and serves it locally.
* `jekyll clean` - Removes all generated files: destination folder, metadata file, Sass and Jekyll caches.
* `jekyll help` - Shows help, optionally for a given subcommand, e.g. `jekyll help build`.
* `jekyll new-theme` - Creates a new Jekyll theme scaffold.
* `jekyll doctor` - Outputs any deprecation or configuration issues.

To change Jekyll's default build behavior have a look through the [configuration options](/docs/configuration/).
