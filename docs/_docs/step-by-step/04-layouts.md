---
layout: step
title: 4. Layout
---
Websites typically have more than one page and this website is no different.
Let's make this page a little different, instead of writing HTML you can also
use [Markdown](https://daringfireball.net/projects/markdown/syntax).
Create `about.md` in the root.

For the structure you could copy `index.html` and modify it for the about page.
The problem with doing this is duplicate code. Let's say you wanted to add a
stylesheet to your site, you would have to go to each page and add it. It
doesn't sound so bad for a two page site, imagine 100 pages though. That's going
to take a long time to make a simple change.

## Creating a layout

Using a layout is a much better choice. Layouts are templates that wrap around
your content. They live in a directory called `_layouts`. Create your first
layout at `_layouts/default.html` with the following content:

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
variable. `content` is a special variable with a value of the rendered content
of the page its called on.

Now to modify `index.html` to use this layout. You can set the layout you want
to use in front matter using the `layout` variable. The layout wraps around the
content of the page so all you need in `index.html` is:

{% raw %}
```html
---
layout: default
title: Home
---
<h1>Hello World!</h1>
```
{% endraw %}

And it will have the exact same output as before. Note that you can access the
page front matter from the layout. In this case `title` is set in the index
page's front matter but is output in the layout.

## About page

Back to the about page, instead of copying from `index.html` you can use the
layout. Add the following to `about.md`:

{% raw %}
```html
---
layout: default
title: About
---
# About page
```
{% endraw %}

Open `http://localhost:4000/about.html` in your browser and view your glorious
new page.

Congratulations, you now have a two page website! But how do you
navigate from one page to another? Keep reading to find out.
