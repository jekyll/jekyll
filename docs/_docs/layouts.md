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

## Usage

The first step is to put the template source code in `default.html`. `content`
is a special variable, the value is the rendered content of the post or page
being wrapped.



{% raw %}
```
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

```
---
title: My First Page
layout: default
---

This is the content of my page
```

The rendered output of this page is:

```
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
```
---
layout: default
---
<p>{{ page.date }} - Written by {{ page.author }}</p>

{{ content }}
```
{% endraw %}

Now posts can use this layout while the rest of the pages use the default.

## Variables

You can set front matter in layouts, the only difference is when you're
using in Liquid, you need to use the `layout` variable instead of `page`. For
example:

{% raw %}
```
---
city: San Francisco
---
<p>{{ layout.city }}</p>

{{ content }}
```
{% endraw %}
