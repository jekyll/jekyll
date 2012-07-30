---
layout: docs
title: Directory structure
prev_section: installation
next_section: configuration
---

Jekyll at its core is a text transformation engine. The concept behind the system is this: you give it text written in your favorite markup language, be that Markdown, Textile, or just plain HTML, and it churns that through a layout or series of layout files. Throughout that process you can tweak how you want the site URLs to look, what data gets displayed on the layout and more. This is all done through strictly editing files, and the web interface is the final product.

A basic Jekyll site usually looks something like this:

{% highlight bash %}
.
|-- _config.yml
|-- _includes
|-- _layouts
|   |-- default.html
|   `-- post.html
|-- _posts
|   |-- 2007-10-29-why-every-programmer-should-play-nethack.textile
|   `-- 2009-04-26-barcamp-boston-4-roundup.textile
|-- _site
`-- index.html
{% endhighlight %}

An overview of what each of these does:

### \_config.yml

Stores [configuration](../configuration) data. A majority of these options can be specified from the command line executable but it's easier to throw them in here so you don't have to remember them.

### \_includes

These are the partials that can be mixed and matched by your _layouts and _posts to facilitate reuse.  The liquid tag `{{ "{% include file.ext " }}%}` can be used to include the partial in `\_includes/file.ext`.

### \_layouts

These are the templates which posts are inserted into. Layouts are chosen on a post-by-post basis in the [YAML front matter](../frontmatter), which is described in the next section. The liquid tag `{{ "{{ content " }}}}` is used to inject data onto the page.


### \_posts

Your dynamic content, so to speak. The format of these files is important, as named as `YEAR-MONTH-DAY-title.MARKUP`. The [permalinks](../permalinks) can be adjusted very flexibly for each post, but the date and markup language are determined solely by the file name.

### \_site

This is where the generated site will be placed once Jekyll is done transforming it. It's probably a good idea to add this to your `.gitignore` file.

### index.html and Other HTML/Markdown/Textile Files

Provided that the file has a [YAML Front Matter](../frontmatter) section, it will be transformed by Jekyll. The same will happen for any `.html`, `.markdown`, `.md`, or `.textile` file in your site's root directory or directories not listed above.

### Other Files/Folders

Every other directory and file except for those listed above will be transferred over as expected. For example, you could have a `css` folder, a `favicon.ico`, etc, etc. There's [plenty of sites](../sites) already using Jekyll if you're curious as to how they're laid out.

Any files in these directories will be parsed and transformed, according to the same rules mentioned previously for files in the root directory.
