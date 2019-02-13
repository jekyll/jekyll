---
title: Static Files
permalink: /docs/static-files/
---
A static file is a file that does not contain any front matter. These
include images, PDFs, and other un-rendered content.

They're accessible in Liquid via `site.static_files` and contain the
following metadata:

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
      <td><p><code>file.path</code></p></td>
      <td><p>

        The relative path to the file, e.g. <code>/assets/img/image.jpg</code>

      </p></td>
    </tr>
    <tr>
      <td><p><code>file.modified_time</code></p></td>
      <td><p>

        The `Time` the file was last modified, e.g. <code>2016-04-01 16:35:26 +0200</code>

      </p></td>
    </tr>
    <tr>
      <td><p><code>file.name</code></p></td>
      <td><p>

        The string name of the file e.g. <code>image.jpg</code> for <code>image.jpg</code>

      </p></td>
    </tr>
    <tr>
      <td><p><code>file.basename</code></p></td>
      <td><p>

        The string basename of the file e.g. <code>image</code> for <code>image.jpg</code>

      </p></td>
    </tr>
    <tr>
      <td><p><code>file.extname</code></p></td>
      <td><p>

        The extension name for the file, e.g.
        <code>.jpg</code> for <code>image.jpg</code>

      </p></td>
    </tr>
  </tbody>
</table>
</div>

Note that in the above table, `file` can be anything. It's an arbitrarily set variable used in your own logic (such as in a for loop). It isn't a global site or page variable.

## Add front matter to static files

Although you can't directly add front matter values to static files, you can set front matter values through the [defaults property](/docs/configuration/front-matter-defaults/) in your configuration file. When Jekyll builds the site, it will use the front matter values you set.

Here's an example:

In your `_config.yml` file, add the following values to the `defaults` property:

```yaml
defaults:
  - scope:
      path: "assets/img"
    values:
      image: true
```

This assumes that your Jekyll site has a folder path of `assets/img` where  you have images (static files) stored. When Jekyll builds the site, it will treat each image as if it had the front matter value of `image: true`.

Suppose you want to list all your image assets as contained in `assets/img`. You could use this for loop to look in the `static_files` object and get all static files that have this front matter property:

{% raw %}
```liquid
{% assign image_files = site.static_files | where: "image", true %}
{% for myimage in image_files %}
  {{ myimage.path }}
{% endfor %}
```
{% endraw %}

When you build your site, the output will list the path to each file that meets this front matter condition.
