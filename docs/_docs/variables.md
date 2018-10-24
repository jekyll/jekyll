---
title: Variables
permalink: /docs/variables/
---

Jekyll traverses your site looking for files to process. Any files with
[front matter](/docs/front-matter/) are subject to processing. For each of these
files, Jekyll makes a variety of data available via the [Liquid](/docs/liquid/).
The following is a reference of the available data.

## Global Variables

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
  {% for var in site.data.jekyll_variables.global %}
    <tr>
      <td><p><code>{{ var.name }}</code></p></td>
      <td>
          <p>{{- var.description -}}</p>
      </td>
    </tr>
  {% endfor %}
  </tbody>
</table>
</div>

## Site Variables

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
  {% for var in site.data.jekyll_variables.site %}
    <tr>
      <td><p><code>{{ var.name }}</code></p></td>
      <td>
          <p>{{- var.description -}}</p>
      </td>
    </tr>
  {% endfor %}
  </tbody>
</table>
</div>

## Page Variables

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
  {% for var in site.data.jekyll_variables.page %}
    <tr>
      <td><p><code>{{ var.name }}</code></p></td>
      <td>
          <p>{{- var.description -}}</p>
      </td>
    </tr>
  {% endfor %}
  </tbody>
</table>
</div>

<div class="note">
  <h5>ProTip™: Use Custom Front Matter</h5>
  <p>

    Any custom front matter that you specify will be available under
    <code>page</code>. For example, if you specify <code>custom_css: true</code>
    in a page’s front matter, that value will be available as
    <code>page.custom_css</code>.

  </p>
  <p>

    If you specify front matter in a layout, access that via <code>layout</code>.
    For example, if you specify <code>class: full_page</code>
    in a layout’s front matter, that value will be available as
    <code>layout.class</code> in the layout and its parents.

  </p>
</div>

## Paginator

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Variable</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
  {% for var in site.data.jekyll_variables.paginator %}
    <tr>
      <td><p><code>{{ var.name }}</code></p></td>
      <td><p>{{- var.description -}}</p></td>
    </tr>
  {% endfor %}
  </tbody>
</table>
</div>

<div class="note info">
  <h5>Paginator variable availability</h5>
  <p>

    These are only available in index files, however they can be located in a
    subdirectory, such as <code>/blog/index.html</code>.

  </p>
</div>
