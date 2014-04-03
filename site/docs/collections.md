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

<div class="note warning">
  <h5>Collections support is unstable and may change</h5>
  <p>
    This is an experimental feature and that the API may likely change until the feature stabilizes.
  </p>
</div>

Put some things in a folder and add the folder to your config. It's simple...

Not everything is a post or a page. Maybe you want to document the various methods in your open source project, members of a team, or talks at a conference. Collections allow you to define a new type of document that behave like Pages or Posts do normally, but also have their own unique properties and namespace.

## Using Collections

### Step 1: Tell Jekyll to read in your collection

Add the following to your site's `_config.yml` file, replacing `my_collection` with the name of your collection:

{% highlight yaml %}
collections:
- my_collection
{% endhighlight %}

### Step 2: Add your content

Create a corresponding folder (e.g. `<source>/_my_collection`) and add documents.
YAML front-matter is read in as data if it exists, if not, then everything is just stuck in the Document's `content` attribute.

Note: the folder must be named identical to the collection you defined in you config.yml file, with the addition of the preceding `_` character.

### Step 3: Optionally render your collection's documents into independent files

If you'd like Jekyll to create a public-facing, rendered version of each document in your collection, add your collection name to the `render` config key in your `_config.yml`:

{% highlight yaml %}
render:
- my_collection
{% endhighlight %}

This will produce a file for each document in the collection.
For example, if you have `_my_collection/some_subdir/some_doc.md`,
it will be rendered using Liquid and the Markdown converter of your
choice and written out to `<dest>/my_collection/some_subdir/some_doc.html`.
