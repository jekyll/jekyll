---
title: Permalinks
permalink: /docs/permalinks/
---

Permalinks refer to the URLs (excluding the domain name or directory folder) for your pages, posts, or collections.
Jekyll supports a flexible way to build permalinks, allowing you to leverage various template variables or choose built-in permalink styles (such as `date`) that automatically use a template-variable pattern.

You construct permalinks by creating a template URL where dynamic elements are represented by colon-prefixed keywords. The default template permalink is `/:categories/:year/:month/:day/:title.html`. Each of the colon-prefixed keywords is a template variable.

## Where to configure permalinks

You can configure your site's permalinks through the [Configuration]({% link _docs/configuration.md %}) file or in the [Front Matter]({% link _docs/frontmatter.md %}) for each post, page, or collection.

Setting permalink styles in your configuration file applies the setting globally in your project. You configure permalinks in your `_config.yml` file like this:

```yaml
permalink: /:categories/:year/:month/:day/:title.html
```

If you don't specify any permalink setting, Jekyll uses the above pattern as the default.

The permalink can also be set using a built-in permalink style:

```yaml
permalink: date
```

`date` is the same as `:categories/:year/:month/:day/:title.html`, the default. See [Built-in Permalink Styles](#builtinpermalinkstyles) below for more options.

Setting the permalink in your post, page, or collection's front matter overrides any global settings. Here's an example:

```yaml
---
title: My page title
permalink: /mypageurl/
---
```

Even if your configuration file specifies the `date` style, the URL for this page would be `http://somedomain.com/mypageurl/`.

When you use permalinks that omit the `.html` file extension (called "pretty URLs") Jekyll builds the file as index.html placed inside a folder with the page's name. For example:

```
├── mypageurl
│   └── index.html
```

With a URL such as `/mypageurl/`, servers automatically load the index.html file inside the folder, so users can simply navigate to `http://somedomain.com/mypageurl/` to get to `mypageurl/index.html`.

## Template variables for permalinks {#template-variables}

The following table lists the template variables available for permalinks. You can use these variables in the `permalink` property in your config file.

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
        <p>
          Year from the post's filename. May be overridden via the document’s
          <code>date</code> YAML front matter
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>month</code></p>
      </td>
      <td>
        <p>
          Month from the post's filename. May be overridden via the document’s
          <code>date</code> YAML front matter
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>i_month</code></p>
      </td>
      <td>
        <p>
          Month without leading zeros from the post's filename. May be
          overridden via the document’s <code>date</code> YAML front matter
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>day</code></p>
      </td>
      <td>
        <p>
          Day from the post's filename. May be overridden via the document’s
          <code>date</code> YAML front matter
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>i_day</code></p>
      </td>
      <td>
        <p>
          Day without leading zeros from the post's filename. May be overridden
          via the document’s <code>date</code> YAML front matter
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>y_day</code></p>
      </td>_
      <td>
        <p>Day of the year from the post's filename, with leading zeros.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>short_year</code></p>
      </td>
      <td>
        <p>
          Year without the century from the post's filename. May be overridden
          via the document’s <code>date</code> YAML front matter
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>hour</code></p>
      </td>
      <td>
        <p>
          Hour of the day, 24-hour clock, zero-padded from the post's
          <code>date</code> front matter. (00..23)
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>minute</code></p>
      </td>
      <td>
        <p>
          Minute of the hour from the post's <code>date</code> front matter. (00..59)
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>second</code></p>
      </td>
      <td>
        <p>
          Second of the minute from the post's <code>date</code> front matter. (00..59)
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
            Slugified title from the document’s filename (any character
            except numbers and letters is replaced as hyphen). May be
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
          The specified categories for this post. If a post has multiple
          categories, Jekyll will create a hierarchy (e.g. <code>/category1/category2</code>).
          Also Jekyll automatically parses out double slashes in the URLs,
          so if no categories are present, it will ignore this.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

Note that all template variables relating to time or categories are available to posts only.

## Built-in permalink styles {#builtinpermalinkstyles}

Although you can specify a custom permalink pattern using [template variables](#template-variables), Jekyll also provides the following built-in styles for convenience.

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

Rather than typing `permalink: /:categories/:year/:month/:day/:title/`, you can just type `permalink: pretty`.

<div class="note info">
<h5>Specifying permalinks through the YAML Front Matter</h5>
<p>Built-in permalink styles are not recognized in YAML Front Matter. As a result, <code>permalink: pretty</code> will not work.</p>
</div>

## Permalink style examples with posts {#permalink-style-examples}

Here are a few examples to clarify how permalink styles get applied with posts.

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
        <p>See <a href="#extensionless-permalinks">Extensionless permalinks with no trailing slashes</a> for details.</p>
      </td>
      <td>
        <p><code>/2009/04/slap-chop</code></p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Permalink settings for pages and collections {#pages-and-collections}

The permalink setting in your configuration file specifies the permalink style used for posts, pages, and collections. However, because pages and collections don't have time or categories, these aspects of the permalink style are ignored with pages and collections.

For example:

* A permalink style of `/:categories/:year/:month/:day/:title.:output_ext` for posts becomes `/:title.html` for pages and collections.
* A permalink style of `pretty` (or `/:categories/:year/:month/:day/:title/`), which omits the file extension and contains a trailing slash, will update page and collection permalinks to also omit the file extension and contain a trailing slash: `/:title/`.
* A permalink style of `date`, which contains a trailing file extension, will update page permalinks to also contain a trailing file extension: `/:title.html`. But no time or category information will be included.

## Permalinks and default paths

The path to the post or page in the built site differs for posts, pages, and collections:

### Posts

The subfolders into which you may have organized your posts inside the `_posts` directory will not be part of the permalink.

If you use a permalink style that omits the `.html` file extension, each post is rendered as an `index.html` file inside a folder with the post's name (for example, `categoryname/2016/12/01/mypostname/index.html`).

### Pages

Unlike posts, pages by default mimic the source directory structure exactly. (The only exception is if your page has a `permalink` declared its front matter &mdash; in that case, the structure honors the permalink setting instead of the source folder structure.)

As with posts, if you use a permalink style that omits the `.html` file extension, each page is rendered as an `index.html` file inserted inside a folder with the page's name (for example, `mypage/index.html`).

### Collections

By default, collections follow a similar structure in the `_site` folder as pages, except that the path is prefaced by the collection name. For example: `collectionname/mypage.html`. For permalink settings that omit the file extension, the path would be `collection_name/mypage/index.html`.

Collections have their own way of setting permalinks. Additionally, collections have unique template variables available (such as `path` and `output_ext`). See the [Configuring permalinks for collections](../collections/#permalinks) in Collections for more information.

## Flattening pages in \_site on build

If you want to flatten your pages (pull them out of subfolders) in the `_site` directory when your site builds (similar to posts), add the `permalink` property to the front matter of each page, with no path specified:

```yaml
---
title: My page
permalink: mypageurl.html
---
```

## Extensionless permalinks with no trailing slashes {#extensionless-permalinks}

Jekyll supports permalinks that contain neither a trailing slash nor a file extension, but this requires additional support from the web server to properly serve. When using these types of permalinks, output files written to disk will still have the proper file extension (typically `.html`), so the web server must be able to map requests without file extensions to these files.

Both [GitHub Pages](../github-pages/) and the Jekyll's built-in WEBrick server handle these requests properly without any additional work.

### Apache

The Apache web server has extensive support for content negotiation and can handle extensionless URLs by setting the [multiviews](https://httpd.apache.org/docs/current/content-negotiation.html#multiviews) option in your `httpd.conf` or `.htaccess` file:

{% highlight apache %}
Options +MultiViews
{% endhighlight %}

### Nginx

The [try_files](http://nginx.org/en/docs/http/ngx_http_core_module.html#try_files) directive allows you to specify a list of files to search for to process a request. The following configuration will instruct nginx to search for a file with an `.html` extension if an exact match for the requested URI is not found.

{% highlight nginx %}
try_files $uri $uri.html $uri/ =404;
{% endhighlight %}

## Linking without regard to permalink styles

You can create links in your topics to other posts, pages, or collection items in a way that is valid no matter what permalink configuration you choose. By using the `link` tag, if you change your permalinks, your links won't break. See [Linking to pages](../templates#link) in Templates for more details.
