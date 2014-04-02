---
layout: docs
title: Collections
prev_section: variables
next_section: datafiles
permalink: /docs/collections/
---

<div class="note unreleased">
  <h5>Collections support is currently unreleased.</h5>
  <p>
  In order to use this feature, <a href="/docs/installation/#pre-releases">
  install the latest development version of Jekyll</a>.
  </p>
</div>

Put some things in a folder and add the folder to your config. It's simple...

Why did we write this feature? What is it useful for?

## Using Collections

### Step 1: Tell Jekyll to read in your collection

{% highlight yaml %}
collections:
- my_collection
{% endhighlight %}

### Step 2: Add your content

Create a corresponding folder (e.g. `<source>/_my_collection`) and add documents.
YAML front-matter is read in as data if it exists, if not, then everything is just
stuck in the Document's `content` attribute.

### Step 3: Optionally render your collection's documents into independent files

If you'd like your files rendered, add it to your config:

{% highlight yaml %}
render:
- my_collection
{% endhighlight %}

This will produce a file for each document in the collection.
For example, if you have `_my_collection/some_subdir/some_doc.md`,
it will be rendered using Liquid and the Markdown converter of your
choice and written out to `<dest>/my_collection/some_subdir/some_doc.html`.
