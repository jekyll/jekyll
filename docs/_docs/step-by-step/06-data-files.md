---
layout: step
title: 6. Data Files
---
Jekyll supports loading data from YAML, JSON, and CSV files located a `_data`
directory. Data files are a great way to separate content from source code to
make it easier to maintain.

In this tutorial you'll store the contents for the navigation in a data file
and then iterate over it in the include.

## Data file usage

[YAML](http://yaml.org/) is a format that's common in the Ruby ecosystem. You'll
use it to store an array of navigation items each with a name and link.

Create a data file for the navigation at `_data/navigation.yml` with the
following contents:

```yaml
- name: Home
  link: /
- name: About
  link: /about.html
```

Jekyll makes this data file available to you at `site.data.navigation`. Instead
of outputting each link in `_includes/navigation.html`, now you can iterate over
the data file instead:

```liquid
<nav>
  {% for item in site.data.navigation %}
    <a href="{{ item.link }}" {% if page.url == item.link %}style="color: red;"{% endif %}>{{ item.name }}</a>
  {% endfor %}
</nav>
```

The output should be exactly the same however now you've made it significantly
easier to add new items to the navigation and change the HTML structure.

What good is a site without CSS, JS and images> Let's look at how these are
handled in Jekyll.
