---
title: Layouts
description: placeholder
permalink: /docs/layouts/
---
Layouts are templates that wrap around your content. They allow you to have the
source code for your template in one place so you don't have to repeat things
like your navigation and footer on every page.

Layouts live in the `_layouts` directory. The convention is to have a base
template called `default.html` and have other layouts [inherit](#inheritance)
from this as needed.

<div class="note">
  <h5>Layouts Directory</h5>
  <p>
    Jekyll looks for the <code>_layouts</code> directory either at the root of
    your site's <code>source</code> or at the root of your theme.
  </p>
  <p>
    While you can configure the directory name in which your layouts can reside by
    setting the <code>layouts_dir</code> key in your config file, the directory
    itself should be located at the root of your site's <code>source</code> directory.
  </p>
</div>

## Usage

The first step is to put the template source code in `default.html`. `content`
is a special variable, the value is the rendered content of the post or page
being wrapped.

{% raw %}
```liquid
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>{{ page.title }}</title>
    <link rel="stylesheet" href="/css/style.css">
  </head>
  <body>
    <nav>
      <a href="/">Home</a>
      <a href="/blog/">Blog</a>
    </nav>
    <h1>{{ page.title }}</h1>
    <section>
      {{ content }}
    </section>
    <footer>
      &copy; to me
    </footer>
  </body>
</html>
```
{% endraw %}

You have full access to the front matter of the origin. In the
example above, `page.title` comes from the page front matter.

Next you need to specify what layout you're using in your page's front matter.
You can also use
[front matter defaults](/docs/configuration/front-matter-defaults/) to save you
from having to set this on every page.

```markdown
---
title: My First Page
layout: default
---

This is the content of my page
```

The rendered output of this page is:

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>My First Page</title>
    <link rel="stylesheet" href="/css/style.css">
  </head>
  <body>
    <nav>
      <a href="/">Home</a>
      <a href="/blog/">Blog</a>
    </nav>
    <h1>My First Page</h1>
    <section>
      This is the content of my page
    </section>
    <footer>
      &copy; to me
    </footer>
  </body>
</html>
```

## Inheritance

Layout inheritance is useful when you want to add something to an existing
layout for a portion of documents on your site. A common example of this is
blog posts, you might want a post to display the date and author but otherwise
be identical to your base layout.

To achieve this you need to create another layout which specifies your original
layout in front matter. For example this layout will live at
`_layouts/post.html`:

{% raw %}
```liquid
---
layout: default
---
<p>{{ page.date }} - Written by {{ page.author }}</p>

{{ content }}
```
{% endraw %}

Now posts can use this layout while the rest of the pages use the default.

## Multiple output formats

To publish the same page, post, or output collection document in several formats,
create layouts with the same basename and different extensions. For example,
`_layouts/event.html` and `_layouts/event.json` both apply to a document with
`layout: event` in its front matter. Each layout receives the same converted
`content` and the document's front matter through `page`.

An HTML layout is preferred as the primary output (`.html`, then `.xhtml`, then
`.htm`). If none exists, the last layout in filename order is primary. An explicit
permalink extension selects the matching layout when available. The primary
output continues to determine `page.url` and the document's
`output` property. A layout with only one format keeps its existing behavior.

Additional files replace the extension of the primary destination. For example:

| Primary destination | Additional layout | Additional destination |
|---------------------|-------------------|------------------------|
| `events/launch.html` | `event.json`      | `events/launch.json`   |
| `events/launch/index.html` | `event.json` | `events/launch/index.json` |

The layout controls the output format; Jekyll does not automatically convert
HTML into JSON or other formats. For example, `event.json` could contain:

{% raw %}
```liquid
{
  "title": {{ page.title | jsonify }},
  "description": {{ content | strip_html | strip | jsonify }}
}
```
{% endraw %}

When a layout inherits another layout, Jekyll first looks for the parent with
the same extension and otherwise uses the parent's primary layout. Site layouts
override theme layouts of the same name and extension. Different extensions
from the theme remain available.

All formats take part in cleanup, incremental builds, and destination conflict
warnings. Document hooks still run once for the document, and `post_render`
hooks see the primary `output`. Plugins that need to modify additional rendered
formats can access the document's `layout_outputs` hash, keyed by extension.

## Variables

You can set front matter in layouts, the only difference is when you're
using in Liquid, you need to use the `layout` variable instead of `page`. For
example:

{% raw %}
```liquid
---
city: San Francisco
---
<p>{{ layout.city }}</p>

{{ content }}
```
{% endraw %}
