---
title: Data Files
permalink: /docs/datafiles/
---

In addition to the [built-in variables]({{'/docs/variables/' | relative_url }}) available from Jekyll,
you can specify your own custom data that can be accessed via the [Liquid
templating system](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers).

Jekyll supports loading data from [YAML](https://yaml.org), [JSON](https://www.json.org/json-en.html), [CSV](https://en.wikipedia.org/wiki/Comma-separated_values), and [TSV](https://en.wikipedia.org/wiki/Tab-separated_values) files located in the `_data` directory.
Note that CSV and TSV files *must* contain a header row.

This powerful feature allows you to avoid repetition in your templates and to
set site specific options without changing `_config.yml`.

Plugins/themes can also leverage Data Files to set configuration variables.

## The Data Folder

The `_data` folder is where you can store additional data for Jekyll to use when
generating your site. These files must be YAML, JSON, TSV or CSV files (using either
the `.yml`, `.yaml`, `.json`, `.tsv`, or `.csv` extension), and they will be
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

```
name,github
Eric Mill,konklone
Parker Moore,parkr
Liu Fengyun,liufengyun
```

This data can be accessed via `site.data.members` (notice that the file's *basename* determines the variable name and
therefore one should avoid having data files with the same basename but different extensions, in the same directory).

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

## Subfolders

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

The author can then be specified as a page variable in a post's front matter:

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

For information on how to build robust navigation for your site (especially if you have a documentation website or another type of Jekyll site with a lot of pages to organize), see [Navigation]({{ '/tutorials/navigation/' | relative_url }}).

## CSV/TSV Parse Options

The way Ruby parses CSV and TSV files can be customized with the `csv_reader` and `tsv_reader`
configuration options. Each configuration key exposes the same options:

`converters`: What [CSV converters](https://ruby-doc.org/stdlib-2.5.0/libdoc/csv/rdoc/CSV.html#Converters) should be
              used when parsing the file. Available options are `integer`, `float`, `numeric`, `date`, `date_time` and
              `all`. By default, this list is empty.
`encoding`:   What encoding the files are in. Defaults to the site `encoding` configuration option.
`headers`:    Boolean field for whether to parse the first line of the file as headers. When `false`, it treats the
              first row as data. Defaults to `true`.

Examples:

```yaml
csv_reader:
    converters:
      - numeric
      - datetime
    headers: true
    encoding: utf-8
tsv_reader:
    converters:
      - all
    headers: false
```
