---
layout: docs
title: Directory structure
permalink: /docs/structure/
---

Jekyll is, at its core, a text transformation engine. The concept behind the
system is this: you give it text written in your favorite markup language, be
that Markdown, Textile, or just plain HTML, and it churns that through a layout
or series of layout files. Throughout that process you can tweak how you want
the site URLs to look, what data gets displayed in the layout, and more. This
is all done through editing text files, and the static web site is the final
product.

A basic Jekyll site usually looks something like this:

{% highlight bash %}
.
├── _config.yml
├── _drafts
|   ├── begin-with-the-crazy-ideas.textile
|   └── on-simplicity-in-technology.markdown
├── _includes
|   ├── footer.html
|   └── header.html
├── _layouts
|   ├── default.html
|   └── post.html
├── _posts
|   ├── 2007-10-29-why-every-programmer-should-play-nethack.textile
|   └── 2009-04-26-barcamp-boston-4-roundup.textile
├── _data
|   └── members.yml
├── _site
├── .jekyll-metadata
└── index.html
{% endhighlight %}

An overview of what each of these does:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>File / Directory</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>_config.yml</code></p>
      </td>
      <td>
        <p>

          Stores <a href="../configuration/">configuration</a> data. Many of
          these options can be specified from the command line executable but
          it’s easier to specify them here so you don’t have to remember them.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>_drafts</code></p>
      </td>
      <td>
        <p>

          Drafts are unpublished posts. The format of these files is without a
          date: <code>title.MARKUP</code>. Learn how to <a href="../drafts/">
          work with drafts</a>.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>_includes</code></p>
      </td>
      <td>
        <p>

          These are the partials that can be mixed and matched by your layouts
          and posts to facilitate reuse. The liquid tag
          <code>{% raw %}{% include file.ext %}{% endraw %}</code>
          can be used to include the partial in
          <code>_includes/file.ext</code>.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>_layouts</code></p>
      </td>
      <td>
        <p>

          These are the templates that wrap posts. Layouts are chosen on a
          post-by-post basis in the
          <a href="../frontmatter/">YAML Front Matter</a>,
          which is described in the next section. The liquid tag
          <code>{% raw %}{{ content }}{% endraw %}</code>
          is used to inject content into the web page.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>_posts</code></p>
      </td>
      <td>
        <p>

          Your dynamic content, so to speak. The naming convention of these
          files is important, and must follow the format:
          <code>YEAR-MONTH-DAY-title.MARKUP</code>.
          The <a href="../permalinks/">permalinks</a> can be customized for
          each post, but the date and markup language are determined solely by
          the file name.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>_data</code></p>
      </td>
      <td>
        <p>

          Well-formatted site data should be placed here. The jekyll engine
          will autoload all YAML files in this directory (using either the
          <code>.yml</code>, <code>.yaml</code>, <code>.json</code> or
          <code>.csv</code> formats and extensions) and they will be
          accessible via `site.data`. If there's a file
          <code>members.yml</code> under the directory, then you can access
          contents of the file through <code>site.data.members</code>.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>_site</code></p>
      </td>
      <td>
        <p>

          This is where the generated site will be placed (by default) once
          Jekyll is done transforming it. It’s probably a good idea to add this
          to your <code>.gitignore</code> file.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>.jekyll-metadata</code></p>
      </td>
      <td>
        <p>

          This helps Jekyll keep track of which files have not been modified
          since the site was last built, and which files will need to be
          regenerated on the next build. This file will not be included in the
          generated site. It’s probably a good idea to add this to your
          <code>.gitignore</code> file.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>index.html</code> and other HTML, Markdown, Textile files</p>
      </td>
      <td>
        <p>

          Provided that the file has a <a href="../frontmatter/">YAML Front
          Matter</a> section, it will be transformed by Jekyll. The same will
          happen for any <code>.html</code>, <code>.markdown</code>,
          <code>.md</code>, or <code>.textile</code> file in your site’s root
          directory or directories not listed above.

        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Other Files/Folders</p>
      </td>
      <td>
        <p>

          Every other directory and file except for those listed above—such as
          <code>css</code> and <code>images</code> folders,
          <code>favicon.ico</code> files, and so forth—will be copied verbatim
          to the generated site. There are plenty of <a href="../sites/">sites
          already using Jekyll</a> if you’re curious to see how they’re laid
          out.

        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>
