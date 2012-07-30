---
layout: docs
title: Templates
prev_section: migrations
next_section: assets
---

Jekyll uses [Liquid](http://www.liquidmarkup.org/) to process templates.
Along with the [standard liquid tags and
filters](http://wiki.github.com/shopify/liquid/liquid-for-designers),
Jekyll adds a few of its own:

Filters
-------

### Date to XML Schema

Convert a Time into XML Schema format.

`{{ "{{ site.time | date\_to\_xmlschema " }}}}`
`2008-11-17T13:07:54-08:00`

### Date to String

Convert a date in short format, e.g. “27 Jan 2011”.

`{{ "{{ site.time | date\_to\_string " }}}}`
`17 Nov 2008`

### Date to Long String

Format a date in long format e.g. “27 January 2011”.

`{{ "{{ site.time | date\_to\_long\_string " }}}}`
`17 November 2008`

### XML Escape

Escape some text for use in XML.

`{{ "{{ page.content | xml\_escape " }}}}`

### CGI Escape

CGI escape a string for use in a URL. Replaces any special characters
with appropriate %XX replacements.

`{{ "{{ “foo,bar;baz?” | cgi\_escape " }}}}`
 `foo%2Cbar%3Bbaz%3F`

### Number of Words

Count the number of words in some text.

`{{ "{{ page.content | number\_of\_words " }}}}`
 `1337`

### Array to Sentence

Convert an array into a sentence.

`{{ "{{ page.tags | array\_to\_sentence\_string " }}}}`
`foo, bar, and baz`

### Textilize

Convert a Textile-formatted string into HTML, formatted via RedCloth

`{{ "{{ page.excerpt | textilize " }}}}`

### Markdownify

Convert a Markdown-formatted string into HTML.

`{{ "{{ page.excerpt | markdownify " }}}}`

Tags
----

### Include

If you have small page fragments that you wish to include in multiple
places\
on your site, you can use the `include` tag.

    {{ "{% include sig.textile " }}}%

Jekyll expects all include files to be placed in an `_includes`
directory at the root of your source dir. So this will embed the
contents of `/path/to/proto/site/_includes/sig.textile` into the calling
file.

### Code Highlighting

Jekyll has built in support for syntax highlighting of over [100
languages](http://pygments.org/languages/) via
[Pygments](http://pygments.org/). In order to take advantage of this
you’ll need to have Pygments installed, and the pygmentize binary must
be in your path. When you run Jekyll, make sure you run it with
[Pygments support](../configuration)

To denote a code block that should be highlighted:

    {{ "{% highlight ruby " }}}%
    def foo
      puts 'foo'
    end
    {{ "{% endhighlight " }}}%

The argument to `highlight` is the language identifier. To find the
appropriate identifier to use for your favorite language, look for the
“short name” on the [Lexers](http://pygments.org/docs/lexers/) page.

#### Line number

There is a second argument to `highlight` called `linenos` that is
optional. Including the `linenos` argument will force the highlighted
code to include line numbers. For instance, the following code block
would include line numbers next to each line:

    {{ "{% highlight ruby linenos " }}}%
    def foo
      puts 'foo'
    end
    {{ "{% endhighlight " }}}%

In order for the highlighting to show up, you’ll need to include a
highlighting stylesheet. For an example stylesheet you can look at
[syntax.css](http://github.com/mojombo/tpw/tree/master/css/syntax.css).
These are the same styles as used by GitHub and you are free to use them
for your own site. If you use linenos, you might want to include an
additional CSS class definition for `lineno` in syntax.css to
distinguish the line numbers from the highlighted code.

### Post Url

If you would like to include a link to a post on your site, you can use
the `post\_url` tag.

    {{ "{% post_url 2010-07-21-name-of-post " }}}%

There is no need to include the extension.

To create a link, do:

    [Name of Link]({{ "{% post_url 2010-07-21-name-of-post " }}}%)


## Markup Problems

The various markup engines that Jekyll uses may have some issues. This
page will document them to help others who may run into the same
problems.

Maruku
------

If your link has characters that need to be escaped, you need to use
this syntax:

`![Alt text](http://yuml.me/diagram/class/[Project]->[Task])`

If you have an empty tag, i.e. `<script src="js.js"></script>`, Maruku
transforms this into `<script src="js.js" />`. This causes problems in
Firefox and possibly other browsers and is [discouraged in
XHTML.](http://www.w3.org/TR/xhtml1/#C_3) An easy fix is to put a space
between the opening and closing tags.

RedCloth
--------

Versions 4.1.1 and higher do not obey the notextile tag. [This is a
known
bug](http://aaronqian.com/articles/2009/04/07/redcloth-ate-my-notextile.html)
and will hopefully be fixed for 4.2. You can still use 4.1.9, but the
test suite requires that 4.1.0 be installed. If you use a version of
RedCloth that does not have the notextile tag, you may notice that
syntax highlighted blocks from Pygments are not formatted correctly,
among other things. If you’re seeing this just install 4.1.0.

Liquid
------

The latest version, version 2.0, seems to break the use of {{ "{{" }} in
templates. Unlike previous versions, using {{ "{{" }} in 2.0 gives me:
`'{{ "{{" }}' was not properly terminated with regexp: /\}\}/  (Liquid::SyntaxError)`


