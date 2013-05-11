---
layout: docs
title: Upgrading
prev_section: resources
permalink: /docs/upgrading/
---

Upgrading from an older version of Jekyll? A few things have changed in 1.0
that you'll want to know about.


<div class="note feature">
  <h5 markdown="1">Diving in</h5>
  <p markdown="1">Want to get a new Jekyll site up and running quickly? Simply
   run <code>jekyll new SITENAME</code> to create a new folder with a bare bones
   Jekyll site.</p>
</div>

### The Jekyll Command

For better clarity, Jekyll now accepts the commands `build` and `serve`.
Whereas before you might simply run the command `jekyll` to generate a site
and `jekyll --server` to view it locally, now use the subcommands `jekyll build`
and `jekyll serve` to do the same. And if you want Jekyll to automatically
rebuild each time a file changes, just add the `--watch` flag at the end.

<div class="note info">
  <h5 markdown="1">Watching and Serving</h5>
  <p markdown="1">With the new subcommands, the way sites are previewed locally
   changed a bit. Instead of specifying `server: true` in the site's
   configuration file, use `jekyll serve`. The same hold's true for
   `watch: true`. Instead, use the `--watch` flag with either `jekyll serve`
    or `jekyll build`.</p>
</div>

### Custom Config File

Rather than passing individual flags via the command line, you can now pass an
entire custom Jekyll config file. This helps to distinguish between
environments, or lets you programmatically override user-specified defaults.
Simply add the `--config` flag to the `jekyll` command, followed by the path
to one or more config files (comma-delimited, no spaces).

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
  <h5 markdown="1">The `--config` explicitly specifies your configuration file(s)</h5>
  <p markdown="1">If you use the `--config` flag, Jekyll will ignore your
    `config.yml` file. Want to merge a custom configuration with the normal
    configuration? No problem. Jekyll will accept more than one custom config
    file via the command line. Config files cascade from right to left, such
    that if I run `jekyll serve --config config.yml,config-dev.yml`,
    the values in the config files on the right (`config-dev.yml`) overwrite
    those on the left (`config.yml`) when both contain the same key.</p>
</div>

### Draft posts

Jekyll now lets you write draft posts, and allows you to easily preview how
they will look prior to publishing. To start a draft, simply create a folder
called `_drafts` in your site's source directory (e.g., alongside `_posts`),
and add a new markdown file to it. To preview your new post, simply run the
`Jekyll serve` command with the `--drafts` flag.

<div class="note info">
  <h5 markdown="1">Drafts don't have dates</h5>
  <p markdown="1">Unlike posts, drafts don't have a date, since they haven't
  been published yet. Rather than naming your draft something like
  `2013-07-01-my-draft-post.md`, simply name the file what you'd like your
  post to eventually be titled, here `my-draft-post.md`.</p>
</div>

### Baseurl

Often, you'll want the ability to run a Jekyll site in multiple places, such as
previewing locally before pushing to GitHub Pages. Jekyll 1.0 makes that
easier with the new `--baseurl` flag. To take advantage of this feature, first
add the production `baseurl` to your site's `_config.yml` file. Then,
throughout the site, simply prefix relative URLs with `{% raw %}{{ site.baseurl }}{% endraw %}`.
When you're ready to preview your site locally, pass along the `--baseurl` flag
with your local baseurl (most likely `/`) to `jekyll serve` and Jekyll will
swap in whatever you've passed along, ensuring all your links work as you'd
expect in both environments.


<div class="note warning">
  <h5 markdown="1">All page and post URLs contain leading slashes</h5>
  <p markdown="1">If you use the method described above, please remember
  that the URLs for all posts and pages contain a leading slash. Therefore,
  concatenating the site baseurl and the post/page url where
  `site.baseurl = /` and `post.url = /2013/06/05/my-fun-post/` will
  result in two leading slashes, which will break links. It is thus
  suggested that prefixing with `site.baseurl` only be used when the
  `baseurl` is something other than the default of `/`.</p>
</div>
