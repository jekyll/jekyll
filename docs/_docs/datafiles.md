---
title: Data Files
permalink: /docs/datafiles/
---

In addition to the [built-in variables](../variables/) available from Jekyll,
you can specify your own custom data that can be accessed via the [Liquid
templating system](https://wiki.github.com/shopify/liquid/liquid-for-designers).

Jekyll supports loading data from [YAML](http://yaml.org/), [JSON](http://www.json.org/),
and [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) files located in the `_data` directory.
Note that CSV files *must* contain a header row.

This powerful feature allows you to avoid repetition in your templates and to
set site specific options without changing `_config.yml`.

Plugins/themes can also leverage Data Files to set configuration variables.

## The Data Folder

As explained on the [directory structure](../structure/) page, the `_data`
folder is where you can store additional data for Jekyll to use when generating
your site. These files must be YAML, JSON, or CSV files (using either
the `.yml`, `.yaml`, `.json` or `.csv` extension), and they will be
accessible via `site.data`.

## Example: List of members

Here is a basic example of using Data Files to avoid copy-pasting large chunks
of code in your Jekyll templates:

In `_data/members.yml`:

```yaml
- name: Eric Mill
  github: konklone

- name: Parker Moore
  github: parkr

- name: Liu Fengyun
  github: liufengyun
```

Or `_data/members.csv`:

```text
name,github
Eric Mill,konklone
Parker Moore,parkr
Liu Fengyun,liufengyun
```

This data can be accessed via `site.data.members` (notice that the filename
determines the variable name).

You can now render the list of members in a template:

{% raw %}
```liquid
<ul>
{% for member in site.data.members %}
  <li>
    <a href="https://github.com/{{ member.github }}">
      {{ member.name }}
    </a>
  </li>
{% endfor %}
</ul>
```
{% endraw %}

{: .note .info }
If your Jekyll site has a lot of pages, such as with documentation websites, see the detailed examples in [how to build robust navigation for your site]({% link _tutorials/navigation.md %}).

## Example: Organizations

Data files can also be placed in sub-folders of the `_data` folder. Each folder
level will be added to a variable's namespace. The example below shows how
GitHub organizations could be defined separately in a file under the `orgs`
folder:

In `_data/orgs/jekyll.yml`:

```yaml
username: jekyll
name: Jekyll
members:
  - name: Tom Preston-Werner
    github: mojombo

  - name: Parker Moore
    github: parkr
```

In `_data/orgs/doeorg.yml`:

```yaml
username: doeorg
name: Doe Org
members:
  - name: John Doe
    github: jdoe
```

The organizations can then be accessed via `site.data.orgs`, followed by the
file name:

{% raw %}
```liquid
<ul>
{% for org_hash in site.data.orgs %}
{% assign org = org_hash[1] %}
  <li>
    <a href="https://github.com/{{ org.username }}">
      {{ org.name }}
    </a>
    ({{ org.members | size }} members)
  </li>
{% endfor %}
</ul>
```
{% endraw %}

## Example: Accessing a specific author

Pages and posts can also access a specific data item. The example below shows how to access a specific item:

`_data/people.yml`:

```yaml
dave:
    name: David Smith
    twitter: DavidSilvaSmith
```

The author can then be specified as a page variable in a post's frontmatter:

{% raw %}
```liquid
---
title: sample post
author: dave
---

{% assign author = site.data.people[page.author] %}
<a rel="author"
  href="https://twitter.com/{{ author.twitter }}"
  title="{{ author.name }}">
    {{ author.name }}
</a>
```
{% endraw %}

For information on how to build robust navigation for your site (especially if you have a documentation website or another type of Jekyll site with a lot of pages to organize), see [Navigation](/tutorials/navigation).
