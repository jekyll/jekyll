---
layout: docs
title: Variables
prev_section: pages
next_section: migrations
---

Jekyll traverses your site looking for files to process. Any files with
[YAML Front Matter](../frontmatter) are subject to processing. For each of these
files, Jekyll makes a variety of data available to the pages via the
[Liquid templating
system](http://wiki.github.com/shopify/liquid/liquid-for-designers). The
following is a reference of the available data.

Global
------

**Variable**   **Description**
`site`         Sitewide information + Configuration settings from `_config.yml`
`page`         This is just the [YAML Front Matter](../frontmatter) with 2 additions: `url` and `content`.
`content`      In layout files, this contains the content of the subview(s). This is the variable used to insert the rendered content into the layout. This is not used in post files or page files.
`paginator`    When the `paginate` configuration option is set, this variable becomes available for use.

Site
----

**Variable**                  **Description**
`site.time`                   The current Time (when you run the jekyll command).
`site.posts`                  A reverse chronological list of all Posts.
`site.related_posts`          If the page being processed is a Post, this contains a list of up to ten related Posts. By default, these are low quality but fast to compute. For high quality but slow to compute results, run the jekyll command with the `--lsi` (latent semantic indexing) option.
`site.categories.CATEGORY`    The list of all Posts in category `CATEGORY`.
`site.tags.TAG`               The list of all Posts with tag `TAG`.
`site.[CONFIGURATION_DATA]`   As of **0.5.2**, all data inside of your `_config.yml` is now available through the `site` variable. So for example, if you have `url: http://mysite.com` in your configuration file, then in your posts and pages it can be used like so: `{{ "{{ site.url " }}}}</code>. Jekyll does not parse a changed `_config.yml` in `auto` mode, you have to restart jekyll.

Page
----

**Variable**        **Description**
`page.content`      The un-rendered content of the Page.
`page.title`        The title of the Post.
`page.url`          The URL of the Post without the domain. e.g. `/2008/12/14/my-post.html`
`page.date`         The Date assigned to the Post. This can be overridden in a post’s front matter by specifying a new date/time in the format `YYYY-MM-DD HH:MM:SS`
`page.id`           An identifier unique to the Post (useful in RSS feeds). e.g. `/2008/12/14/my-post`
`page.categories`   The list of categories to which this post belongs. Categories are derived from the directory structure above the `_posts` directory. For example, a post at `/work/code/_posts/2008-12-24-closures.textile` would have this field set to `['work', 'code']`. These can also be specified in the [YAML Front Matter](../frontmatter)
`page.tags`         The list of tags to which this post belongs. These can be specified in the [YAML Front Matter](../frontmatter)

Note: Any custom front matter that you specify will be available under
`page`. For example, if you specify `custom_css: true` in a page’s front
matter, that value will be available in templates as `page.custom_css`

Paginator
---------

**note: only available in index files, can be in subdirectory
/blog/index.html**

**Variable**                **Description**
`paginator.per_page`        Number of posts per page.
`paginator.posts`           Posts available for that page.
`paginator.total_posts`     Total number of posts.
`paginator.total_pages`     Total number of pages.
`paginator.page`            The number of the current page.
`paginator.previous_page`   The number of the previous page.
`paginator.next_page`       The number of the next page.

