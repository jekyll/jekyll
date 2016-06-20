---
layout: docs
title: Permalinks
permalink: /docs/permalinks/
---

Jekyll supports a flexible way to build your site’s URLs. You can specify the
permalinks for your site through the [Configuration](../configuration/) or in
the [YAML Front Matter](../frontmatter/) for each post. You’re free to choose
one of the built-in styles to create your links or craft your own. The default
style is `date`.

Permalinks are constructed by creating a template URL where dynamic elements
are represented by colon-prefixed keywords. For example, the default `date`
permalink is defined according to the format `/:categories/:year/:month/:day/:title.html`.

## Template variables

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
      <td>
        <p><code>year</code></p>
      </td>
      <td>
        <p>Year from the Post’s filename</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>month</code></p>
      </td>
      <td>
        <p>Month from the Post’s filename</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>i_month</code></p>
      </td>
      <td>
        <p>Month from the Post’s filename without leading zeros.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>day</code></p>
      </td>
      <td>
        <p>Day from the Post’s filename</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>i_day</code></p>
      </td>
      <td>
        <p>Day from the Post’s filename without leading zeros.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>short_year</code></p>
      </td>
      <td>
        <p>Year from the Post’s filename without the century.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>hour</code></p>
      </td>
      <td>
        <p>
          Hour of the day, 24-hour clock, zero-padded from the post’s <code>date</code> front matter. (00..23)
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>minute</code></p>
      </td>
      <td>
        <p>
          Minute of the hour from the post’s <code>date</code> front matter. (00..59)
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>second</code></p>
      </td>
      <td>
        <p>
          Second of the minute from the post’s <code>date</code> front matter. (00..59)
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>title</code></p>
      </td>
      <td>
        <p>
            Title from the document’s filename. May be overridden via
            the document’s <code>slug</code> YAML front matter.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>slug</code></p>
      </td>
      <td>
        <p>
            Slugified title from the document’s filename ( any character
            except numbers and letters is replaced as hyphen ). May be
            overridden via the document’s <code>slug</code> YAML front matter.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>categories</code></p>
      </td>
      <td>
        <p>
          The specified categories for this Post. If a post has multiple
          categories, Jekyll will create a hierarchy (e.g. <code>/category1/category2</code>).
          Also Jekyll automatically parses out double slashes in the URLs,
          so if no categories are present, it will ignore this.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Built-in permalink styles

While you can specify a custom permalink style using [template variables](#template-variables),
Jekyll also provides the following built-in styles for convenience.

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Permalink Style</th>
      <th>URL Template</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>date</code></p>
      </td>
      <td>
        <p><code>/:categories/:year/:month/:day/:title.html</code></p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>pretty</code></p>
      </td>
      <td>
        <p><code>/:categories/:year/:month/:day/:title/</code></p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>ordinal</code></p>
      </td>
      <td>
        <p><code>/:categories/:year/:y_day/:title.html</code></p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>none</code></p>
      </td>
      <td>
        <p><code>/:categories/:title.html</code></p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Pages and collections

The `permalink` configuration setting specifies the permalink style used for
posts. Pages and collections each have their own default permalink style; the
default style for pages is `/:path/:basename` and the default for collections is
`/:collection/:path`.

These styles are modified to match the suffix style specified in the post
permalink setting. For example, a permalink style of `pretty`, which contains a
trailing slash, will update page permalinks to also contain a trailing slash:
`/:path/:basename/`. A permalink style of `date`, which contains a trailing
file extension, will update page permalinks to also contain a file extension:
`/:path/:basename:output_ext`. The same is true for any custom permalink style.

The permalink for an individual page or collection document can always be
overridden in the [YAML Front Matter](../frontmatter/) for the page or document.
Additionally, permalinks for a given collection can be customized [in the
collections configuration](../collections/).

## Permalink style examples

Given a post named: `/2009-04-29-slap-chop.md`

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>URL Template</th>
      <th>Resulting Permalink URL</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p>None specified, or <code>permalink: date</code></p>
      </td>
      <td>
        <p><code>/2009/04/29/slap-chop.html</code></p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>pretty</code></p>
      </td>
      <td>
        <p><code>/2009/04/29/slap-chop/</code></p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>/:month-:day-:year/:title.html</code></p>
      </td>
      <td>
        <p><code>/04-29-2009/slap-chop.html</code></p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>/blog/:year/:month/:day/:title/</code></p>
      </td>
      <td>
        <p><code>/blog/2009/04/29/slap-chop/</code></p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>/:year/:month/:title</code></p>
        <p>See <a href="#extensionless-permalinks">extensionless permalinks</a> for details.</p>
      </td>
      <td>
        <p><code>/2009/04/slap-chop</code></p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Extensionless permalinks

Jekyll supports permalinks that contain neither a trailing slash nor a file
extension, but this requires additional support from the web server to properly
serve. When using extensionless permalinks, output files written to disk will
still have the proper file extension (typically `.html`), so the web server
must be able to map requests without file extensions to these files.

Both [GitHub Pages](../github-pages/) and the Jekyll's built-in WEBrick server
handle these requests properly without any additional work.

### Apache

The Apache web server has very extensive support for content negotiation and can
handle extensionless URLs by setting the [multiviews][] option in your
`httpd.conf` or `.htaccess` file:

[multiviews]: https://httpd.apache.org/docs/current/content-negotiation.html#multiviews

{% highlight apache %}
Options +MultiViews
{% endhighlight %}

### Nginx

The [try_files][] directive allows you to specify a list of files to search for
to process a request. The following configuration will instruct nginx to search
for a file with an `.html` extension if an exact match for the requested URI is
not found.

[try_files]: http://nginx.org/en/docs/http/ngx_http_core_module.html#try_files

{% highlight nginx %}
try_files $uri $uri.html $uri/ =404;
{% endhighlight %}
