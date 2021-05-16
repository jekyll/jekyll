---
layout: step
title: Layouts
position: 4
---
Jekyll supports [Markdown](https://daringfireball.net/projects/markdown/syntax)
in addition to HTML when building pages. Markdown is a great choice for pages with a simple
content structure (just paragraphs, headings and images), as it's less verbose
than raw HTML. 

Create a new Markdown file named `about.md` in your site's root folder. 

You could copy the contents of `index` and modify it for the About page. However,
this creates duplicate code that has to be customized for each new page you add
to your site. 

For example, adding a new stylesheet to your site would involve adding the link
to the stylesheet to the `<head>` of each page. For sites with many pages, this
is a waste of time.

## Creating a layout

Layouts are templates that can be used by any page in your site and wrap around page content.
They are stored in a directory called `_layouts`.

Create the `_layouts` directory in your site's root folder and create a new `default.html` file with the following content:

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

This HTML is almost identical to `index.html` except there's
no front matter and the content of the page is replaced by a `content`
variable. 

`content` is a special variable that returns the rendered
content of the page on which it's called.

## Use layouts

To make `index.html` use your new layout, set the `layout` variable in the front
matter. The file should look like this:

{% raw %}
```liquid
---
layout: default
title: Home
---
<h1>{{ "Hello World!" | downcase }}</h1>
```
{% endraw %}

When you reload the site, the output remains the same.

Since the layout wraps around the content on the page, you can call front matter like `page` 
in the layout file. When you apply the layout to a page, it uses the front matter on that page.

## Build the About page

Add the following to `about.md` to use your new layout in the About page:

```markdown
---
layout: default
title: About
---
# About page

This page tells you a little bit about me.
```

Open <a href="http://localhost:4000/about.html" target="_blank" data-proofer-ignore>http://localhost:4000/about.html</a>
in your browser and view your new page.

Congratulations, you now have a two page website!

Next, you'll learn about navigating from page to page in your site. 