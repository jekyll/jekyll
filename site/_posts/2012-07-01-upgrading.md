---
layout: docs
title: Upgrading
prev_section: resources
---

Upgrading from an older version of Jekyll? A few things have changed in 1.0.

### The Jekyll Command

For better clarity, Jekyll now accepts the commands `build` and `serve`.
Rather than just `jekyll` and `jekyll --serve`. If you want Jekyll to
automatically rebuild each time a file changes, just add the `--watch` flag.

### Custom Config File

Rather than passing individual flags via the command line, you can now pass an
entire custom Jekyll config file. This helps to distinguish between
environments, or lets you problematically override user-specified defaults.
Simply add the `--config` flag, followed by the path to one or more config
files.

<div class="note info">
  <h5 mardown="1">The `--config` flag overrides your `_config.yml` file</h5>
  <p markdown="1">If you use the `--config` flag, Jekyll will ignore your 
    `_config.yml` file. Want to merge a custom configuration with the normal 
    configuration? No problem. Jekyll will accept more than one custom config 
    file via the command line. Simply pass the URL to both files with the latter 
    file overriding the first.</p>
</div>

#### As a result, the following command line flags are deprecated:

* `--no-server`
* `--no-auto`
* `--auto`
* `--server`
* `--url=`
* `--safe`
* `--maruku`, `--rdiscount`, and `--redcarpet`
* `--pygments`
* `--permalink=`
* `--paginate`

### Draft posts

### Baseurl