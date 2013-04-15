---
layout: docs
title: Upgrading
prev_section: resources
---

Upgrading from an older version of Jekyll? A few things have changed in 1.0.


<div class="note feature">
  <h5 mardown="1">Diving in</h5>
  <p markdown="1">Want to get a new Jekyll site up and running quickly? Simply
   run `jekyll new [sitename]`, to create a new folder with a bare bones
   Jekyll site.</p>
</div>

### The Jekyll Command

For better clarity, Jekyll now accepts the commands `build` and `serve`.
Whereas before you might simply run the command `jekyll` to generate a site
and `jekyll --serve` to view it locally, now use the subcommands `jekyll build`
and `jekyll serve` to do the same. And if you want Jekyll to automatically 
rebuild each time a file changes, just add the `--watch` flag at the end.

<div class="note info">
  <h5 mardown="1">Watching and Serving</h5>
  <p markdown="1">With the new subcommands, the way sites are previewed locally
   changed a bit. Instead of specifying `server: true` in the site's 
   `_config.yml` file, use `jekyll serve`. The same hold's true for 
   `watch: true`. Instead, use the `--watch` flag with either `jekyll serve`
    or `jekyll build`.</p>
</div>

### Custom Config File

Rather than passing individual flags via the command line, you can now pass an
entire custom Jekyll config file. This helps to distinguish between
environments, or lets you programmatically override user-specified defaults.
Simply add the `--config` flag to the `jekyll` command, followed by the path 
to one or more config files.

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

<div class="note info">
  <h5 mardown="1">The `--config` explicitly specifies your configuration file(s)</h5>
  <p markdown="1">If you use the `--config` flag, Jekyll will ignore your 
    `_config.yml` file. Want to merge a custom configuration with the normal 
    configuration? No problem. Jekyll will accept more than one custom config 
    file via the command line. Config files cascade from right to left, such 
    that if I run `jekyll serve --config _config.yml,_config-dev.yml`,
    the values in the config files on the right (`_config-dev.yml`) overwrite 
    those on the left (`_config.yml`) when both contain the same key.</p>
</div>

### Draft posts

Jekyll now lets you write draft posts, and allows you to easily preview how 
they will look prior to publishing. To start a draft, simply create a folder
called `_drafts` in your site's source directory (e.g., alongside `_posts`), 
and add a new markdown file to it. To preview your new post, simply run the 
`Jekyll serve` command with the `--drafts` flag.

<div class="note info">
  <h5 mardown="1">Drafts don't have dates</h5>
  <p markdown="1">Unlike posts, drafts don't have a date, since they haven't
  been published yet. Rather than naming your draft something like
  `2013-07-01-my-draft-post.md`, simply name the file what you'd like your 
  post to eventually be titled, here `my-draft-post.md`.</p>
</div>

### Baseurl

Often, you'll want the ability to run a Jekyll site in multiple places, such as
previewing locally before pushing to GitHub Pages. Jekyll 1.0 makes that 
easier with the new `--baseurl` flag. Throughout your Jekyll site, simply 
prefix relative urls with `{{ site.baseurl }}` and add the production `baseurl` 
to your `_config.yml` file. When previewing locally, Jekyll will swap in 
whatever you pass along via the `--baseurl` flag (most likely `/`), ensuring 
your links remain true in both environments.