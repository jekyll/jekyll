---
layout: docs
title: Directory structure
prev_section: usage
next_section: configuration
---

Jekyll at its core is a text transformation engine. The concept behind the system is this: you give it text written in your favorite markup language, be that Markdown, Textile, or just plain HTML, and it churns that through a layout or series of layout files. Throughout that process you can tweak how you want the site URLs to look, what data gets displayed on the layout and more. This is all done through strictly editing files, and the web interface is the final product.

A basic Jekyll site usually looks something like this:

{% highlight bash %}
.
├── _config.yml
├── _includes
|   ├── footer.html
|   └── header.html
├── _layouts
|   ├── default.html
|   └── post.html
├── _posts
|   ├── 2007-10-29-why-every-programmer-should-play-nethack.textile
|   └── 2009-04-26-barcamp-boston-4-roundup.textile
├── _site
└── index.html
{% endhighlight %}

An overview of what each of these does:

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
        <p>Stores <a href="../configuration">configuration</a> data. A majority of these options can be specified from the command line executable but it’s easier to throw them in here so you don’t have to remember them.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>_includes</code></p>
      </td>
      <td>
        <p>These are the partials that can be mixed and matched by your _layouts and _posts to facilitate reuse.  The liquid tag <code>{{ "{% include file.ext " }}%}</code> can be used to include the partial in <code>_includes/file.ext</code>.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>_layouts</code></p>
      </td>
      <td>
        <p>These are the templates which posts are inserted into. Layouts are chosen on a post-by-post basis in the <a href="../frontmatter">YAML front matter</a>, which is described in the next section. The liquid tag <code>{{ "{{ content " }}}}</code> is used to inject data onto the page.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>_posts</code></p>
      </td>
      <td>
        <p>Your dynamic content, so to speak. The format of these files is important, as named as <code>YEAR-MONTH-DAY-title.MARKUP</code>. The <a href="../permalinks">permalinks</a> can be adjusted very flexibly for each post, but the date and markup language are determined solely by the file name.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>_site</code></p>
      </td>
      <td>
        <p>This is where the generated site will be placed once Jekyll is done transforming it. It's probably a good idea to add this to your <code>.gitignore</code> file.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>index.html</code> and other HTML, Markdown, Textile files</p>
      </td>
      <td>
        <p>Provided that the file has a <a href="../frontmatter">YAML Front Matter</a> section, it will be transformed by Jekyll. The same will happen for any <code>.html</code>, <code>.markdown</code>, <code>.md</code>, or <code>.textile</code> file in your site's root directory or directories not listed above.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p>Other Files/Folders</p>
      </td>
      <td>
        <p>Every other directory and file except for those listed above—such as <code>css</code> and <code>images</code> folders, <code>favicon.ico</code> files, and so forth—will be transferred over verbatim to the generated site. There's plenty of <a href="../sites">sites already using Jekyll</a> if you're curious as to how they're laid out.</p>
      </td>
    </tr>
  </tbody>
</table>
