---
layout: step
title: Liquid
position: 2
---
Liquid is where Jekyll starts to get more interesting. Liquid is a templating
language which has three main parts: [objects](#objects), [tags](#tags) and
[filters](#filters).


## Objects

Objects tell Liquid where to output content. They're denoted by double curly
braces: {% raw %}`{{`{% endraw %} and {% raw %}`}}`{% endraw %}. For example:

{% raw %}
```liquid
{{ page.title }}
```  
{% endraw %}

Outputs a variable called `page.title` on the page.

## Tags

Tags create the logic and control flow for templates. They are denoted by curly
braces and percent signs: {% raw %}`{%`{% endraw %} and
{% raw %}`%}`{% endraw %}. For example:

{% raw %}
```liquid
{% if page.show_sidebar %}
  <div class="sidebar">
    sidebar content
  </div>
{% endif %}
```  
{% endraw %}

Outputs the sidebar if `page.show_sidebar` is true. You can learn more about the
tags available to Jekyll [here](/docs/liquid/tags/).

## Filters

Filters change the output of a Liquid object. They are used within an output
and are separated by a `|`. For example:

{% raw %}
```liquid
{{ "hi" | capitalize }}
```  
{% endraw %}

Outputs `Hi`. You can learn more about the filters available to Jekyll
[here](/docs/liquid/filters/).

## Use Liquid

Now it's your turn, change the Hello World! on your page to output as lowercase:

{% raw %}
```liquid
...
<h1>{{ "Hello World!" | downcase }}</h1>
...
```  
{% endraw %}

It may not seem like it now, but much of Jekyll's power comes from combining
Liquid with other features. 

In order to see the changes from `downcase` Liquid filter, we will need to add front matter. 

That's next. Let's keep going.
