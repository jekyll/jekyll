---
title: Static Files
permalink: /docs/static-files/
---

In addition to renderable and convertible content, we also have **static
files**.

A static file is a file that does not contain any YAML front matter. These
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
