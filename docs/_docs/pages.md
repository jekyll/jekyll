---
layout: docs
title: Creating pages
permalink: /docs/pages/
---

In addition to [writing posts](../posts/), another thing you may want to do
with your Jekyll site is create static pages. By taking advantage of the way
Jekyll copies files and directories, this is easy to do.

## Homepage

Just about every web server configuration you come across will look for an HTML
file called `index.html` (by convention) in the site's root folder and display
that as the homepage. Unless the web server you’re using is configured to look
for some different filename as the default, this file will turn into the
homepage of your Jekyll-generated site.

<div class="note">
  <h5>ProTip™: Use layouts on your homepage</h5>
  <p>
    Any HTML file on your site can use layouts and/or includes, even the
    homepage. Common content, like headers and footers, make excellent
    candidates for extraction into a layout.
  </p>
</div>

## Where additional pages live

Where you put HTML or [Markdown](https://daringfireball.net/projects/markdown/)
files for pages depends on how you want the pages to work. There are two main ways of creating pages:

- Place named HTML or [Markdown](https://daringfireball.net/projects/markdown/)
files for each page in your site's root folder.
- Place pages inside folders and subfolders named whatever you want.

Both methods work fine (and can be used in conjunction with each other),
with the only real difference being the resulting URLs. Pages retain the same folder structure in _site as they do in the source directory.

### Named HTML files

The simplest way of adding a page is just to add an HTML file in the root
directory with a suitable name for the page you want to create. For a site with
a homepage, an about page, and a contact page, here’s what the root directory
and associated URLs might look like:

```sh
.
|-- _config.yml
|-- _includes/
|-- _layouts/
|-- _posts/
|-- _site/
|-- about.html    # => http://example.com/about.html
|-- index.html    # => http://example.com/
|-- other.md      # => http://example.com/other.html
└── contact.html  # => http://example.com/contact.html
```

If you have a lot of pages, you can organize those pages into subfolders. The same subfolders that are used to group your pages in our project's source will exist in the _site folder when your site builds.

If you want to automatically move pages to the root in the _site directory when your page builds (similar to post behavior), add a permalink in your page's frontmatter like this:

```
---
title: My page
permalink: mypageurl.html
---
```

### Named folders containing index HTML files

If you don't want file extensions (`.html`) to appear in your page URLs (file extensions are the default), you can choose a [permalink style](../permalinks/#builtinpermalinkstyles) that has a trailing slash instead of a file extension.

Which style is better &mdash; URLs with file extensions or clean URLs? Neither has better SEO, but some people feel that clean URLs are more readable and hence more likely to be clicked in search results.

On the other hand, if you want to build your site and view it offline without the Jekyll preview server, your browser will need the file extension to display the page.
