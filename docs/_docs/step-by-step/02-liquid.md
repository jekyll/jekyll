---
layout: step
title: Liquid
position: 2
---
Liquid is where Jekyll starts to get more interesting. It is a templating
language which has three main components: 
  * [objects](#objects)
  * [tags](#tags) 
  * [filters](#filters)

## Objects

Objects tell Liquid to output predefined [variables](../../variables/) as content on a page. Use double curly braces for objects: {% raw %}`{{`{% endraw %} and {% raw %}`}}`{% endraw %}. 

For example, {% raw %}`{{ page.title }}`{% endraw %} displays the `page.title` variable.

## Tags

Tags define the logic and control flow for templates. Use curly
braces and percent signs for tags: {% raw %}`{%`{% endraw %} and
{% raw %}`%}`{% endraw %}. 

For example:

{% raw %}
```liquid
{% if page.show_sidebar %}
  <div class="sidebar">
    sidebar content
  </div>
{% endif %}
```
{% endraw %}

This displays the sidebar if the value of the `show_sidebar` page variable is true. 

Learn more about the tags available in Jekyll [here](/docs/liquid/tags/).

## Filters

Filters change the output of a Liquid object. They are used within an output
and are separated by a `|`. 

For example:

{% raw %}
```liquid
{{ "hi" | capitalize }}
```
{% endraw %}

This displays `Hi` instead of `hi`. 

[Learn more about the filters](/docs/liquid/filters/) available.

## Use Liquid

Now, use Liquid to make your `Hello World!` text from [Setup](../01-setup/) lowercase:

{% raw %}
```liquid
...
<h1>{{ "Hello World!" | downcase }}</h1>
...
```
{% endraw %}

To make Jekyll process your changes, add [front matter](../03-front-matter/) to the top of the page:

```yaml
---
# front matter tells Jekyll to process Liquid
---
```

Your HTML document should look like this:

{% raw %}
```html
---
---

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Home</title>
  </head>
  <body>
    <h1>{{ "Hello World!" | downcase }}</h1>
  </body>
</html>
```
{% endraw %}

When you reload your browser, you should see `hello world!`. 

Much of Jekyll's power comes from combining Liquid with other features. Add frontmatter to pages to make Jekyll process the Liquid on those pages.

Next, you'll learn more about frontmatter.
