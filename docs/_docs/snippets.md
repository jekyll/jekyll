---
title: Snippets
permalink: /docs/snippets/
render_with_liquid: false
---

Snippets are chunks of text or code that are rendered as required but just once per build. The rendered output can be *included*
into documents, pages, or Liquid templates multiple times via a new [`snippet` tag](#snippet-tag).

## Snippets and Includes

Snippets are functionally similar to *includes* yet slightly different as outlined below:

Feature          | Includes            | Snippets
---------------- | :-----------------: | :-----------------------------:
Front Matter     | Ignored             | Ignored
Theme-gem        | Allowed             | Allowed
Regeneration     | Supported           | Supported
Content-type     | Any                 | Depends on available converters.
Converter        | user-dependent (e.g. use of filters `markdownify`, `scssify`, etc) | automatically based on file-extension
Rendering        | render-on-demand    | render-on-demand but only on first request
Default Location | `_includes`         | `_snippets`
Liquid Access    | `{% include ... %}` | `{% snippet ... %}`

## Snippets and Documents

Snippets is not a collection. Therefore, a *snippet* is not a document.
The only similarity between a snippet and a document (or a standalone page), is that they all are rendered once and regenerated
when changed.

Feature                 | Document            | Snippet
----------------------- | :-----------------: | :--------------------------:
Convertible (to markup) | Yes                 | Yes
Renderable (via Liquid) | Conditionally       | Conditionally
Liquid accessible self  | `{{ page }}`        | No
Liquid accessible other | via `{% for ... %}` | Only via `{% snippet ... %}`
Front Matter            | Required            | Ignored
Placed into layouts     | Yes                 | No
Written to destination  | Conditionally       | No

## Snippet Tag

The `snippet` tag allows one to insert rendered snippets within documents, pages and Liquid templates, avoiding repeated
rendering of the source-content. The raw source-content gets rendered the first time the requested snippet is encountered.

```liquid
{% snippet 'footer.md' %}
```

### Snippet Tag and Include Tag


Feature           | Include Tag     | Snippet Tag
----------------- | :-------------: | :-----------------------------:
Tag Name          | `include`       | `snippet`
Markup            | Unquoted string | Quoted string
Variable Support  | string enclosed between `{{` and `}}` | Unquoted String
Tag Parameters    | Supported       | Not Supported
Regeneration      | Supported       | Supported
Handing Not Found | Aborts build    | Issues a warning

## Primary use case

The *snippets* entity was introduced to optimize the following use-case(s):

```html
<!-- _layouts/two_columns.html -->

...
<aside>
  <ul>
    {% for item in site.myList %}
      {% if item == page_independent_condition %}
        <li>
          ...
        </li>
       {% endif %}
     {% endfor %}
  </ul>

{% capture description %}
This site was built with :heart: using Jekyll v{{ jekyll.version }}
{:.version-info }
{% endcapture %}

{{ description | markdownify }}
</aside>
```

Since Jekyll doesn't pass layouts through converters, the user is forced to either markup in HTML directly or *capture*
Markdown text in a Liquid variable and pipe it through the `markdownify` filter to have Jekyll generate the markup.

The issue here is that the captured content is generic-enough to be outside the `{{ content }}` within the layout
(i.e., independent of the `{{ page }}` object fed into the layout). Therefore, the captured content is going to be
rendered into the same markup output irrespective of the final URL. Yet, since the captured content is passed through
the `markdownify` filter, it gets *repeatedly parsed and converted* by the active Markdown converter, which is wasteful.

Even by using an existing whitelisted third-party plugin, `{% include_cached ... %}`, the user would need to capture and
markdownify to have Jekyll generate the markup.

The solution, is to convert the chunk of text as *a snippet*.

Snippets are designed to be rendered just once, like standalone pages, but without the need for a front matter header of
the latter. Moreover, they do not have URL attributes and consequently never written to destination. *Lesser flexibility
translates to lesser overhead*.

```liquid
<!-- _snippets/aside/page_independent_list.html -->
<ul>
  {% for item in site.myList %}
    {% if item == page_independent_condition %}
      <li>
        ...
      </li>
    {% endif %}
  {% endfor %}
</ul>
```

```markdown
<!-- _snippets/aside/description.md -->

This site was built with :heart: using Jekyll v{{ jekyll.version }}
{:.version-info }
```

```html
<!-- _layouts/two_columns.html -->

...
<aside>
{% snippet 'aside/page_independent_list.html' %}

{% snippet 'aside/description.md' %}
</aside>
```
