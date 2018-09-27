---
layout: step
title: Layouts
position: 4
---
Websites typically have more than one page and this website is no different.

Jekyll supports [Markdown](https://daringfireball.net/projects/markdown/syntax)
as well as HTML for pages. Markdown is a great choice for pages with a simple
content structure (just paragraphs, headings and images), as it's less verbose
than raw HTML. Let's try it out on the next page.

Create `about.md` in the root.

For the structure you could copy `index.html` and modify it for the about page.
The problem with doing this is duplicate code. Let's say you wanted to add a
stylesheet to your site, you would have to go to each page and add it to the
`<head>`. It might not sound so bad for a two page site, imagine doing it
for 100 pages. Even simple changes will take a long time to make.

## Creating a layout

Using a layout is a much better choice. Layouts are templates that wrap around
your content. They live in a directory called `_layouts`.

Create your first layout at `_layouts/default.html` with the following content:

{% raw %}
```liquid
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>{{ page.title }}</title>
  </head>
  <body>
    {{ content }}
  </body>
</html>
```
{% endraw %}

You'll notice this is almost identical to `index.html` except there's
no front matter and the content of the page is replaced with a `content`
variable. `content` is a special variable which has the value of the rendered
content of the page its called on.

To have `index.html` use this layout, you can set a `layout` variable in front
matter. The layout wraps around the content of the page so all you need in
`index.html` is:

{% raw %}
```html
---
layout: default
title: Home
---
<h1>{{ "Hello World!" | downcase }}</h1>
```
{% endraw %}

After doing this, the output will be exactly the same as before. Note that you
can access the `page` front matter from the layout. In this case `title` is
set in the index page's front matter but is output in the layout.

## About page

Back to the about page, instead of copying from `index.html`, you can use the
layout.

Add the following to `about.md`:

{% raw %}
```html
---
layout: default
title: About
---
# About page

This page tells you a little bit about me.
```
{% endraw %}

Open <a href="http://localhost:4000/about.html" target="_blank" data-proofer-ignore>http://localhost:4000/about.html</a>
in your browser and view your new page.

Congratulations, you now have a two page website! But how do you
navigate from one page to another? Keep reading to find out.
