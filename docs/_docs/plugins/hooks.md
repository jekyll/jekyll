---
title: Hooks
permalink: /docs/plugins/hooks/
---

Using hooks, your plugin can exercise fine-grained control over various aspects of the build process. If your plugin defines any hooks, Jekyll
will call them at pre-defined points.

Hooks are registered to an owner and an event name. To register one, you call `Jekyll::Hooks.register`, and pass the hook owner, event name,
and code to call whenever the hook is triggered. For example, if you want to execute some custom functionality every time Jekyll renders a
page, you could register a hook like this:

```ruby
Jekyll::Hooks.register :pages, :post_render do |page|
  # code to call after Jekyll renders a page
end
```

*Note: The `:post_convert` events mentioned hereafter is a feature introduced in v4.2.0.*

Out of the box, Jekyll has pre-defined hook points for owners `:site`, `:pages`, `:documents` and `:clean`. Additionally, the hook points
defined for `:documents` can be utilized for individual collections only by invoking the collection type instead. i.e. `:posts` for documents
in collection `_posts` and `:movies` for documents in collection `_movies`. In all cases, Jekyll calls your hooks with the owner object as the
first callback parameter.

Every registered hook owner supports the following events &mdash; `:post_init`, `:pre_render`, `:post_convert`, `:post_render`, `:post_write`
&mdash; however, the `:site` owner is set up to *respond* to *special event names*. Refer to the subsequent section for details.

All `:pre_render` hooks and the `:site, :post_render` hook will also provide a `payload` hash as a second parameter. While in the case of
`:pre_render` events, the payload gives you full control over the variables that are available during rendering, with the `:site, :post_render`
event, the payload contains final values after rendering all the site (useful for sitemaps, feeds, etc).

## Built-in Hook Owners and Events
The complete list of available hooks:

<div class="mobile-side-scroller">
<table id="builtin-hooks">
  <thead>
    <tr>
      <th>Owner</th>
      <th>Event</th>
      <th>Triggered at</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="6">
        <p><code>:site</code></p>
        <p>Encompasses the entire site</p>
      </td>
      <td>
        <p><code>:after_init</code></p>
      </td>
      <td>
        <p>Just after the site initializes. Good for modifying the configuration of the site. Triggered once per build / serve session</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:after_reset</code></p>
      </td>
      <td>
        <p>Just after the site resets during regeneration</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_read</code></p>
      </td>
      <td>
        <p>After all source files have been read and loaded from disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering the whole site</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering the whole site, but before writing any files</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing all of the rendered files to disk</p>
      </td>
    </tr>
    <tr>
      <td rowspan="5">
        <p><code>:pages</code></p>
        <p>Allows fine-grained control over all pages in the site</p>
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
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a page</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_convert</code></p>
      </td>
      <td>
        <p>After converting the page content, but before rendering the page layout</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a page, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a page to disk</p>
      </td>
    </tr>
    <tr>
      <td rowspan="5">
        <p><code>:documents</code></p>
        <p>Allows fine-grained control over all documents in the site including posts and documents in user-defined collections</p>
      </td>
      <td>
        <p><code>:post_init</code></p>
      </td>
      <td>
        <p>Whenever any document is initialized</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a document</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_convert</code></p>
      </td>
      <td>
        <p>
          After converting the document content, but before rendering the document
          layout
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a document, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a document to disk</p>
      </td>
    </tr>
    <tr>
      <td rowspan="5">
        <p><code>:posts</code></p>
        <p>Allows fine-grained control over all posts in the site without affecting documents in user-defined collections</p>
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
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a post</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_convert</code></p>
      </td>
      <td>
        <p>After converting the post content, but before rendering the postlayout</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a post, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a post to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:clean</code></p>
        <p>Fine-grained control on the list of obsolete files determined to be deleted during the site's cleanup phase.</p>
      </td>
      <td>
        <p><code>:on_obsolete</code></p>
      </td>
      <td>
        <p>During the cleanup of a site's destination before it is built</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Hooks for custom Jekyll objects

You can also register and trigger hooks for Jekyll objects introduced by your plugin. All it takes is placing `trigger` calls under a suitable
`owner` name, at positions desired within your custom class and registering the `owner` by your plugin.

To illustrate, consider the following plugin that implements custom functionality for every custom `Excerpt` object initialized:

```ruby
module Foobar
  class HookedExcerpt < Jekyll::Excerpt
    def initialize(doc)
      super
      trigger_hooks(:post_init)
    end

    def output
      @output ||= trigger_hooks(:post_render, renderer.run)
    end

    def renderer
      @renderer ||= Jekyll::Renderer.new(
        doc.site, self, site.site_payload
      )
    end

    def trigger_hooks(hook_name, *args)
      Jekyll::Hooks.trigger :excerpts, hook_name, self, *args
    end
  end
end

Jekyll::Hooks.register :excerpts, :post_init do |excerpt|
  Jekyll.logger.debug "Initialized:",
                      "Hooked Excerpt for #{excerpt.doc.inspect}"
end

Jekyll::Hooks.register :excerpts, :post_render do |excerpt, output|
  return output unless excerpt.doc.type == :posts
  Foobar.transform(output)
end
```
