---
title: Tabulate CSV Data
author: MichaelCurrin
date: 2020-04-01 20:30:00 +0200
---

This tutorial shows how to use Jekyll to read a CSV and render the data as an HTML table.

This approach will:

- use the CSV's first row as the HTML table header.
- use remaining rows for the body of the table.
- preserve the order of the columns from the original CSV.
- be flexible enough to work with _any_ valid CSV that is referenced.

There is no need to specify what the names of the columns are, or how many columns there are.
The trick to this tutorial is that, when we iterate over the row data, we pick up the _first row_
and unpack that so we can get the header names.

Follow the steps below to convert a sample CSV of authors into an HTML table.


## 1. Create a CSV

Create a CSV file in your [Data files]({{ '/docs/datafiles/' | relative_url }}) directory so
that Jekyll will pick it up. A sample path and CSV data are shown below:

`_data/authors.csv`

```
First name,Last name,Age,Location
John,Doe,35,United States
Jane,Doe,29,France
Jack,Hill,25,Australia
```

That data file will now be available in Jekyll like this:

{% raw %}
```liquid
{{ site.data.authors }}
```
{% endraw %}


## 2. Add a table

Choose an HTML or markdown file where you want your table to be shown.

For example: `table_test.md`

```yaml
---
title: Table test
---
```

### Inspect a row

Grab the first row and see what it looks like using the `inspect` filter.

{% raw %}
```liquid
{% assign row = site.data.authors[0] %}
{{ row | inspect }}
```
{% endraw %}


The result will be a _hash_ (an object consisting of key-value pairs) which looks like this:

```ruby
{
  "First name"=>"John",
  "Last name"=>"Doe",
  "Age"=>"35",
  "Location"=>"United States"
}
```

Note that Jekyll _does_ in fact preserve the order here, based on the original CSV.


### Unpack a row

A simple solution would be to hardcode the field names when looking up the row values by key.

{% raw %}
```liquid
{{ row["First name"] }}
{{ row["Last name"] }}
```
{% endraw %}

But we prefer a solution that will work for _any_ CSV, without specifying the column names upfront.
So we iterate over the `row` object using a `for` loop:

{% raw %}
```liquid
{% assign row = site.data.authors[0] %}
{% for pair in row %}
  {{ pair | inspect }}
{% endfor %}
```
{% endraw %}

This produces the following. Note the first item in each pair is the _key_ and the second will be
the _value_.

```
["First name", "John"]
["Last name", "Doe"]
["Age", "35"]
["Location", "United States"]
```

### Create a table header row

Here we make a table with a single table row (`tr`), made up of table header (`th`) tags. We find
the header name by getting the first element (at index `0`) from `pair`. We ignore the second
element as we don't need the value yet.

{% raw %}
```liquid
<table>
  {% for row in site.data.authors %}
    {% if forloop.first %}
    <tr>
      {% for pair in row %}
        <th>{{ pair[0] }}</th>
      {% endfor %}
    </tr>
    {% endif %}
  {% endfor %}
</table>
{% endraw %}
```

For now, we do not display any content from the second row onwards. We achieve this by using
`forloop.first`, since this will return true for the _first_ row and false otherwise.


### Add table data rows

In this section we add the data rows to the table. Now, we use the second element of `pair`
to find the value.

For convenience, we render using the `tablerow` tag - this works like a `for` loop, but the inner
data will be rendered with `tr` and `td` HTML tags for us. Unfortunately, there is no equivalent for
the header row, so we must write that out in full, as in the previous section.

{% raw %}
```liquid
---
title: Table test
---

<table>
  {% for row in site.data.authors %}
    {% if forloop.first %}
    <tr>
      {% for pair in row %}
        <th>{{ pair[0] }}</th>
      {% endfor %}
    </tr>
    {% endif %}

    {% tablerow pair in row %}
      {{ pair[1] }}
    {% endtablerow %}
  {% endfor %}
</table>
```
{% endraw %}


With the code above, the complete table would look like this:

<table>
  <tr>
    <th>First name</th>
    <th>Last name</th>
    <th>Age</th>
    <th>Location</th>
  </tr>
  <tr>
    <td>John</td>
    <td>Doe</td>
    <td>35</td>
    <td>United States</td>
  </tr>
  <tr>
    <td>Jane</td>
    <td>Doe</td>
    <td>29</td>
    <td>France</td>
  </tr>
  <tr>
    <td>Jack</td>
    <td>Hill</td>
    <td>25</td>
    <td>Australia</td>
  </tr>
</table>

That's it - you can now turn a CSV into an HTML table using Jekyll.

## Next steps

- Change the field names in the CSV.
- Choose a different CSV.
- Add CSS styling to your table.
- Render the table using a JSON or YAML input file.
