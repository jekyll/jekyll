---
layout: docs
title: Variables
prev_section: pages
next_section: migrations
---

Jekyll traverses your site looking for files to process. Any files with [YAML Front Matter](../frontmatter) are subject to processing. For each of these files, Jekyll makes a variety of data available to the pages via the [Liquid templating system](http://wiki.github.com/shopify/liquid/liquid-for-designers). The following is a reference of the available data.

## Global Variables

<table>
  <thead>
    <tr>
      <td>Variable</td>
      <td>Description</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><p><code>site</code></p></td>
      <td><p>Sitewide information + Configuration settings from <code>_config.yml</code></p></td>
    </tr>
    <tr>
      <td><p><code>page</code></p></td>
      <td><p>This is just the <a href="../frontmatter">YAML Front Matter</a> with 2 additions: <code>url</code> and <code>content</code>.</p></td>
    </tr>
    <tr>
      <td><p><code>content</code></p></td>
      <td><p>In layout files, this contains the content of the subview(s). This is the variable used to insert the rendered content into the layout. This is not used in post files or page files.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator</code></p></td>
      <td><p>When the <code>paginate</code> configuration option is set, this variable becomes available for use.</p></td>
    </tr>
  </tbody>
</table>

## Site Variables

<table>
  <thead>
    <tr>
      <td>Variable</td>
      <td>Description</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><p><code>site.time</code></p></td>
      <td><p>The current time (when you run the <code>jekyll</code> command).</p></td>
    </tr>
    <tr>
      <td><p><code>site.posts</code></p></td>
      <td><p>A reverse chronological list of all Posts.</p></td>
    </tr>
    <tr>
      <td><p><code>site.related_posts</code></p></td>
      <td><p>If the page being processed is a Post, this contains a list of up to ten related Posts. By default, these are low quality but fast to compute. For high quality but slow to compute results, run the <code>jekyll</code> command with the <code>--lsi</code> (latent semantic indexing) option.</p></td>
    </tr>
    <tr>
      <td><p><code>site.categories.CATEGORY</code></p></td>
      <td><p>The list of all Posts in category <code>CATEGORY</code>.</p></td>
    </tr>
    <tr>
      <td><p><code>site.tags.TAG</code></p></td>
      <td><p>The list of all Posts with tag <code>TAG</code>.</p></td>
    </tr>
    <tr>
      <td><p><code>site.[CONFIGURATION_DATA]</code></p></td>
      <td><p>All variables set in your <code>_config.yml</code> are available through the <code>site</code> variable. For example, if you have <code>url: http://mysite.com</code> in your configuration file, then in your posts and pages it can be accessed using <code>{{ "{{ site.url " }}}}</code>. Jekyll does not parse changes to <code>_config.yml</code> in <code>watch</code> mode, you have to restart Jekyll to see changes to variables.</p></td>
    </tr>
  </tbody>
</table>

## Page Variables

<table>
  <thead>
    <tr>
      <td>Variable</td>
      <td>Description</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><p><code>page.content</code></p></td>
      <td><p>The un-rendered content of the Page.</p></td>
    </tr>
    <tr>
      <td><p><code>page.title</code></p></td>
      <td><p>The title of the Post.</p></td>
    </tr>
    <tr>
      <td><p><code>page.url</code></p></td>
      <td><p>The URL of the Post without the domain. e.g. <code>/2008/12/14/my-post.html</code></p></td>
    </tr>
    <tr>
      <td><p><code>page.date</code></p></td>
      <td><p>The Date assigned to the Post. This can be overridden in a post’s front matter by specifying a new date/time in the format <code>YYYY-MM-DD HH:MM:SS</code></p></td>
    </tr>
    <tr>
      <td><p><code>page.id</code></p></td>
      <td><p>An identifier unique to the Post (useful in RSS feeds). e.g. <code>/2008/12/14/my-post</code></p></td>
    </tr>
    <tr>
      <td><p><code>page.categories</code></p></td>
      <td><p>The list of categories to which this post belongs. Categories are derived from the directory structure above the <code>_posts</code> directory. For example, a post at <code>/work/code/_posts/2008-12-24-closures.textile</code> would have this field set to <code>['work', 'code']</code>. These can also be specified in the <a href="../frontmatter">YAML Front Matter</a>.</p></td>
    </tr>
    <tr>
      <td><p><code>page.tags</code></p></td>
      <td><p>The list of tags to which this post belongs. These can be specified in the <a href="../frontmatter">YAML Front Matter</a></p></td>
    </tr>
  </tbody>
</table>

<div class="note">
  <h5>ProTip™: Use custom front-matter</h5>
  <p>Any custom front matter that you specify will be available under <code>page</code>. For example, if you specify <code>custom_css: true</code> in a page’s front matter, that value will be available in templates as <code>page.custom_css</code>.</p>
</div>

## Paginator

<table>
  <thead>
    <tr>
      <td>Variable</td>
      <td>Description</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><p><code>paginator.per_page</code></p></td>
      <td><p>Number of posts per page.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.posts</code></p></td>
      <td><p>Posts available for that page.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.total_posts</code></p></td>
      <td><p>Total number of posts.</p></td>
    </tr>
    <tr>
      <td><p><code>paginator.total_pages</code></p></td>
      <td><p>Total number of pages.</p></td>
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
      <td><p><code>paginator.next_page</code></p></td>
      <td><p>The number of the next page.</p></td>
    </tr>
  </tbody>
</table>

<div class="note info">
  <h5>Paginator variable availability</h5>
  <p>These are only available in index files, however they can be located in a subdirectory, such as <code>/blog/index.html</code>.</p>
</div>
