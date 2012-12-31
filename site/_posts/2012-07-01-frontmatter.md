---
layout: docs
title: Front-matter
prev_section: configuration
next_section: posts
---

The front-matter is where Jekyll starts to get really cool. Any files that contain a [YAML](http://yaml.org/) front matter block will be processed by Jekyll as special files. The front matter must be the first thing in the file and must take the form of sets of variables and values set between triple-dashed lines. Here is a basic example:

{% highlight yaml %}
---
layout: post
title: Blogging Like a Hacker
---
{% endhighlight %}

Between these triple-dashed lines, you can set predefined variables (see below for a reference) or even create custom ones of your own. These variables will then be available to you to access using Liquid tags both further down in the file and also in any layouts or includes that the page or post in question relies on.

<div class="note warning">
  <h5>UTF-8 Character Encoding Warning</h5>
  <p>If you use UTF-8 encoding, make sure that no <code>BOM</code> header characters exist in your files or very, very bad things will happen to Jekyll. This is especially relevant if you’re running Jekyll on Windows.</p>
</div>

## Predefined Global Variables

There are a number of predefined global variables that you can set in the front-matter of a page or post.

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
        <p><code>layout</code></p>
      </td>
      <td>
        <p>If set, this specifies the layout file to use. Use the layout file name without file extension. Layout files must be placed in the <code>_layouts</code> directory.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>permalink</code></p>
      </td>
      <td>
        <p>If you need your processed URLs to be something other than the default <code>/year/month/day/title.html</code> then you can set this variable and it will be used as the final URL.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>published</code></p>
      </td>
      <td>
        <p>Set to false if you don’t want a post to show up when the site is generated.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p style="margin-bottom: 5px;"><code>category</code></p>
        <p><code>categories</code></p>
      </td>
      <td>
        <p>Instead of placing posts inside of folders, you can specify one or more categories that the post belongs to. When the site is generated the post will act as though it had been set with these categories normally. Categories (plural key) can be specified as a <a href="http://en.wikipedia.org/wiki/YAML#Lists">YAML list</a> or a space-separated string.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>tags</code></p>
      </td>
      <td>
        <p>Similar to categories, one or multiple tags can be added to a post. Also like categories, tags can be specified as a YAML list or a space-separated string.</p>
      </td>
    </tr>
  </tbody>
</table>


## Custom Variables

Any variables in the front matter that are not predefined are mixed into
the data that is sent to the Liquid templating engine during the
conversion. For instance, if you set a title, you can use that in your
layout to set the page title:

{% highlight html %}
<!DOCTYPE HTML>
<html>
  <head>
    <title>{{ "{{ page.title " }}}}</title>
  </head>
  <body>
    ...
{% endhighlight %}

## Predefined Variables for Posts

These are available out-of-the-box to be used in the front-matter for a
post.

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
        <p><code>date</code></p>
      </td>
      <td>
        <p>A date here overrides the date from the name of the post. This can be used to ensure correct sorting of posts.</p>
      </td>
    </tr>
  </tbody>
</table>
