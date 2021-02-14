---
layout: step
title: Front Matter
position: 3
---
Front matter is a snippet of [YAML](http://yaml.org/) placed between two
triple-dashed lines at the start of a file.

You can use front matter to set variables for the page:

```yaml
---
my_number: 5
---
```

You can call front matter variables in Liquid using the `page` variable. For
example, to output the value of the `my_number` variable above:

{% raw %}
```liquid
{{ page.my_number }}
```
{% endraw %}

## Use front matter

Change the `<title>` on your site to use front matter:

{% raw %}
```liquid
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

{: .note .info }
You _must_ include front matter on the page for Jekyll to process any Liquid tags on it. 

To make Jekyll process a page without defining variables in the front matter, use:

```yaml
---
---
```

Next, you'll learn more about layouts and why your pages use more source code than plain HTML.