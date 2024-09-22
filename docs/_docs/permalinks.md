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

```yaml
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
    {%- for entry in site.data.permalinks.placeholders %}
    <tr>
      <td><p><code>:{{ entry.name }}</code></p>
        {%- if entry.intro_ver -%}
          <small>{% include docs_version_badge.html version = entry.intro_ver %}</small>
        {%- endif -%}
      </td>
      <td><p>{{ entry.desc }}</p></td>
    </tr>
    {%- endfor %}
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
    {%- for entry in site.data.permalinks.builtin_formats %}
    <tr>
      <td><p><code>{{ entry.name }}</code></p>
        {%- if entry.intro_ver -%}
          <small>{% include docs_version_badge.html version = entry.intro_ver %}</small>
        {%- endif -%}
      </td>
      <td>
        <p><code>{{ entry.format }}</code>
        {%- if entry.note -%}<br/>
          <small>({{ entry.note }})</small>
        {%- endif -%}
        </p>
      </td>
    </tr>
    {%- endfor %}
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
    {%- for entry in site.data.permalinks.types.documents -%}
    <tr>
      <td><p><code>:{{ entry.name }}</code></p></td>
      <td><p>{{ entry.desc }}</p></td>
    </tr>
    {%- endfor -%}
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
    {%- for entry in site.data.permalinks.types.pages -%}
    <tr>
      <td><p><code>:{{ entry.name }}</code></p></td>
      <td><p>{{ entry.desc }}</p></td>
    </tr>
    {%- endfor -%}
  </tbody>
</table>
</div>
