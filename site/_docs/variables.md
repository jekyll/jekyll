---
layout: docs
title: Variables
permalink: /docs/variables/
---

Jekyll traverses your site looking for files to process. Any files with [YAML
front matter](../frontmatter/) are subject to processing. For each of these
files, Jekyll makes a variety of data available via the [Liquid templating
system](https://github.com/Shopify/liquid/wiki). The
following is a reference of the available data.

## Global Variables

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><p><code>site</code></p></td>
      <td><p>

          Sitewide information + configuration settings from
          <code>_config.yml</code>. See below for details.

      </p></td>
    </tr>
    <tr>
      <td><p><code>page</code></p></td>
      <td><p>

        Page specific information + the <a href="../frontmatter/">YAML front
        matter</a>. Custom variables set via the YAML Front Matter will be
        available here. See below for details.

      </p></td>
    </tr>
    <tr>
      <td><p><code>content</code></p></td>
      <td><p>

        In layout files, the rendered content of the Post or Page being wrapped.
        Not defined in Post or Page files.

      </p></td>
    </tr>
    <tr>
      <td><p><code>paginator</code></p></td>
      <td><p>

        When the <code>paginate</code> configuration option is set, this
        variable becomes available for use. See <a
        href="../pagination/">Pagination</a> for details.

      </p></td>
    </tr>
  </tbody>
</table>
</div>

## Site Variables

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><p><code>site.time</code></p></td>
      <td><p>

        The current time (when you run the <code>jekyll</code> command).

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.pages</code></p></td>
      <td><p>

        A list of all Pages.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.posts</code></p></td>
      <td><p>

        A reverse chronological list of all Posts.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.related_posts</code></p></td>
      <td><p>

        If the page being processed is a Post, this contains a list of up to ten
        related Posts. By default, these are the ten most recent posts.
        For high quality but slow to compute results, run the
        <code>jekyll</code> command with the <code>--lsi</code> (latent semantic
        indexing) option. Also note Github pages does not support the <code>lsi</code> option when generating sites.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.static_files</code></p></td>
      <td><p>

        A list of all <a href="/docs/static-files/">static files</a> (i.e.
        files not processed by Jekyll's converters or the Liquid renderer).
        Each file has three properties: <code>path</code>,
        <code>modified_time</code> and <code>extname</code>.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.html_pages</code></p></td>
      <td><p>

        A subset of `site.pages` listing those which end in `.html`.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.html_files</code></p></td>
      <td><p>

        A subset of `site.static_files` listing those which end in `.html`.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.collections</code></p></td>
      <td><p>

        A list of all the collections.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.data</code></p></td>
      <td><p>

        A list containing the data loaded from the YAML files located in the <code>_data</code> directory.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.documents</code></p></td>
      <td><p>

        A list of all the documents in every collection.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.categories.CATEGORY</code></p></td>
      <td><p>

        The list of all Posts in category <code>CATEGORY</code>.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.tags.TAG</code></p></td>
      <td><p>

        The list of all Posts with tag <code>TAG</code>.

      </p></td>
    </tr>
    <tr>
      <td><p><code>site.[CONFIGURATION_DATA]</code></p></td>
      <td><p>

        All the variables set via the command line and your
        <code>_config.yml</code> are available through the <code>site</code>
        variable. For example, if you have <code>url: http://mysite.com</code>
        in your configuration file, then in your Posts and Pages it will be
        stored in <code>site.url</code>. Jekyll does not parse changes to
        <code>_config.yml</code> in <code>watch</code> mode, you must restart
        Jekyll to see changes to variables.

      </p></td>
    </tr>
  </tbody>
</table>
</div>

## Page Variables

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><p><code>page.content</code></p></td>
      <td><p>

        The content of the Page, rendered or un-rendered depending upon
        what Liquid is being processed and what <code>page</code> is.

      </p></td>
    </tr>
    <tr>
      <td><p><code>page.title</code></p></td>
      <td><p>

        The title of the Page.

      </p></td>
    </tr>
    <tr>
      <td><p><code>page.excerpt</code></p></td>
      <td><p>

        The un-rendered excerpt of the Page.

      </p></td>
    </tr>
    <tr>
      <td><p><code>page.url</code></p></td>
      <td><p>

        The URL of the Post without the domain, but
        with a leading slash, e.g.
        <code>/2008/12/14/my-post.html</code>

      </p></td>
    </tr>
    <tr>
      <td><p><code>page.date</code></p></td>
      <td><p>

        The Date assigned to the Post. This can be overridden in a Post’s front
        matter by specifying a new date/time in the format
        <code>YYYY-MM-DD HH:MM:SS</code> (assuming UTC), or
        <code>YYYY-MM-DD HH:MM:SS +/-TTTT</code> (to specify a time zone using
        an offset from UTC. e.g. <code>2008-12-14 10:30:00 +0900</code>).

      </p></td>
    </tr>
    <tr>
      <td><p><code>page.id</code></p></td>
      <td><p>

        An identifier unique to the Post (useful in RSS feeds). e.g.
        <code>/2008/12/14/my-post</code>

      </p></td>
    </tr>
    <tr>
      <td><p><code>page.categories</code></p></td>
      <td><p>

        The list of categories to which this post belongs. Categories are
        derived from the directory structure above the <code>_posts</code>
        directory. For example, a post at
        <code>/work/code/_posts/2008-12-24-closures.md</code> would have this
        field set to <code>['work', 'code']</code>. These can also be specified
        in the <a href="../frontmatter/">YAML Front Matter</a>.

      </p></td>
    </tr>
    <tr>
      <td><p><code>page.tags</code></p></td>
      <td><p>

        The list of tags to which this post belongs. These can be specified in
        the <a href="../frontmatter/">YAML Front Matter</a>.

      </p></td>
    </tr>
    <tr>
      <td><p><code>page.path</code></p></td>
      <td><p>

        The path to the raw post or page. Example usage: Linking back to the
        page or post’s source on GitHub. This can be overridden in the
        <a href="../frontmatter/">YAML Front Matter</a>.

      </p></td>
    </tr>
    <tr>
      <td><p><code>page.next</code></p></td>
      <td><p>

        The next post relative to the position of the current post in
        <code>site.posts</code>. Returns <code>nil</code> for the last entry.

      </p></td>
    </tr>
    <tr>
      <td><p><code>page.previous</code></p></td>
      <td><p>

        The previous post relative to the position of the current post in
        <code>site.posts</code>. Returns <code>nil</code> for the first entry.

      </p></td>
    </tr>
  </tbody>
</table>
</div>

<div class="note">
  <h5>ProTip™: Use Custom Front Matter</h5>
  <p>

    Any custom front matter that you specify will be available under
    <code>page</code>. For example, if you specify <code>custom_css: true</code>
    in a page’s front matter, that value will be available as
    <code>page.custom_css</code>.

  </p>
</div>

## Paginator

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><p><code>paginator.per_page</code></p></td>
      <td><p>Number of Posts per page.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.posts</code></p></td>
      <td><p>Posts available for that page.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.total_posts</code></p></td>
      <td><p>Total number of Posts.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.total_pages</code></p></td>
      <td><p>Total number of Pages.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.page</code></p></td>
      <td><p>The number of the current page.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.previous_page</code></p></td>
      <td><p>The number of the previous page.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.previous_page_path</code></p></td>
      <td><p>The path to the previous page.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.next_page</code></p></td>
      <td><p>The number of the next page.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.next_page_path</code></p></td>
      <td><p>The path to the next page.</p></td>
    </tr>
  </tbody>
</table>
</div>

<div class="note info">
  <h5>Paginator variable availability</h5>
  <p>

    These are only available in index files, however they can be located in a
    subdirectory, such as <code>/blog/index.html</code>.

  </p>
</div>
