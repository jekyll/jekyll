---
title: Collections
permalink: /docs/collections/
---

Collections are a great way to group related content like members of a team or
talks at a conference.

## Setup

To use a Collection you first need to define it in your `_config.yml`. For
example here's a collection of staff members:

```yaml
collections:
  - staff_members
```

In this case `collections` is defined as a sequence (i.e., array) with no additional metadata defined for each collection.
You can optionally specify metadata for your collection by defining `collections` as a mapping (i.e., hashmap) instead of sequence, and then defining additional fields in it:

```yaml
collections:
  staff_members:
    people: true
```

{: .note .info}
When defining a collection as a sequence, its pages will not be rendered by
default. To enable this, `output: true` must be specified on the
collection, which requires defining the collection as a mapping. For more
information, see the section [Output](#output).

{: .note}
**Gather your collections**{:.title} {%- include docs_version_badge.html version="3.7.0" -%}<br>
You can optionally specify a directory to store all your collections in the same place with
`collections_dir: my_collections`.
<br>
Then Jekyll will look in `my_collections/_books` for the `books` collection, and
in `my_collections/_recipes` for the `recipes` collection.

{: .note .warning}
**Be sure to move drafts and posts into custom collections directory**{:.title}<br>
If you specify a directory to store all your collections in the same place with
`collections_dir: my_collections`, then you will need to move your
`_drafts` and `_posts` directory to `my_collections/_drafts`
and `my_collections/_posts`.
<br>
Note that the name of your collections directory cannot start with an underscore (`_`).

## Add content

Create a corresponding folder (e.g. `<source>/_staff_members`) and add
documents. Front matter is processed if the front matter exists, and everything
after the front matter is pushed into the document's `content` attribute. If no front
matter is provided, Jekyll will consider it to be a [static file]({{ '/docs/static-files/' | relative_url }})
and the contents will not undergo further processing. If front matter is provided,
Jekyll will process the file contents into the expected output.

Regardless of whether front matter exists or not, Jekyll will write to the destination
directory (e.g. `_site`) only if `output: true` has been set in the collection's
metadata.

For example here's how you would add a staff member to the collection set above.
The filename is `./_staff_members/jane.md` with the following content:

```markdown
---
name: Jane Doe
position: Developer
---
Jane has worked on Jekyll for the past *five years*.
```

<em>
  Do note that in spite of being considered as a collection internally, the above
  doesn't apply to [posts](/docs/posts/). Posts with a valid filename format will be
  marked for processing even if they do not contain front matter.
</em>

{: .note .info}
**Be sure to name your directories correctly**{:.title}<br>
The folder must be named identically to the collection you defined in
your `_config.yml` file, with the addition of the preceding `_` character.

## Output

Now you can iterate over `site.staff_members` on a page and output the content
for each staff member. Similar to posts, the body of the document is accessed
using the `content` variable:

{% raw %}
```liquid
{% for staff_member in site.staff_members %}
  <h2>{{ staff_member.name }} - {{ staff_member.position }}</h2>
  <p>{{ staff_member.content | markdownify }}</p>
{% endfor %}
```
{% endraw %}

If you'd like Jekyll to create a rendered page for each document in your
collection, you can set the `output` key to `true` in your collection
metadata in `_config.yml`:

```yaml
collections:
  staff_members:
    output: true
```

You can link to the generated page using the `url` attribute:

{% raw %}
```liquid
{% for staff_member in site.staff_members %}
  <h2>
    <a href="{{ staff_member.url }}">
      {{ staff_member.name }} - {{ staff_member.position }}
    </a>
  </h2>
  <p>{{ staff_member.content | markdownify }}</p>
{% endfor %}
```
{% endraw %}

## Permalinks

There are special [permalink variables for collections]({{ '/docs/permalinks/#collections' | relative_url }}) to
help you control the output url for the entire collection.

## Custom Sorting of Documents {%- include docs_version_badge.html version="4.0" -%}
{: #custom-sorting-of-documents}

By default, two documents in a collection are sorted by their `date` attribute when both of them have the `date` key in their front matter. However, if either or both documents do not have the `date` key in their front matter, they are sorted by their respective paths.

You can control this sorting via the collection's metadata.

### Sort By Front Matter Key

Documents can be sorted based on a front matter key by setting a `sort_by` metadata to the front matter key string. For example,
to sort a collection of tutorials based on key `lesson`, the configuration would be:

```yaml
collections:
  tutorials:
    sort_by: lesson
```

The documents are arranged in the increasing order of the key's value. If a document does not have the front matter key defined
then that document is placed immediately after sorted documents. When multiple documents do not have the front matter key defined,
those documents are sorted by their dates or paths and then placed immediately after the sorted documents.

### Manually Ordering Documents

You can also manually order the documents by setting an `order` metadata with **the filenames listed** in the desired order.
For example, a collection of tutorials would be configured as:

```yaml
collections:
  tutorials:
    order:
      - hello-world.md
      - introduction.md
      - basic-concepts.md
      - advanced-concepts.md
```

Any documents with filenames that do not match the list entry simply gets placed after the rearranged documents. If a document is
nested under subdirectories, include them in entries as well:

```yaml
collections:
  tutorials:
    order:
      - hello-world.md
      - introduction.md
      - concepts/basics.md
      - concepts/advanced.md
```

If both metadata keys have been defined properly, `order` list takes precedence.

## Liquid Attributes

### Collections

Collections are also available under `site.collections`, with the metadata
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

{: .note .info}
**A Hard-Coded Collection**{:.title}<br>
In addition to any collections you create yourself, the
`posts` collection is hard-coded into Jekyll. It exists whether
you have a `_posts` directory or not. This is something to note
when iterating through `site.collections` as you may need to
filter it out.
<br>
You may wish to use filters to find your collection:
`{% raw %}{{ site.collections | where: "label", "myCollection" | first }}{% endraw %}`

{: .note .info}
**Collections and Time**{:.title}<br>
Except for documents in hard-coded default collection `posts`, all documents in collections
you create, are accessible via Liquid irrespective of their assigned date, if any, and therefore renderable.
<br>
Documents are attempted to be written to disk only if the concerned collection
metadata has `output: true`. Additionally, future-dated documents are only written if
`site.future` *is also true*.
<br>
More fine-grained control over documents being written to disk can be exercised by setting
`published: false` (*`true` by default*) in the document's front matter.

### Documents

In addition to any front matter provided in the document's corresponding
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
          The (unrendered) content of the document. If no front matter is
          provided, Jekyll will not generate the file in your collection. If
          front matter is used, then this is all the contents of the file
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
