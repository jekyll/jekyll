---
layout: docs
title: Front-matter
prev_section: configuration
next_section: posts
---

Any files that contain a [YAML](http://yaml.org/) front matter block
will be processed by Jekyll as special files. The front matter must be
the first thing in the file and takes the form of:

{% highlight yaml %}
---
layout: post
title: Blogging Like a Hacker
---
{% endhighlight %}

Between the triple-dashed lines, you can set predefined variables (see
below for a reference) or custom data of your own.

\*IMPORTANT! (Especially for Windows users)\*

When you use `UTF-8` encoding for your file, make sure that
no `BOM` header chars exist in your file or everything will
blow up!

## Predefined Global Variables

Variable                  Description
`layout`                  If set, this specifies the layout file to use. Use the layout file name without file extension. Layout files must be placed in the `_layouts` directory.
`permalink`               If you need your processed URLs to be something other than the default /year/month/day/title.html then you can set this variable and it will be used as the final URL.
`published`               Set to false if you don’t want a post to show up when the site is generated.
`category`/@categories@   Instead of placing posts inside of folders, you can specify one or more categories that the post belongs to. When the site is generated the post will act as though it had been set with these categories normally.<br />Categories (plural key) can be specified as a [YAML list](http://en.wikipedia.org/wiki/YAML#Lists) or a space-separated string.
`tags`                    Similar to categories, one or multiple tags can be added to a post. Also like categories, tags can be specified as a YAML list or a space-separated string.

## Custom Variables

Any variables in the front matter that are not predefined are mixed into
the data that is sent to the Liquid templating engine during the
conversion. For instance, if you set a title, you can use that in your
layout to set the page title:

`<title>{{ "{{ page.title " }}}}</title>`

## Predefined Variables for Post Front-Matter

These are available out-of-the-box to be used in the front-matter for a
post.

Variable   Description
`date`     A date here overrides the date from the name of the post. This can be used to ensure correct sorting of posts.
