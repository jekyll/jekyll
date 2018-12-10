---
title:  Command Line Usage
permalink: /docs/usage/
---

The Jekyll gem makes a `jekyll` executable available to you in your terminal.

You can use this command in a number of ways:

* `jekyll new` - Creates a new Jekyll site with default gem-based theme
* `jekyll new --blank` - Creates a new blank Jekyll site scaffold
* `jekyll build` or `jekyll b` - Performs a one off build your site to `./_site` (by default)
* `jekyll serve` or `jekyll s` - Builds your site any time a source file changes and serves it locally
* `jekyll doctor` - Outputs any deprecation or configuration issues
* `jekyll new-theme` - Creates a new Jekyll theme scaffold
* `jekyll clean` - Removes the generated site and metadata file
* `jekyll help` - Shows help, optionally for a given subcommand, e.g. `jekyll help build`

Typically you'll use `jekyll serve` while developing locally and `jekyll build` when you need to generate the site for production.

To change Jekyll's default build behavior have a look through the [configuration options](/docs/configuration/).
