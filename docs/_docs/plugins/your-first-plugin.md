---
title: Your first plugin
permalink: /docs/plugins/your-first-plugin/
---

Plugins allow you to extend Jekyll's behavior to fit your needs. There are six
types of plugins in Jekyll.

## Generators

[Generators](/docs/plugins/generators/) create content on your site.
For example:

* [jekyll-feed](https://github.com/jekyll/jekyll-feed) creates an Atom feed of
blog posts.
* [jekyll-archives](https://github.com/jekyll/jekyll-archives) creates archive
pages for blog categories and tags.
* [jekyll-sitemap](https://github.com/jekyll/jekyll-sitemap) creates a sitemap.

## Converters

[Converters](/docs/plugins/converters/) change a markup language into another
format. For example:

* [jekyll-textile-converter](https://github.com/jekyll/jekyll-textile-converter)
converts textile to HTML.
* [jekyll-coffeescript](https://github.com/jekyll/jekyll-coffeescript) converts
Coffeescript to JavaScript.
* [jekyll-opal](https://github.com/jekyll/jekyll-opal) converts Ruby to
JavaScript.

## Commands

[Commands](/docs/plugins/commands/) extend the `jekyll` executable with
subcommands. For example:

* [jekyll-compose](https://github.com/jekyll/jekyll-compose) adds subcommands
for creating a post, page or draft.

## Tags

[Tags](/docs/plugins/tags/) create custom Liquid tags. For example:

* [jekyll-youtube](https://github.com/dommmel/jekyll-youtube) embeds a YouTube
video.
* [jekyll-asset-path-plugin](https://github.com/samrayner/jekyll-asset-path-plugin)
outputs a relative URL for assets.
* [jekyll-swfobject](https://github.com/sectore/jekyll-swfobject) embeds a SWF
object.

## Filters

[Filters](/docs/plugins/filters/) create custom Liquid filters. For example:

* [jekyll-time-ago](https://github.com/markets/jekyll-timeago) - The distance
between two dates in words.
* [jekyll-toc](https://github.com/toshimaru/jekyll-toc) - Generates a table of
content.
* [jekyll-email-protect](https://github.com/vwochnik/jekyll-email-protect) -
Obfuscates emails to protect them from spam bots.

## Hooks

[Hooks](/docs/plugins/hooks/) give fine-grained control to extend the build
process.

## Flags

There are two flags to be aware of when writing a plugin:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Flag</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>safe</code></p>
      </td>
      <td>
        <p>
          A boolean flag that informs Jekyll whether this plugin may be safely
          executed in an environment where arbitrary code execution is not
          allowed. This is used by GitHub Pages to determine which core plugins
          may be used, and which are unsafe to run. If your plugin does not
          allow for arbitrary code execution, set this to <code>true</code>.
          GitHub Pages still won’t load your plugin, but if you submit it for
          inclusion in core, it’s best for this to be correct!
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>priority</code></p>
      </td>
      <td>
        <p>
          This flag determines what order the plugin is loaded in. Valid values
          are: <code>:lowest</code>, <code>:low</code>, <code>:normal</code>,
          <code>:high</code>, and <code>:highest</code>. Highest priority
          matches are applied first, lowest priority are applied last.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

To use one of the example plugins above as an illustration, here is how you’d
specify these two flags:

```ruby
module Jekyll
  class UpcaseConverter < Converter
    safe true
    priority :low
    ...
  end
end
```

## Best Practices

The guides help you with the specifics of creating plugins. We also have some
recommended best practices to help structure your plugin.

We recommend using a [gem](/docs/ruby-101/#gems) for your plugin. This will
help you manage dependencies, keep separation from your site source code and
allow you to share functionality across multiple projects. For tips on creating
a gem take a look a the
[Ruby gems guide](https://guides.rubygems.org/make-your-own-gem/) or look
through the source code of an existing plugin such as
[jekyll-feed](https://github.com/jekyll/jekyll-feed).
