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

Where you put HTML files for pages depends on how you want the pages to work.
There are two main ways of creating pages:

- Place named HTML files for each page in your site's root folder.
- Create a folder in the site's root for each page, and place an index.html
file in each page folder.

Both methods work fine (and can be used in conjunction with each other),
with the only real difference being the resulting URLs.

### Named HTML files

The simplest way of adding a page is just to add an HTML file in the root
directory with a suitable name for the page you want to create. For a site with
a homepage, an about page, and a contact page, here’s what the root directory
and associated URLs might look like:

{% highlight bash %}
.
|-- _config.yml
|-- _includes/
|-- _layouts/
|-- _posts/
|-- _site/
|-- about.html    # => http://example.com/about.html
|-- index.html    # => http://example.com/
└── contact.html  # => http://example.com/contact.html
{% endhighlight %}

### Named folders containing index HTML files

There is nothing wrong with the above method. However, some people like to keep
their URLs free from things like filename extensions. To achieve clean URLs for
pages using Jekyll, you simply need to create a folder for each top-level page
you want, and then place an `index.html` file in each page’s folder. This way
the page URL ends up being the folder name, and the web server will serve up
the respective `index.html` file. Here's an example of what this structure
might look like:

{% highlight bash %}
.
├── _config.yml
├── _includes/
├── _layouts/
├── _posts/
├── _site/
├── about/
|   └── index.html  # => http://example.com/about/
├── contact/
|   └── index.html  # => http://example.com/contact/
└── index.html      # => http://example.com/
{% endhighlight %}

This approach may not suit everyone, but for people who like clean URLs it’s
simple and it works. In the end the decision is yours!
