---
title: Show CSV as a table
author: MichaelCurrin
date: 2020-04-01 20:30:00 +0200
---

This tutorial will show you how to read a CSV file and render it as an HTML table. The result will be true to the original header row and data rows.

The approach followed here is very flexible - the number of columns and the names of the columns are picked up **dynamically**. We can drop in any valid CSV data and see it rendered.

The trick in this tutorial is that when we iterate over the row data, we pick up the _first row_ and use that to create the labels for the HTML header row.

Follow the steps below to convert a sample CSV of authors into a table.


## 1. Create a CSV

Create a CSV file in the [Data files]({{ '/docs/datafiles/' | relative_url }}) directory so that Jekyll will pick it up. A sample path and CSV data are shown below:

`_data/authors.csv`

```
First name,Last name,Age,Location
John,Doe,35,United States
Jane,Doe,29,France
Jack,Hill,25,Australia
```

That data file will now be available in Jekyll like this:

{% raw %}
```
{{ site.data.authors }}
```
{% endraw %}


## 2. Add a table

Open an HTML or markdown file that you want to use. Then create an HTML table using the instructions below.

### Header row

Here is the code for a table which has a header and nothing else.

We grab the first row using an index of zero.

{% raw %}
```
{% assign row = site.data.authors[0] %}
```
{% endraw %}

We unpack that using a _for loop_ and a variable named `pair`. Each time, `pair` will be an array of _two_ values. Always with _key_ first at index `0` and the _value_ second at index `1`. Here we use just the _key_.

Also, we make use of `forloop.first` - this will be true only for the _first_ row and false otherwise, so display the header for the first row and nothing else.

{% raw %}
```
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
```
{% endraw %}


### Full table

In this section we add the data rows to the table.

For convenience We use the `tablerow` filter to render the `tr` and `td` HTML tags for us. But there is no equivalent for the header, so we must write that out in full.

{% raw %}
```
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


Our output table should look like this:


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

Save everything and start your server. That's it - you can now turn a CSV into an HTML table using Jekyll.

Next, try using a YAML file as your input, or add CSS styling to your table.

_Note: Each CSV row is turned into a hash and that object is typically **not** ordered in programming. However, the way Ruby and Jekyll handles the data means that the original order of the CSV columns is **preserved** when iterating over the CSV data. So the approach followed in this tutorial works well._
