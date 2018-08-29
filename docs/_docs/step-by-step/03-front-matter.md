---
layout: step
title: Front Matter
position: 3
---
Front matter is a snippet of [YAML](http://yaml.org/) which sits between two
triple-dashed lines at the top of a file. Front matter is used to set variables
for the page, for example:

```liquid
---
my_number: 5
---
```

Front matter variables are available in Liquid under the `page` variable. For
example to output the variable above you would use:

{% raw %}
```liquid
{{ page.my_number }}
```
{% endraw %}

## Use front matter

Let's change the `<title>` on your site to populate using front matter:

{% raw %}
```html
---
title: Home
---
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>{{ page.title }}</title>
  </head>
  <body>
    <h1>{{ "Hello World!" | downcase }}</h1>
  </body>
</html>
```
{% endraw %}

You may still be wondering why you'd output it this way as it takes
more source code than raw HTML. In this next step, you'll see why we've
been doing this.
