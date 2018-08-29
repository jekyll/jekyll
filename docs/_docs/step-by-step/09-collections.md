---
layout: step
title: 9. Collections
---
In the last tutorial you added blog posts to the site. Now let's look at
fleshing out authors so each author has their own page with a blurb and the
posts they've published.

To do this you'll use collections. Collections are similar to posts except the
content doesn't have to be grouped by date.

## Configuration

To set up a collection you need to tell Jekyll about it. Jekyll configuration
happens in a file called `_config.yml` (by default). Create `_config.yml` in the
root with the following content:

```yaml
collections:
  authors:
```

## Add authors

Documents (the items in a collection) live in a folder in the root of the site
named  `_*collection_name*`, in this case it’s `_authors`.

Create a document for each author:

`_authors/jill.md`:

```markdown
---
short_name: jill
name: Jill Smith
position: Chief Editor
---
Jill is an avid fruit grower based in south of France.
```

`_authors/ted.md`:

```markdown
---
short_name: ted
name: Ted Doe
position: Writer
---
Ted has been eating fruit since he was baby.
```

## Staff page

Let's add a page which lists all the authors on the site. Jekyll makes the
collections available in a similar way to posts, at `site.authors` in this case.
Create `staff.html` and iterate over `site.author` to output all the staff:

{% raw %}
```html
---
layout: default
---
<h1>Staff</h1>

<ul>
  {% for author in site.authors %}
    <li>
      <h2>{{ author.name }}</h2>
      <h3>{{ author.position }}</h3>
      <p>{{ author.content | markdownify }}</p>
    </li>
  {% endfor %}
</ul>
```
{% endraw %}

Since the content is markdown, you need to run it through the
`markdownify` filter. This happens automatically when outputting using
`{{ content }}` in a layout.

## Output a page

By default, collections do not output a page for each document. In this case we
want each author to have their own page so let's tweak the collection
configuration.

Open `_config.yml` and add `output: true` to the author collection
configuration:

```yaml
collections:
  authors:
    output: true
```

You can link to the output page by using `author.url`. Add the link to the
`staff.html` page:

{% raw %}
```html
---
layout: default
---
<h1>Staff</h1>

<ul>
  {% for author in site.authors %}
    <li>
      <h2><a href="{{ author.url }}">{{ author.name }}</a></h2>
      <h3>{{ author.position }}</h3>
      <p>{{ author.content | markdownify }}</p>
    </li>
  {% endfor %}
</ul>
```
{% endraw %}

Just like posts you'll need to create a layout for authors. Create
`_layouts/author.html` with the following content:

{% raw %}
```html
---
layout: default
---
<h1>{{ page.name }}</h1>
<h2>{{ page.position }}</h2>

{{ content }}
```
{% endraw %}

## Front matter defaults

Now you need to configure the author documents to use the `author` layout. You
could do this in the front matter like we have previously but that's getting
repetitive. What you really want is all posts to automatically have the post
layout, authors to have author and everything else to use the default.

You can achieve this by using [front matter defaults](/docs/configuration/front-matter-defaults/)
in `_config.yml`. You set a scope of what the default applies to, then the
default you'd like.

Add defaults for layouts to your `_config.yml`,

```yaml
collections:
  authors:
    output: true

defaults:
-
  scope:
    path: ""
    type: "authors"
  values:
    layout: "author"
-
  scope:
    path: ""
    type: "posts"
  values:
    layout: "post"
  -
    scope:
      path: ""
    values:
      layout: "default"
```

Now you can remove layout the front matter of all pages and posts. Note that
any time you update `_config.yml` you'll need to restart Jekyll for the changes
to take affect.

## List author's posts

Now we can list the posts an author has published on their page. To do
this you need to match the author `short_name` to the post `author`. You
use this to filter posts by author. Iterate over this filtered list in
`_layouts/author.html` to output the author's posts:

{% raw %}
```html
---
layout: default
---
<h1>{{ page.name }}</h1>
<h2>{{ page.position }}</h2>

{{ content }}

<h2>Posts</h2>
<ul>
  {% assign filtered_posts = site.posts | where: 'author', page.short_name %}
  {% for post in filtered_posts %}
    <li><a href="{{ post.url }}">{{ post.title }}</a></li>
  {% endfor %}
</ul>
```
{% endraw %}

## Link to authors page

The final step is to link to the author's page from the post. This is achieved
in a similar way in `_layouts/post.html`:

```html
---
layout: default
---
<h1>{{ page.title }}</h1>

<p>
  {{ page.date | date_to_string }}
  {% assign author = site.authors | where: 'short_name', page.author | first %}
  {% if author %}
    - <a href="{{ author.url }}">{{ author.name }}</a>
  {% endif %}
</p>

{{ content }}
```

Open up `http://localhost:4000/` and have a look at the staff page and the
author links on posts to check everything is linked together correctly. In part
of this series, we'll add final polish to the site and get it ready for a
production deployment.
