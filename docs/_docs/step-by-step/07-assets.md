---
layout: step
title: Assets
position: 7
---
Using CSS, JS, images and other assets is straightforward with Jekyll. Place
them in your site folder and they’ll copy across to the built site.

Jekyll sites often use this structure to keep assets organized:

```sh
.
├── assets
|   ├── css
|   ├── images
|   └── js
...
```

## Sass

The inline styles used in `_includes/navigation.html` is not a best practice,
let's style the current page with a class instead.

{% raw %}
```liquid
<nav>
  {% for item in site.data.navigation %}
    <a href="{{ item.link }}" {% if page.url == item.link %}class="current"{% endif %}>{{ item.name }}</a>
  {% endfor %}
</nav>
```
{% endraw %}

You could use a standard CSS file for styling, we're going to take it a step
further by using [Sass](https://sass-lang.com/). Sass is a fantastic extension
to CSS baked right into Jekyll.

First create a Sass file at `/assets/css/styles.scss` with the following
content:

{% raw %}
```css
---
---
@import "main";
```
{% endraw %}

The empty front matter at the top tells Jekyll it needs to process the file. The
`@import "main"` tells Sass to look for a file called `main.scss` in the sass
directory (`_sass/` by default).

At this stage you'll just have a main css file. For larger projects, this is a
great way to keep your CSS organized.

Create `_sass/main.scss` with the following content:

```sass
.current {
  color: green;
}
```

You'll need to reference the stylesheet in your layout.

Open `_layouts/default.html` and add the stylesheet to the `<head>`:

{% raw %}
```liquid
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>{{ page.title }}</title>
    <link rel="stylesheet" href="/assets/css/styles.css">
  </head>
  <body>
    {% include navigation.html %}
    {{ content }}
  </body>
</html>
```
{% endraw %}

Load up <a href="http://localhost:4000" target="_blank" data-proofer-ignore>http://localhost:4000</a>
and check the active link in the navigation is green.

Next we're looking at one of Jekyll's most popular features, blogging.
