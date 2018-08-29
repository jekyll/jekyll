---
layout: step
title: 5. Includes
---
The site is coming along nicely however, there's no way to navigate between
pages. Let's fix that.

The navigation should be on each page so adding it to your layout is the right
place to do this. Instead of adding it directly to the layout, let's use this
as an opportunity to learn about includes.

## Include tag

The `include` tag allows you to include content from another file stored
an `_includes` folder. Includes are useful for having a single source for
snippets of source code that repeat around the site or for improving the
readability of the site.

Navigation source code can get complex so sometimes it's nice to move it into an
include.  

## Include usage

Create a file for the navigation at `_includes/navigation.html` with the
following content:

```liquid
<nav>
  <a href="/">Home</a>
  <a href="/about.html">About</a>
</nav>
```

You can use the include tag to insert the navigation into the layout:

{% raw %}
```liquid
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>{{ page.title }}</title>
  </head>
  <body>
    {% include navigation.html %}
    {{ content }}
  </body>
</html>
```
{% endraw %}

Open `http://localhost:4000/` in your browser and try switching between the
pages.

## Current page highlighting

Let's take this a step further and highlight the current page in the navigation.

`_includes/navigation.html` needs to know the URL of the page it's inserted into
so it can add styling. Jekyll has useful [variables](/docs/variables/) available
one of which is `page.url`.

Using `page.url` you can check if each link is the current page and color it red
if true:

```liquid
<nav>
  <a href="/" {% if page.url == "/" %}style="color: red;"{% endif %}>Home</a>
  <a href="/about.html" {% if page.url == "/about.html" %}style="color: red;"{% endif %}>About</a>
</nav>
```

Take a look at `http://localhost:4000/` and see your red link for the current
page.

There's still a lot of repetition here if you wanted to add a new item to the
navigation or change the highlight color. Let's look at fixed that.
