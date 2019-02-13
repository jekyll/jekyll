---
title: Hooks
permalink: /docs/plugins/hooks/
---

Using hooks, your plugin can exercise fine-grained control over various aspects
of the build process. If your plugin defines any hooks, Jekyll will call them
at pre-defined points.

Hooks are registered to a container and an event name. To register one, you
call Jekyll::Hooks.register, and pass the container, event name, and code to
call whenever the hook is triggered. For example, if you want to execute some
custom functionality every time Jekyll renders a post, you could register a
hook like this:

```ruby
Jekyll::Hooks.register :posts, :post_render do |post|
  # code to call after Jekyll renders a post
end
```

Jekyll provides hooks for <code>:site</code>, <code>:pages</code>,
<code>:posts</code>, and <code>:documents</code>. In all cases, Jekyll calls
your hooks with the container object as the first callback parameter.
All `:pre_render` hooks and the`:site, :post_render` hook will also provide a
payload hash as a second parameter. In the case of `:pre_render`, the payload
gives you full control over the variables that are available while rendering.
In the case of `:site, :post_render`, the payload contains final values after
rendering all the site (useful for sitemaps, feeds, etc).

The complete list of available hooks is below:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Container</th>
      <th>Event</th>
      <th>Called</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:after_init</code></p>
      </td>
      <td>
        <p>Just after the site initializes, but before setup & render. Good
        for modifying the configuration of the site.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:after_reset</code></p>
      </td>
      <td>
        <p>Just after site reset</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:post_read</code></p>
      </td>
      <td>
        <p>After site data has been read and loaded from disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering the whole site</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering the whole site, but before writing any files</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing the whole site to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:post_init</code></p>
      </td>
      <td>
        <p>Whenever a page is initialized</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a page</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a page, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a page to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:post_init</code></p>
      </td>
      <td>
        <p>Whenever a post is initialized</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a post</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a post, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a post to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:post_init</code></p>
      </td>
      <td>
        <p>Whenever a document is initialized</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a document</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a document, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a document to disk</p>
      </td>
    </tr>
  </tbody>
</table>
</div>
