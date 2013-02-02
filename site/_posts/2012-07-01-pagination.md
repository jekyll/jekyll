---
layout: docs
title: Pagination
prev_section: permalinks
next_section: plugins
---

With many websites—especially blogs—it’s very common to break the main listing of posts up into smaller lists and display them over multiple pages. Jekyll has pagination built-in, so you can automatically generate the appropriate files and folders you need for paginated post listings.

<div class="note info">
  <h5>Pagination only works within HTML files</h5>
  <p>Pagination does not work with Markdown or Textile files in your Jekyll site. It will only work when used within HTML files. Since you’ll likely be using this for the list of posts, this probably won’t be an issue.</p>
</div>

## Enable pagination

The first thing you need to do to enable pagination for your blog is add a line to the `_config.yml` Jekyll configuration file that specifies how many items should be displayed per page. Here is what the line should look like:

{% highlight yaml %}
paginate: 5
{% endhighlight %}

The number should be the maximum number of posts you’d like to be displayed per-page in the generated site.

## Render the paginated posts

The next thing you need to do is to actually display your posts in a list using the `paginator` variable that will now be available to you. You’ll probably want to do this in one of the main pages of your site. Here’s one example of a simple way of rendering paginated posts in a HTML file:

{% highlight html %}
---
layout: default
title: My Blog
---

<!-- This loops through the paginated posts -->
{{ "{% for post in paginator.posts " }}%}
  <h1><a href="{{ "{{ post.url " }}}}">{{ "{{ post.title " }}}}</a></h1>
  <p class="author">
    <span class="date">{{ "{{post.date" }}}}</span>
  </p>
  <div class="content">
    {{ "{{ post.content " }}}}
  </div>
{{ "{% endfor " }}%}

<!-- Pagination links -->
<div class="pagination">
  {{ "{% if paginator.previous_page " }}%}
    <a href="/page{{ "{{paginator.previous_page" }}}}" class="previous">Previous</a>
  {{ "{% else " }}%}
    <span class="previous">Previous</span>
  {{ "{% endif " }}%}
  <span class="page_number ">Page: {{ "{{paginator.page" }}}} of {{ "{{paginator.total_pages" }}}}</span>
  {{ "{% if paginator.next_page " }}%}
    <a href="/page{{ "{{paginator.next_page" }}}}" class="next ">Next</a>
  {{ "{% else " }}%}
    <span class="next ">Next</span>
  {{ "{% endif " }}%}
</div>
{% endhighlight %}

<div class="note warning">
  <h5>Beware the page one edge-case</h5>
  <p>Jekyll does not generate a ‘page1’ folder, so the above code will not work when a <code>/page1</code> link is produced. See below for a way to handle this if it’s a problem for you.</p>
</div>

The following HTML snippet should handle page one, and render a list of each page with links to all but the current page.

{% highlight html %}
<div id="post-pagination" class="pagination">
  {{ "{% if paginator.previous_page " }}%}
    <p class="previous">
      {{ "{% if paginator.previous_page == 1 " }}%}
        <a href="/">Previous</a>
      {{ "{% else " }}%}
        <a href="/page{{ "{{paginator.previous_page" }}}}">Previous</a>
      {{ "{% endif " }}%}
    </p>
  {{ "{% else " }}%}
    <p class="previous disabled">
      <span>Previous</span>
    </p>
  {{ "{% endif " }}%}

  <ul class="pages">
    <li class="page">
      {{ "{% if paginator.page == 1 " }}%}
        <span class="current-page">1</span>
      {{ "{% else " }}%}
        <a href="/">1</a>
      {{ "{% endif " }}%}
    </li>

    {{ "{% for count in (2..paginator.total_pages) " }}%}
      <li class="page">
        {{ "{% if count == paginator.page " }}%}
          <span class="current-page">{{ "{{count" }}}}</span>
        {{ "{% else " }}%}
          <a href="/page{{ "{{count" }}}}">{{ "{{count" }}}}</a>
        {{ "{% endif " }}%}
      </li>
    {{ "{% endfor " }}%}
  </ul>

  {{ "{% if paginator.next_page " }}%}
    <p class="next">
      <a href="/page{{ "{{paginator.next_page" }}}}">Next</a>
    </p>
  {{ "{% else " }}%}
    <p class="next disabled">
      <span>Next</span>
    </p>
  {{ "{% endif " }}%}

</div>
{% endhighlight %}
