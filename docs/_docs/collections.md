---
title: Collections
permalink: /docs/collections/
---

Not everything is a post or a page. Maybe you want to document the various
methods in your open source project, members of a team, or talks at a
conference. Collections allow you to define a new type of document that behave
like Pages or Posts do normally, but also have their own unique properties and
namespace.

## Using Collections

To start using collections, follow these 3 steps:

* [Step 1: Tell Jekyll to read in your collection](#step1)
* [Step 2: Add your content](#step2)
* [Step 3: Optionally render your collection's documents into independent files](#step3)

### Step 1: Tell Jekyll to read in your collection {#step1}

Add the following to your site's `_config.yml` file, replacing `my_collection`
with the name of your collection:

```yaml
collections:
- my_collection
```

You can optionally specify metadata for your collection in the configuration:

```yaml
collections:
  my_collection:
    foo: bar
```

Default attributes can also be set for a collection:

```yaml
defaults:
  - scope:
      path: ""
      type: my_collection
    values:
      layout: page
```

<div class="note">
  <h5>Gather your collections {%- include docs_version_badge.html version="3.7.0" -%}</h5>

  <p>You can optionally specify a directory to store all your collections in the same place with <code>collections_dir: my_collections</code>.</p>

  <p>Then Jekyll will look in <code>my_collections/_books</code> for the <code>books</code> collection, and
  in <code>my_collections/_recipes</code> for the <code>recipes</code> collection.</p>
</div>

<div class="note warning">
  <h5>Be sure to move posts into custom collections directory</h5>

  <p>If you specify a directory to store all your collections in the same place with <code>collections_dir: my_collections</code>, then you will need to move your <code>_posts</code> directory to <code>my_collections/_posts</code>. Note that, the name of your collections directory cannot start with an underscore (`_`).</p>
</div>

### Step 2: Add your content {#step2}

Create a corresponding folder (e.g. `<source>/_my_collection`) and add
documents. YAML front matter is processed if the front matter exists, and everything
after the front matter is pushed into the document's `content` attribute. If no YAML front
matter is provided, Jekyll will not generate the file in your collection.

<div class="note info">
  <h5>Be sure to name your directories correctly</h5>
  <p>
The folder must be named identically to the collection you defined in
your <code>_config.yml</code> file, with the addition of the preceding <code>_</code> character.
  </p>
</div>

### Step 3: Optionally render your collection's documents into independent files {#step3}

If you'd like Jekyll to create a public-facing, rendered version of each
document in your collection, set the `output` key to `true` in your collection
metadata in your `_config.yml`:

```yaml
collections:
  my_collection:
    output: true
```

This will produce a file for each document in the collection.
For example, if you have `_my_collection/some_subdir/some_doc.md`,
it will be rendered using Liquid and the Markdown converter of your
choice and written out to `<dest>/my_collection/some_subdir/some_doc.html`.

If you wish a specific page to be shown when accessing `/my_collection/`,
simply add `permalink: /my_collection/index.html` to a page.
To list items from the collection, on that page or any other, you can use:

{% raw %}
```liquid
{% for item in site.my_collection %}
  <h2>{{ item.title }}</h2>
  <p>{{ item.description }}</p>
  <p><a href="{{ item.url }}">{{ item.title }}</a></p>
{% endfor %}
```
{% endraw %}

<div class="note info">
  <h5>Don't forget to add YAML for processing</h5>
  <p>
  Files in collections that do not have front matter are treated as
  <a href="/docs/static-files">static files</a> and simply copied to their
  output location without processing.
  </p>
</div>

## Configuring permalinks for collections {#permalinks}

If you wish to specify a custom pattern for the URLs where your Collection pages
will reside, you may do so with the [`permalink` property](../permalinks/):

```yaml
collections:
  my_collection:
    output: true
    permalink: /:collection/:name
```

### Examples

For a collection with the following source file structure,

```
_my_collection/
└── some_subdir
    └── some_doc.md
```

each of the following `permalink` configurations will produce the document structure shown below it.

* **Default**
  Same as `permalink: /:collection/:path`.

  ```
  _site/
  ├── my_collection
  │   └── some_subdir
  │       └── some_doc.html
  ...
  ```
* `permalink: pretty`
  Same as `permalink: /:collection/:path/`.

  ```
  _site/
  ├── my_collection
  │   └── some_subdir
  │       └── some_doc
  │           └── index.html
  ...
  ```
* `permalink: /doc/:path`

  ```
  _site/
  ├── doc
  │   └── some_subdir
  │       └── some_doc.html
  ...
  ```
* `permalink: /doc/:name`

  ```
  _site/
  ├── doc
  │   └── some_doc.html
  ...
  ```
* `permalink: /:name`

  ```
  _site/
  ├── some_doc.html
  ...
  ```

### Template Variables

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
        <p><code>:collection</code></p>
      </td>
      <td>
        <p>Label of the containing collection.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:path</code></p>
      </td>
      <td>
        <p>Path to the document relative to the collection's directory.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:name</code></p>
      </td>
      <td>
        <p>The document's base filename, with every sequence of spaces
        and non-alphanumeric characters replaced by a hyphen.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:title</code></p>
      </td>
      <td>
        <p>
          The <code>:title</code> template variable will take the
          <code>slug</code> <a href="/docs/frontmatter/">front matter</a>
          variable value if any is present in the document; if none is
          defined then <code>:title</code> will be equivalent to
          <code>:name</code>, aka the slug generated from the filename.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:output_ext</code></p>
      </td>
      <td>
        <p>Extension of the output file. (Included by default and usually unnecessary.)</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Liquid Attributes

### Collections

Each collection is accessible as a field on the `site` variable. For example, if
you want to access the `albums` collection found in `_albums`, you'd use
`site.albums`.

Each collection is itself an array of documents (e.g., `site.albums` is an array of documents, much like `site.pages` and
`site.posts`). See the table below for how to access attributes of those documents.

The collections are also available under `site.collections`, with the metadata
you specified in your `_config.yml` (if present) and the following information:

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
        <p><code>files</code></p>
      </td>
      <td>
        <p>
          An array of static files in the collection.
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>relative_directory</code></p>
      </td>
      <td>
        <p>
          The path to the collection's source directory, relative to the site
          source.
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
          Whether the collection's documents will be output as individual
          files.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

<div class="note info">
  <h5>A Hard-Coded Collection</h5>
  <p>In addition to any collections you create yourself, the
  <code>posts</code> collection is hard-coded into Jekyll. It exists whether
  you have a <code>_posts</code> directory or not. This is something to note
  when iterating through <code>site.collections</code> as you may need to
  filter it out.</p>
  <p>You may wish to use filters to find your collection:
  <code>{% raw %}{{ site.collections | where: "label", "myCollection" | first }}{% endraw %}</code></p>
</div>


### Documents

In addition to any YAML Front Matter provided in the document's corresponding
file, each document has the following attributes:

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
          The (unrendered) content of the document. If no YAML Front Matter is
          provided, Jekyll will not generate the file in your collection. If
          YAML Front Matter is used, then this is all the contents of the file
          after the terminating
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
          The rendered output of the document, based on the
          <code>content</code>.
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
          The URL of the rendered collection. The file is only written to the destination when the collection to which it belongs has <code>output: true</code> in the site's configuration.
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
    <tr>
      <td>
        <p><code>date</code></p>
      </td>
      <td>
        <p>
          The date of the document's collection.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Accessing Collection Attributes

Attributes from the YAML front matter can be accessed as data anywhere in the
site. Using the above example for configuring a collection as `site.albums`,
you might have front matter in an individual file structured as follows (which
must use a supported markup format, and cannot be saved with a `.yaml`
extension):

```yaml
title: "Josquin: Missa De beata virgine and Missa Ave maris stella"
artist: "The Tallis Scholars"
director: "Peter Phillips"
works:
  - title: "Missa De beata virgine"
    composer: "Josquin des Prez"
    tracks:
      - title: "Kyrie"
        duration: "4:25"
      - title: "Gloria"
        duration: "9:53"
      - title: "Credo"
        duration: "9:09"
      - title: "Sanctus & Benedictus"
        duration: "7:47"
      - title: "Agnus Dei I, II & III"
        duration: "6:49"
```

Every album in the collection could be listed on a single page with a template:

```liquid
{% raw %}
{% for album in site.albums %}
  <h2>{{ album.title }}</h2>
  <p>Performed by {{ album.artist }}{% if album.director %}, directed by {{ album.director }}{% endif %}</p>
  {% for work in album.works %}
    <h3>{{ work.title }}</h3>
    <p>Composed by {{ work.composer }}</p>
    <ul>
    {% for track in work.tracks %}
      <li>{{ track.title }} ({{ track.duration }})</li>
    {% endfor %}
    </ul>
  {% endfor %}
{% endfor %}
{% endraw %}
```
