---
layout: docs
title: Collections
permalink: /docs/collections/
---

<div class="note warning">
  <h5>Collections support is unstable and may change</h5>
  <p>
    This is an experimental feature and that the API may likely change until the feature stabilizes.
  </p>
</div>

Not everything is a post or a page. Maybe you want to document the various methods in your open source project, members of a team, or talks at a conference. Collections allow you to define a new type of document that behave like Pages or Posts do normally, but also have their own unique properties and namespace.

## Using Collections

### Step 1: Tell Jekyll to read in your collection

Add the following to your site's `_config.yml` file, replacing `my_collection` with the name of your collection:

{% highlight yaml %}
collections:
- my_collection
{% endhighlight %}

You can optionally specify metadata for your collection in the configuration:

{% highlight yaml %}
collections:
  my_collection:
    foo: bar
{% endhighlight %}

### Step 2: Add your content

Create a corresponding folder (e.g. `<source>/_my_collection`) and add documents.
YAML Front Matter is read in as data if it exists, and everything after it is stuck in the Document's `content` attribute. If no YAML Front Matter is provided, Jekyll will not generate the file in your collection.

Note: the folder must be named identically to the collection you defined in your `_config.yml` file, with the addition of the preceding `_` character.

### Step 3: Optionally render your collection's documents into independent files

If you'd like Jekyll to create a public-facing, rendered version of each document in your collection, set the `output` key to `true` in your collection metadata in your `_config.yml`:

{% highlight yaml %}
collections:
  my_collection:
    output: true
{% endhighlight %}

This will produce a file for each document in the collection.
For example, if you have `_my_collection/some_subdir/some_doc.md`,
it will be rendered using Liquid and the Markdown converter of your
choice and written out to `<dest>/my_collection/some_subdir/some_doc.html`.

As for posts with [Permalinks](../permalinks/), document URL can be customized by setting a `permalink` metadata to the collection:

{% highlight yaml %}
collections:
  my_collection:
    output: true
    permalink: /awesome/:path/
{% endhighlight %}

For example, if you have `_my_collection/some_subdir/some_doc.md`, it will be written out to `<dest>/awesome/some_subdir/some_doc/index.html`.

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>collection</code></p>
      </td>
      <td>
        <p>Label of the containing collection.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>path</code></p>
      </td>
      <td>
        <p>Path to the document relative to the collection's directory.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>name</code></p>
      </td>
      <td>
        <p>The document's base filename, with every sequence of spaces and non-alphanumeric characters replaced by a hyphen.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>title</code></p>
      </td>
      <td>
        <p>The document's lowercase title (as defined in its <a href="/docs/frontmatter/">front matter</a>), with every sequence of spaces and non-alphanumeric characters replaced by a hyphen. If the document does not define a title in its <a href="/docs/frontmatter/">front matter</a>, this is equivalent to <code>name</code>.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>output_ext</code></p>
      </td>
      <td>
        <p>Extension of the output file.</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Liquid Attributes

### Collections

Each collection is accessible via the `site` Liquid variable. For example, if you want to access the `albums` collection found in `_albums`, you'd use `site.albums`. Each collection is itself an array of documents (e.g. `site.albums` is an array of documents, much like `site.pages` and `site.posts`). See below for how to access attributes of those documents.

The collections are also available under `site.collections`, with the metadata you specified in your `_config.yml` (if present) and the following information:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>label</code></p>
      </td>
      <td>
        <p>
          The name of your collection, e.g. <code>my_collection</code>.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>docs</code></p>
      </td>
      <td>
        <p>
          An array of <a href="#documents">documents</a>.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>relative_directory</code></p>
      </td>
      <td>
        <p>
          The path to the collections's source directory, relative to the site source.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>directory</code></p>
      </td>
      <td>
        <p>
          The full path to the collections's source directory.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>output</code></p>
      </td>
      <td>
        <p>
          Whether the collection's documents will be output as individual files.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>


### Documents

In addition to any YAML Front Matter provided in the document's corresponding file, each document has the following attributes:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>content</code></p>
      </td>
      <td>
        <p>
          The (unrendered) content of the document. If no YAML Front Matter is provided, Jekyll will not generate the file in your collection. If YAML Front Matter
          is used, then this is all the contents of the file after the terminating
          `---` of the front matter.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>output</code></p>
      </td>
      <td>
        <p>
          The rendered output of the document, based on the <code>content</code>.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>path</code></p>
      </td>
      <td>
        <p>
          The full path to the document's source file.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>relative_path</code></p>
      </td>
      <td>
        <p>
          The path to the document's source file relative to the site source.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>url</code></p>
      </td>
      <td>
        <p>
          The URL of the rendered collection. The file is only written to the
          destination when the name of the collection to which it belongs is
          included in the <code>render</code> key in the site's configuration file.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>collection</code></p>
      </td>
      <td>
        <p>
          The name of the document's collection.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>
