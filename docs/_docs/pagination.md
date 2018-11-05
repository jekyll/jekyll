---
title: Pagination
permalink: /docs/pagination/
---

With many websites &mdash; especially blogs &mdash; it’s very common to
break the main listing of posts up into smaller lists and display them over
multiple pages. Jekyll offers a pagination plugin, so you can automatically
generate the appropriate files and folders you need for paginated listings.

For Jekyll 3, include the `jekyll-paginate` plugin in your Gemfile and in
your `_config.yml` under `plugins`. For Jekyll 2, this is standard.

Pagination does not work from within Markdown files from
your Jekyll site. Pagination works when called from within the HTML
file, named `index.html`, which optionally may reside in and
produce pagination from within a subdirectory, via the
`paginate_path` configuration value.
{: .warning }

## Enable pagination

To enable pagination for posts on your blog, add a line to the `_config.yml` file that
specifies how many items should be displayed per page:

```yaml
paginate: 5
```

The number should be the maximum number of Posts you’d like to be displayed
per-page in the generated site.

You may also specify the destination of the pagination pages:

```yaml
paginate_path: "/blog/page:num/"
```

This will read in `blog/index.html`, send it each pagination page in Liquid as
`paginator` and write the output to `blog/page:num/`, where `:num` is the
pagination page number, starting with `2`. <br/>
If a site has 12 posts and specifies `paginate: 5`, Jekyll will write `blog/index.html`
with the first 5 posts, `blog/page2/index.html` with the next 5 posts and
`blog/page3/index.html` with the last 2 posts into the destination directory.

Setting a permalink in the front matter of your blog page will cause pagination to break. Just omit the permalink.
{: .warning }

## Liquid Attributes Available

The pagination plugin exposes the `paginator` liquid object with the following
attributes:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><p><code>page</code></p></td>
      <td><p>current page number</p></td>
    </tr>
    <tr>
      <td><p><code>per_page</code></p></td>
      <td><p>number of posts per page</p></td>
    </tr>
    <tr>
      <td><p><code>posts</code></p></td>
      <td><p>a list of posts for the current page</p></td>
    </tr>
    <tr>
      <td><p><code>total_posts</code></p></td>
      <td><p>total number of posts in the site</p></td>
    </tr>
    <tr>
      <td><p><code>total_pages</code></p></td>
      <td><p>number of pagination pages</p></td>
    </tr>
    <tr>
      <td><p><code>previous_page</code></p></td>
      <td>
        <p>
          page number of the previous pagination page,
          or <code>nil</code> if no previous page exists
        </p>
      </td>
    </tr>
    <tr>
      <td><p><code>previous_page_path</code></p></td>
      <td>
        <p>
          path of previous pagination page,
          or <code>nil</code> if no previous page exists
        </p>
      </td>
    </tr>
    <tr>
      <td><p><code>next_page</code></p></td>
      <td>
          <p>
              page number of the next pagination page,
              or <code>nil</code> if no subsequent page exists
          </p>
      </td>
    </tr>
    <tr>
      <td><p><code>next_page_path</code></p></td>
      <td>
        <p>
          path of next pagination page,
          or <code>nil</code> if no subsequent page exists
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Tags and Categories

Pagination pages through every post in the `posts`
variable unless a post has `hidden: true` in its front matter.
It does not currently allow paging over groups of posts linked
by a common tag or category. It cannot include any collection of documents because it is restricted to posts.

[jekyll-paginate-v2](https://github.com/sverrirs/jekyll-paginate-v2) is an unofficial successor of jekyll-paginate which supports more features.

## Render the paginated Posts

The next thing you need to do is to actually display your posts in a list using
the `paginator` variable that will now be available to you. You’ll probably
want to do this in one of the main pages of your site.

Here’s one example of a
simple way of rendering paginated Posts in a HTML file:

{% raw %}
```liquid
---
layout: default
title: My Blog
---

<!-- This loops through the paginated posts -->
{% for post in paginator.posts %}
  <h1><a href="{{ post.url }}">{{ post.title }}</a></h1>
  <p class="author">
    <span class="date">{{ post.date }}</span>
  </p>
  <div class="content">
    {{ post.content }}
  </div>
{% endfor %}

<!-- Pagination links -->
<div class="pagination">
  {% if paginator.previous_page %}
    <a href="{{ paginator.previous_page_path }}" class="previous">
      Previous
    </a>
  {% else %}
    <span class="previous">Previous</span>
  {% endif %}
  <span class="page_number ">
    Page: {{ paginator.page }} of {{ paginator.total_pages }}
  </span>
  {% if paginator.next_page %}
    <a href="{{ paginator.next_page_path }}" class="next">Next</a>
  {% else %}
    <span class="next ">Next</span>
  {% endif %}
</div>
```
{% endraw %}


Jekyll does not generate a `page1` folder, so the above code will not work
when a `/page1` link is produced. See below for a way to handle
this if it’s a problem for you:

{% raw %}
```liquid
{% if paginator.total_pages > 1 %}
<div class="pagination">
  {% if paginator.previous_page %}
    <a href="{{ paginator.previous_page_path | relative_url }}">
      &laquo; Prev
    </a>
  {% else %}
    <span>&laquo; Prev</span>
  {% endif %}

  {% for page in (1..paginator.total_pages) %}
    {% if page == paginator.page %}
      <em>{{ page }}</em>
    {% elsif page == 1 %}
      <a href="{{ paginator.previous_page_path | relative_url }}">
        {{ page }}
      </a>
    {% else %}
      <a href="{{ site.paginate_path | relative_url | replace: ':num', page }}">
        {{ page }}
      </a>
    {% endif %}
  {% endfor %}

  {% if paginator.next_page %}
    <a href="{{ paginator.next_page_path | relative_url }}">
      Next &raquo;
    </a>
  {% else %}
    <span>Next &raquo;</span>
  {% endif %}
</div>
{% endif %}
```
{% endraw %}
