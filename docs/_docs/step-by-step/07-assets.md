---
layout: step
title: 7. Assets
---
Using CSS, JS, images and other assets is straight forward with Jekyll. Simply
place them in your site folder and they'll be copied across to the built site.
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

You could us a standard CSS file for styling, we're going to take it a step
further by using [Sass](https://sass-lang.com/). Sass is a fantastic extension
to CSS built right into Jekyll.

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
directory (`_sass/` by default). At this stage you'll add a single
file, for a larger project this is a great way to keep your CSS organized.

Create `_sass/main.scss` with the following content:

```sass
.current
  color: green
```

Finally you'll need to reference the stylesheet in your layout. Open
`_layouts/default.html` and add the stylesheet to the `<head>`:

{% raw %}
```liquid
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>{{ page.title }}</title>
    <link rel="stylesheet" href="/assets/styles.css">
  </head>
  <body>
    {% include navigation.html %}
    {{ content }}
  </body>
</html>
```
{% endraw %}

Load up `http://localhost:4000/` and check the active link in the navigation is
colored green now. Next we're looking at one of Jekyll's most popular features,
blogging!
