---
layout: step
title: Includes
position: 5
---
The site is coming together; however, there's no way to navigate between
pages. Let's fix that.

Navigation should be on every page so adding it to your layout is the correct
place to do this. Instead of adding it directly to the layout, let's use this
as an opportunity to learn about includes.

## Include tag

The `include` tag allows you to include content from another file stored
in an `_includes` folder. Includes are useful for having a single source for
source code that repeats around the site or for improving the readability.

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

Try using the include tag to add the navigation to `_layouts/default.html`:

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

Open <a href="http://localhost:4000" target="_blank" data-proofer-ignore>http://localhost:4000</a>
in your browser and try switching between the pages.

## Current page highlighting

Let's take this a step further and highlight the current page in the navigation.

`_includes/navigation.html` needs to know the URL of the page it's inserted into
so it can add styling. Jekyll has useful [variables](/docs/variables/) available
one of which is `page.url`.

Using `page.url` you can check if each link is the current page and color it red
if true:

{% raw %}
```liquid
<nav>
  <a href="/" {% if page.url == "/" %}style="color: red;"{% endif %}>
    Home
  </a>
  <a href="/about.html" {% if page.url == "/about.html" %}style="color: red;"{% endif %}>
    About
  </a>
</nav>
```
{% endraw %}

Take a look at <a href="http://localhost:4000" target="_blank" data-proofer-ignore>http://localhost:4000</a>
and see your red link for the current page.

There's still a lot of repetition here if you wanted to add a new item to the
navigation or change the highlight color. In the next step we'll address this.
