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

Jekyll now lets you write draft posts, and allows you to easily preview how 
they will look prior to publishing. To start a draft, simply create a folder
called `_drafts` in your site's source directory (e.g., along side `_posts`), 
and add a new markdown file to it. To generate preview your new post, simply 
run the `Jekyll` command with the `--drafts` flag.

<div class="note info">
  <h5 mardown="1">Drafts don't have dates</h5>
  <p markdown="1">Unlike posts, drafts don't have a date, since they haven't
  been published yet. Rather than naming your draft something like
  `2013-07-01-my-draft-post.md`, simply name the file what you'd like your 
  post to eventually be titled, here `my-draft-post.md`.</p>
</div>

### Baseurl

Often, you'll want the ability to run a Jekyll site in multiple places, such as
previewing locally before pushing to a server. Jekyll 1.0 makes that easier with
the new `--baseurl` flag. Throughout your Jekyll site, simply prefix relative
url with `{{ site.baseurl }}` and Jekyll will swap in whatever you pass along
ensuring your links remain true in both environments.
