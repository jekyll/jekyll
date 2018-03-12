---
layout: tutorials
permalink: /tutorials/navigation/
title: Navigation
---

If your Jekyll site has a lot of pages, you might want to create navigation for the pages. Instead of hard-coding navigation links, you can programmatically retrieve a list of pages to build the navigation for your site.

Although there's already information about [interacting with data files]({% link _docs/datafiles.md %}) in other Jekyll docs, this tutorial dives into building more robust navigation for your site.

There are two primary ways of retrieving pages on a Jekyll site:

* **Retrieve pages listed in a YAML data source**. Store the page data in a YAML (or JSON or CSV) file in the `_data` folder, loop through the YAML properties, and insert the values into your theme.
* **Retrieve pages by looping through the page front matter**. Look through the front matter of your pages to identify certain properties, return those pages, and insert the pages' front matter values into your theme.

The examples that follow start with a basic navigation scenario and add more sophisticated elements to demonstrate different ways of returning the pages. In every scenario, you'll see 3 elements:

* YAML
* Liquid
* Result

The YAML file in the `_data` directory is called `samplelist.yml`.

The scenarios are as follows:

* TOC
{:toc}

## Scenario 1: Basic List

You want to return a basic list of pages.

**YAML**

```yaml
docs_list_title: ACME Documentation
docs:

- title: Introduction
  url: introduction.html

- title: Configuration
  url: configuration.html

- title: Deployment
  url: deployment.html
```

**Liquid**

```liquid
{% raw %}<h2>{{ site.data.samplelist.docs_list_title }}</h2>
<ul>
   {% for item in site.data.samplelist.docs %}
      <li><a href="{{ item.url }}" alt="{{ item.title }}">{{ item.title }}</a></li>
   {% endfor %}
</ul>{% endraw %}
```

**Result**
<div class="highlight result">
   <h2>ACME Documentation</h2>
   <ul>
      <li><a href="#" alt="Introduction">Introduction</a></li>
      <li><a href="#" alt="Configuration">Configuration</a></li>
      <li><a href="#" alt="Deployment">Deployment</a></li>
   </ul>
</div>

{: .note .info }
For the results in these fictitious samples, `#` is manually substituted for the actual link value to avoid 404 errors.)

When you use a `for` loop, you choose how you want to refer to the items you're looping through. The variable you choose (in this case, `item`) becomes how you access the properties of each item in the list. Dot notation is used to get a property of the item (for example, `item.url`).

The YAML content has two main types of formats that are relevant here:

* mapping
* list

`docs_list_title: ACME Documentation` is a mapping. You access the value with `site.data.samplelist.docs_list_title`.

`docs:` is a list. The list begins each item with a hyphen. Unlike with mappings, you usually don't access list properties directly as you do with mappings. If you want to access a specific item in the list, you must identify the position in the list you want, following typical array notation. For example, `site.data.samplelist.docs[0]` would access the first item in the list. However, this is rarely done.

With lists, you usually use `for` loops to cycle through the list of items and do something with each item. With navigation menus, you usually insert each list item into `li` tags based on the navigation structure you're using in your HTML theme.

Each hyphen (`-`) indicates another item in the list. This example just has two properties with each list item: `title` and `url`. You can include as many properties as you want for each item. The order of properties at each position in the list doesn't matter.

## Scenario 2: Sorted list

Suppose you wanted to sort the list by the `title`. To do this, convert the reference to the `docs` collection to a variable, and then apply Liquid's `sort` filter to the variable:

**Liquid**

{% raw %}
```liquid
{% assign doclist = site.data.samplelist.docs | sort: 'title'  %}
<ol>
{% for item in doclist %}
    <li><a href="{{ item.url }}" alt="{{ item.title }}">{{ item.title }}</a></li>
{% endfor %}
</ol>
```
{% endraw %}

**Result**

<div class="highlight result">
   <ol>
      <li><a href="#" alt="Configuration">Configuration</a></li>
      <li><a href="#" alt="Deployment">Deployment</a></li>
      <li><a href="#" alt="Introduction">Introduction</a></li>
   </ol>
</div>

The items now appear in alphabetical order. The `sort` property in the Liquid filter applies to the `title`, which is an actual property in the list. If `title` weren't a property, we would need to sort by another property.

See the [Liquid array filter](https://help.shopify.com/themes/liquid/filters/array-filters) for more filter options. Note that you can't simply use this syntax:

{% raw %}
```liquid
{% for item in site.data.samplelist.docs | sort: "title" %}{% endfor %}
```
{% endraw %}

You have to convert `site.data.samplelist.docs` to a variable first using either `assign` or `capture` tags.

## Scenario 3: Two-level navigation list

Suppose you want a more robust list that incorporates multiple sections of heading titles and subitems. To do this, add an additional level to each list item to store this information:

**YAML**

```yaml
toc:
  - title: Group 1
    subfolderitems:
      - page: Thing 1
        url: /thing1.html
      - page: Thing 2
        url: /thing2.html
      - page: Thing 3
        url: /thing3.html
  - title: Group 2
    subfolderitems:
      - page: Piece 1
        url: /piece1.html
      - page: Piece 2
        url: /piece2.html
      - page: Piece 3
        url: /piece3.html
  - title: Group 3
    subfolderitems:
      - page: Widget 1
        url: /widget1.html
      - page: Widget 2
        url: /widget2.html
      - page: Widget 3
        url: /widget3.html
```

**Liquid**

{% raw %}
```liquid
{% for item in site.data.samplelist.toc %}
    <h3>{{ item.title }}</h3>
      <ul>
        {% for entry in item.subfolderitems %}
          <li><a href="{{ entry.url }}">{{ entry.page }}</a></li>
        {% endfor %}
      </ul>
  {% endfor %}
```
{% endraw %}

**Result**
<div class="highlight result">
    <h3>Group 1</h3>
      <ul>
          <li><a href="#">Thing 1</a></li>
          <li><a href="#">Thing 2</a></li>
          <li><a href="#">Thing 3</a></li>
      </ul>

    <h3>Group 2</h3>
      <ul>
          <li><a href="#">Piece 1</a></li>
          <li><a href="#">Piece 2</a></li>
          <li><a href="#">Piece 3</a></li>
      </ul>

    <h3>Group 3</h3>
      <ul>
          <li><a href="#">Widget 1</a></li>
          <li><a href="#">Widget 2</a></li>
          <li><a href="#">Widget 3</a></li>
      </ul>
</div>

In this example, `Group 1` is the first list item. Within that list item, its subpages are included as a property that itself contains a list (`subfolderitems`).

The Liquid code looks through the first level with `for item in site.data.samplelist.toc`, and then looks through the second-level property with `for entry in item.subfolderitems`. Just as `item` is an arbitrary name for the items we're looping through, so is `entry`.

## Scenario 4: Three-level navigation list

Building on the previous section, let's add one more level of depth (`subsubfolderitems`) to the list. The formatting will get more complex here, but the principles are the same.

**YAML**

```yaml
toc2:
  - title: Group 1
    subfolderitems:
      - page: Thing 1
        url: /thing1.html
      - page: Thing 2
        url: /thing2.html
        subsubfolderitems:
          - page: Subthing 1
            url: /subthing1.html
          - page: Subthing 2
            url: /subthing2.html
      - page: Thing 3
        url: /thing3.html
  - title: Group 2
    subfolderitems:
      - page: Piece 1
        url: /piece1.html
      - page: Piece 2
        url: /piece2.html
      - page: Piece 3
        url: /piece3.html
        subsubfolderitems:
          - page: Subpiece 1
            url: /subpiece1.html
          - page: Subpiece2
            url: /subpiece2.html
  - title: Group 3
    subfolderitems:
      - page: Widget 1
        url: /widget1.html
        subsubfolderitems:
          - page: Subwidget 1
            url: /subwidget1.html
          - page: Subwidget 2
            url: /subwidget2.html
      - page: Widget 2
        url: /widget2.html
      - page: Widget 3
        url: /widget3.html
```

**Liquid**

{% raw %}
```liquid
<div>
{% if site.data.samplelist.toc2[0] %}
  {% for item in site.data.samplelist.toc2 %}
    <h3>{{ item.title }}</h3>
      {% if item.subfolderitems[0] %}
        <ul>
          {% for entry in item.subfolderitems %}
              <li><a href="{{ entry.url }}">{{ entry.page }}</a></li>
                {% if entry.subsubfolderitems[0] %}
                  <ul>
                  {% for subentry in entry.subsubfolderitems %}
                      <li><a href="{{ subentry.url }}">{{ subentry.page }}</a></li>
                  {% endfor %}
                  </ul>
                {% endif %}
          {% endfor %}
        </ul>
      {% endif %}
    {% endfor %}
{% endif %}
</div>
```
{% endraw %}

**Result**

<div class="highlight result">
   <div>
      <h3>Group 1</h3>
      <ul>
         <li><a href="#">Thing 1</a></li>
         <li><a href="#">Thing 2</a></li>
         <ul>
            <li><a href="#">Subthing 1</a></li>
            <li><a href="#">Subthing 2</a></li>
         </ul>
         <li><a href="#">Thing 3</a></li>
      </ul>
      <h3>Group 2</h3>
      <ul>
         <li><a href="#">Piece 1</a></li>
         <li><a href="#">Piece 2</a></li>
         <li><a href="#">Piece 3</a></li>
         <ul>
            <li><a href="#">Subpiece 1</a></li>
            <li><a href="#">Subpiece2</a></li>
         </ul>
      </ul>
      <h3>Group 3</h3>
      <ul>
         <li><a href="#">Widget 1</a></li>
         <ul>
            <li><a href="#">Subwidget 1</a></li>
            <li><a href="#">Subwidget 2</a></li>
         </ul>
         <li><a href="#">Widget 2</a></li>
         <li><a href="#">Widget 3</a></li>
      </ul>
   </div>
</div>

In this example, `if site.data.samplelist.toc2[0]` is used to ensure that the YAML level actually contains items. If there isn't anything at the `[0]` position, we can skip looking in this level.

<div class="note">
  <h5>ProTip: Line up <code>for</code> loops and <code>if</code> statements</h5>
  <p>To keep the code clear, line up the beginning and ending Liquid tags, such as the <code>for</code> loops and <code>if</code> statements. This way you know when the open tags have been closed. If the code will appear in a Markdown page, keep the opening and closing HTML tags flush against the left edge so that the Markdown filter won't treat the content as a code sample. If necessary, you can wrap the entire code sample in a <code>div</code> tag to ensure the code has HTML tags that bookend the code.</p>
</div>

## Scenario 5: Using a page variable to select the YAML list

Suppose your sidebar will differ based on various documentation sets. You might have 3 different products on your site, and so you want 3 different sidebars &mdash; each unique for that product.

You can store the name of the sidebar list in your page front matter and then pass that value into the list dynamically.

**Page front matter**

```yaml
---
title: My page
sidebar: toc
---
```

**Liquid**

{% raw %}
```liquid
<ul>
    {% for item in site.data.samplelist[page.sidebar] %}
      <li><a href="{{ item.url }}">{{ item.title }}</a></li>
    {% endfor %}
</ul>
```
{% endraw %}

**Result**

<div class="highlight result">
   <ul>
      <li><a href="#">Introduction</a></li>
      <li><a href="#">Configuration</a></li>
      <li><a href="#">Deployment</a></li>
   </ul>
</div>

In this scenario, we want to pass values from the page's front matter into a `for` loop that contains a variable. When the assigned variable isn't a string but rather a data reference, you must use brackets (instead of curly braces) to refer to the front matter's value.

For more information, see [Expressions and Variables](https://github.com/Shopify/liquid/wiki/Liquid-for-Designers#expressions-and-variables) in Liquid's documentation. Brackets are used in places where dot notation can't be used. You can also read more details in this [Stack Overflow answer](http://stackoverflow.com/questions/4968406/javascript-property-access-dot-notation-vs-brackets/4968448#4968448).

## Scenario 6: Applying the active class for the current page

In addition to inserting items from the YAML data file into your list, you also usually want to highlight the current link if the user is viewing that page. You do this by inserting an `active` class for items that match the current page URL.

**CSS**
```css
.result li.active a {
    color: lightgray;
    cursor: default;
  }
```
**Liquid**

{% raw %}
```liquid
{% for item in site.data.samplelist.docs %}
    <li class="{% if item.url == page.url %}active{% endif %}">
      <a href="{{ item.url }}">{{ item.title }}</a>
    </li>
{% endfor %}
```
{% endraw %}

**Result**

<style>
.result li.active a {
    color: lightgray;
    cursor: default;
  }
</style>

<div class="highlight result">
   <li class=""><a href="#">Introduction</a></li>
   <li class=""><a href="#">Configuration</a></li>
   <li class="active"><a href="#">Deployment</a></li>
</div>

In this case, assume `Deployment` is the current page.

To make sure the `item.url` (stored in the YAML file) matches the `page.url`, it can be helpful to print the `{% raw %}{{ page.url }}{% endraw %}` to the page.

## Scenario 7: Including items conditionally

You might want to include items conditionally in your list. For example, maybe you have multiple site outputs and only want to include the sidebar item for certain outputs. You can add properties in each list item and then use those properties to conditionally include the content.

**YAML**
```yaml
docs2_list_title: ACME Documentation
docs2:

- title: Introduction
  url: introduction.html
  version: 1

- title: Configuration
  url: configuration.html
  version: 1

- title: Deployment
  url: deployment.html
  version: 2
```

**Liquid**

{% raw %}
```liquid
  <ul>
    {% for item in site.data.samplelist.docs2 %}
      {% if item.version == 1 %}
        <li><a href="{{ item.url }}">{{ item.title }}</a></li>
      {% endif %}
    {% endfor %}
</ul>
```
{% endraw %}

**Result**

<div class="highlight result">
   <ul>
      <li><a href="#">Introduction</a></li>
      <li><a href="#">Configuration</a></li>
   </ul>
</div>

The `Deployment` page is excluded because its `version` is `2`.

## Scenario 8: Retrieving items based on front matter properties

If you don't want to store your navigation items in a YAML file in your `_data` folder, you can use `for` loops to look through the YAML front matter of each page or collection and get the content based on properties in the front matter.

In this scenario, suppose we have a collection called `_docs`. Collections are often better than pages because they allow you to narrow the list of what you're looping through. (Try to avoid scenarios where you loop through large numbers of items, since it will increase your build time. [Collections]({% link _docs/collections.md %}) help you narrow the scope.)

In our scenario, there are 6 docs in the `docs` collection: Sample 1, Sample 2, Topic 1, Topic 2, Widget 1, and Widget 2.

Each doc in the collection contains at least 3 properties in the front matter:

* `title`
* `category`
* `order`

The front matter for each page is as follows (consolidated here for brevity):

```yaml
---
Title: Sample 1
category: getting-started
order: 1
---

---
Title: Sample 2
category: getting-started
order: 2
---

---
Title: Topic 1
category: configuration
order: 1
---

---
Title: Topic 2
category: configuration
order: 2
---

---
Title: Widget 1
category: deployment
order: 1
---

---
Title: Widget 2
category: deployment
order: 2
---
```

Note that even though `category` is used in the doc front matter, `category` is not a built-in variable like it is with posts. In other words, you cannot look directly inside `category` with `site.docs.category`.

If you wanted to simply get all docs in the collection for a specific category, you could use a `for` loop with an `if` condition to check for a specific category:

{% raw %}
```liquid
<h3>Getting Started</h3>
<ul>
    {% for doc in site.docs %}
      {% if doc.category == "getting-started" %}
        <li><a href="{{ doc.url }}">{{ doc.title }}</a></li>
      {% endif %}
    {% endfor %}
</ul>
```
{% endraw %}

The result would be as follows:

<div class="highlight result">
   <h3>Getting Started</h3>
   <ul>
      <li><a href="#">Sample1</a></li>
      <li><a href="#">Sample2</a></li>
   </ul>
</div>

This might be useful if you're setting up a knowledge base and have dozens of topics in each category, with each category displaying on its own page.

But let's say you want to sort the items by category and group them under the category name, without hard-coding the category names. To achieve this, you could use two filters:

* `group_by`
* `sort`

Here's the code for getting lists of pages grouped under their corresponding category headers:

**Liquid**

{% raw %}
```liquid
{% assign mydocs = site.docs | group_by: 'category' %}
{% for cat in mydocs %}
<h2>{{ cat.name | capitalize }}</h2>
    <ul>
      {% assign items = cat.items | sort: 'order' %}
      {% for item in items %}
        <li><a href="{{ item.url }}">{{ item.title }}</a></li>
      {% endfor %}
    </ul>
{% endfor %}
```
{% endraw %}

**Result**

<div class="highlight result">
   <h2>Getting-started</h2>
   <ul>
      <li><a href="#">Sample2</a></li>
      <li><a href="#">Sample1</a></li>
   </ul>
   <h2>Configuration</h2>
   <ul>
      <li><a href="#">Topic2</a></li>
      <li><a href="#">Topic1</a></li>
   </ul>
   <h2>Deployment</h2>
   <ul>
      <li><a href="#">Widget2</a></li>
      <li><a href="#">Widget1</a></li>
   </ul>
</div>

Let's walk through the code. First, we assign a variable (`mydocs`) to the collection content (`site.docs`).

The `group_by` filter groups the collection content by `category`. More specifically, the `group_by` filter converts `mydocs` into an array with `name`, `items`, and `size` properties, somewhat like this:

```yaml
[
  {"name": "getting-started", "items": [Sample 1, Sample 2],"size": 2},
  {"name": "configuration", "items": [Topic 1, Topic 2],  "size": 2},
  {"name": "deployment", "items": [Widget 1, Widget 2, "size": 2}
]
```

Using `for cat in mydocs`, we look through each item in the `mydocs` array and print the category `name`.

After getting the category name, we assign the variable `items` for the docs and use the `sort` filter to arrange the docs by their `order` property. The dot notation `cat.items` is used because we're accessing the content in the `items` array. The `sort` filter orders the items by their numbers in ascending order.

The `for item in items` loop looks through each `item` and gets the `title` and `url` to form the list item link.

For more details on the `group_by` filter, see [Jekyll's Templates documentation](https://jekyllrb.com/docs/templates/) as well as [this Siteleaf tutorial](https://www.siteleaf.com/blog/advanced-liquid-group-by/). For more details on the `sort` filter, see [sort](https://shopify.github.io/liquid/filters/sort/) in Liquid's documentation.

Whether you use properties in your doc's front matter to retrieve your pages or a YAML data file, in both cases you can programmatically build a more robust navigation for your site.
