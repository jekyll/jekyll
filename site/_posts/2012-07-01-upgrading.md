---
layout: docs
title: Upgrading
prev_section: resources
---

Upgrading from an older version of Jekyll? A few things have changed in 1.0.

### The Jekyll Command

For better clarity, Jekyll now accepts the commands `build` and `serve`.
Whereas before you might simply run the command `jekyll` to generate a site
and `jekyll --serve` to view it locally, now use the subcommands `jekyll build`
and `jekyll serve` to do the same. And if you want Jekyll to automatically 
rebuild each time a file changes, just add the `--watch` flag at the end.

### Custom Config File

Rather than passing individual flags via the command line, you can now pass an
entire custom Jekyll config file. This helps to distinguish between
environments, or lets you programmatically override user-specified defaults.
Simply add the `--config` flag to the `jekyll` command, followed by the path 
to one or more config files.

<div class="note info">
  <h5 mardown="1">The `--config` flag overrides your `_config.yml` file</h5>
  <p markdown="1">If you use the `--config` flag, Jekyll will ignore your 
    `_config.yml` file. Want to merge a custom configuration with the normal 
    configuration? No problem. Jekyll will accept more than one custom config 
    file via the command line. Simply pass the path to both files with the latter 
    file overriding the former.</p>
</div>

#### As a result, the following command line flags are now deprecated:

* `--no-server`
* `--no-auto`
* `--auto` (now `--watch`)
* `--server`
* `--url=`
* `--maruku`, `--rdiscount`, and `--redcarpet`
* `--pygments`
* `--permalink=`
* `--paginate`

### Draft posts

### Baseurl