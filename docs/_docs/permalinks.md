---
title: Permalinks
permalink: /docs/permalinks/
---

Permalinks are the output path for your pages, posts, or collections. They
allow you to structure the directories of your source code different from the
directories in your output.

## Front Matter

The simplest way to set a permalink is using front matter. You set the
`permalink` variable in front matter to the output path you'd like.

For example, you might have a page on your site located at
`/my_pages/about-me.html` and you want the output url to be `/about/`. In
front matter of the page you would set:

```
---
permalink: /about/
---
```

## Global

Setting a permalink in front matter for every page on your site is no fun.
Luckily, Jekyll lets you set the permalink structure globally in your `_config.yml`.

To set a global permalink, you use the `permalink` variable in `_config.yml`.
You can use placeholders to your desired output. For example:

```yaml
permalink: /:categories/:year/:month/:day/:title:output_ext
```

Note that pages and collections (excluding `posts` and `drafts`) don't have time
and categories (for pages, the above `:title` is equivalent to `:basename`), these
aspects of the permalink style are ignored for the output.

For example, a permalink style of
`/:categories/:year/:month/:day/:title:output_ext` for the `posts` collection becomes
`/:title.html` for pages and collections (excluding `posts` and `drafts`).

### Placeholders

Here's the full list of placeholders available:


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
          Year from the post’s filename with four digits.
          May be overridden via the document’s <code>date</code> front matter.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>short_year</code></p>
      </td>
      <td>
        <p>
          Year from the post’s filename without the century. (00..99)
          May be overridden via the document’s <code>date</code> front matter.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>month</code></p>
      </td>
      <td>
        <p>
          Month from the post’s filename. (01..12)
          May be overridden via the document’s <code>date</code> front matter.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>i_month</code></p>
      </td>
      <td>
        <p>
          Month without leading zeros from the post’s filename. May be
          overridden via the document’s <code>date</code> front matter.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>short_month</code></p>
      </td>
      <td>
        <p>Three-letter month abbreviation, e.g. “Jan”.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>long_month</code></p>
        <small>{% include docs_version_badge.html version="4.0" %}</small>
      </td>
      <td>
        <p>Full month name, e.g. “January”.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>day</code></p>
      </td>
      <td>
        <p>
          Day of the month from the post’s filename. (01..31)
          May be overridden via the document’s <code>date</code> front matter.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>i_day</code></p>
      </td>
      <td>
        <p>
          Day of the month without leading zeros from the post’s filename.
          May be overridden via the document’s <code>date</code> front matter.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>y_day</code></p>
      </td>
      <td>
        <p>Ordinal day of the year from the post’s filename, with leading zeros. (001..366)</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>w_year</code></p>
        <small>{% include docs_version_badge.html version="4.0" %}</small>
      </td>
      <td>
        <p>Week year which may differ from the month year for up to three days at the start of January and end of December</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>week</code></p>
        <small>{% include docs_version_badge.html version="4.0" %}</small>
      </td>
      <td>
        <p>Week number of the current year, starting with the first week having a majority of its days in January. (01..53)</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>w_day</code></p>
        <small>{% include docs_version_badge.html version="4.0" %}</small>
      </td>
      <td>
        <p>Day of the week, starting with Monday. (1..7)</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>short_day</code></p>
        <small>{% include docs_version_badge.html version="4.0" %}</small>
      </td>
      <td>
        <p>Three-letter weekday abbreviation, e.g. “Sun”.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>long_day</code></p>
        <small>{% include docs_version_badge.html version="4.0" %}</small>
      </td>
      <td>
        <p>Weekday name, e.g. “Sunday”.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>hour</code></p>
      </td>
      <td>
        <p>
          Hour of the day, 24-hour clock, zero-padded from the post’s
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
            the document’s <code>slug</code> front matter.
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
            overridden via the document’s <code>slug</code> front matter.
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

### Built-in formats

For posts, Jekyll also provides the following built-in styles for convenience:

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
        <p><code>/:categories/:year/:month/:day/:title:output_ext</code></p>
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
        <p><code>/:categories/:year/:y_day/:title:output_ext</code></p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>weekdate</code></p>
        <small>{% include docs_version_badge.html version="4.0" %}</small>
      </td>
      <td>
        <p><code>/:categories/:year/W:week/:short_day/:title:output_ext</code></p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>none</code></p>
      </td>
      <td>
        <p><code>/:categories/:title:output_ext</code></p>
      </td>
    </tr>
  </tbody>
</table>
</div>

Rather than typing `permalink: /:categories/:year/:month/:day/:title/`, you can just type `permalink: pretty`.

<div class="note info">
<h5>Specifying permalinks through the front matter</h5>
<p>Built-in permalink styles are not recognized in front matter. As a result, <code>permalink: pretty</code> will not work.</p>
</div>

### Collections

For collections (including `posts` and `drafts`), you have the option to override
the global permalink in the collection configuration in `_config.yml`:

```yaml
collections:
  my_collection:
    output: true
    permalink: /:collection/:name
```

Collections have the following placeholders available:

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
        <p><code>:collection</code></p>
      </td>
      <td>
        <p>Label of the containing collection.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:path</code></p>
      </td>
      <td>
        <p>
          Path to the document relative to the collection's directory,
          including base filename of the document.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:name</code></p>
      </td>
      <td>
        <p>The document's base filename, with every sequence of spaces
        and non-alphanumeric characters replaced by a hyphen.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:title</code></p>
      </td>
      <td>
        <p>
          The <code>:title</code> template variable will take the
          <code>slug</code> <a href="/docs/front-matter/">front matter</a>
          variable value if any is present in the document; if none is
          defined then <code>:title</code> will be equivalent to
          <code>:name</code>, aka the slug generated from the filename.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:output_ext</code></p>
      </td>
      <td>
        <p>Extension of the output file. (Included by default and usually unnecessary.)</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

### Pages

For pages, you have to use front matter to override the global permalink,
and if you set a permalink via front matter defaults in `_config.yml`,
it will be ignored.

Pages have the following placeholders available:

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
        <p><code>:path</code></p>
      </td>
      <td>
        <p>
          Path to the page relative to the site's source directory, excluding
          base filename of the page.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:basename</code></p>
      </td>
      <td>
        <p>The page's base filename</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:output_ext</code></p>
      </td>
      <td>
        <p>
          Extension of the output file. (Included by default and usually
          unnecessary.)
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>
