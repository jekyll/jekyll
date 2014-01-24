---
layout: docs
title: Data Files
prev_section: variables
next_section: assets
permalink: /docs/datafiles/
---

In addition to the [built-in variables](../variables/) available from Jekyll,
you can specify your own custom data that can be accessed via the [Liquid
templating system](http://wiki.github.com/shopify/liquid/liquid-for-designers).

Jekyll supports loading data from [YAML](http://yaml.org/) files located in the
`_data` directory.

This powerful feature allows you to avoid repetition in your templates and to
set site specific options without changing `_config.yml`.

Plugins/themes can also leverage Data Files to set configuration variables.

## The Data Folder

As explained on the [directory structure](../structure/) page, the `_data`
folder is where you can store additional data for Jekyll to use when generating
your site. These files must be YAML files (using either the `.yml` or `.yaml`
extension) and they will be accessible via `site.data`.

## Example: List of members

Here is a basic example of using Data Files to avoid copy-pasting large chunks of
code in your Jekyll templates:

In `_data/members.yml`:

{% highlight yaml %}
- name: Tom Preston-Werner
  github: mojombo

- name: Parker Moore
  github: parkr

- name: Liu Fengyun
  github: liufengyun
{% endhighlight %}

This data can be accessed via `site.data.members` (notice that the filename
determines the variable name).

You can now render the list of members in a template:

{% highlight html %}
{% raw %}
<ul>
{% for member in site.data.members %}
  <li>
    <a href="https://github.com/{{ member.github }}">
      {{ member.name }}
    </a>
  </li>
{% endfor %}
</ul>
{% endraw %}
{% endhighlight %}
