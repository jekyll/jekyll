---
layout: docs
title: Templates
prev_section: migrations
next_section: permalinks
permalink: /docs/templates/
---

Jekyll uses the [Liquid](http://wiki.shopify.com/Liquid) templating language to
process templates. All of the [standard Liquid tags and
filters](http://wiki.github.com/shopify/liquid/liquid-for-designers) are
supported, Jekyll even adds a few handy filters and tags of its own to make
common tasks easier.

## Filters

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Description</th>
      <th><span class="filter">Filter</span> and <span class="output">Output</span></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p class='name'><strong>Date to XML Schema</strong></p>
        <p>Convert a Date into XML Schema format.</p>
      </td>
      <td class='align-center'>
        <p>
         <code class='filter'>{% raw %}{{ site.time | date_to_xmlschema }}{% endraw %}</code>
        </p>
        <p>
          <code class='output'>2008-11-17T13:07:54-08:00</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class='name'><strong>Date to String</strong></p>
        <p>Convert a date to short format.</p>
      </td>
      <td class='align-center'>
        <p>
         <code class='filter'>{% raw %}{{ site.time | date_to_string }}{% endraw %}</code>
        </p>
        <p>
          <code class='output'>17 Nov 2008</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class='name'><strong>Date to Long String</strong></p>
        <p>Format a date to long format.</p>
      </td>
      <td class='align-center'>
        <p>
         <code class='filter'>{% raw %}{{ site.time | date_to_long_string }}{% endraw %}</code>
        </p>
        <p>
          <code class='output'>17 November 2008</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class='name'><strong>XML Escape</strong></p>
        <p>Escape some text for use in XML.</p>
      </td>
      <td class='align-center'>
        <p>
         <code class='filter'>{% raw %}{{ page.content | xml_escape }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class='name'><strong>CGI Escape</strong></p>
        <p>
          CGI escape a string for use in a URL. Replaces any special characters
          with appropriate %XX replacements.
        </p>
      </td>
      <td class='align-center'>
        <p>
         <code class='filter'>{% raw %}{{ “foo,bar;baz?” | cgi_escape }}{% endraw %}</code>
        </p>
        <p>
          <code class='output'>foo%2Cbar%3Bbaz%3F</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class='name'><strong>Number of Words</strong></p>
        <p>Count the number of words in some text.</p>
      </td>
      <td class='align-center'>
        <p>
         <code class='filter'>{% raw %}{{ page.content | number_of_words }}{% endraw %}</code>
        </p>
        <p>
          <code class='output'>1337</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class='name'><strong>Array to Sentence</strong></p>
        <p>Convert an array into a sentence. Useful for listing tags.</p>
      </td>
      <td class='align-center'>
        <p>
         <code class='filter'>{% raw %}{{ page.tags | array_to_sentence_string }}{% endraw %}</code>
        </p>
        <p>
          <code class='output'>foo, bar, and baz</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class='name'><strong>Textilize</strong></p>
        <p>Convert a Textile-formatted string into HTML, formatted via RedCloth</p>
      </td>
      <td class='align-center'>
        <p>
         <code class='filter'>{% raw %}{{ page.excerpt | textilize }}{% endraw %}</code>
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p class='name'><strong>Markdownify</strong></p>
        <p>Convert a Markdown-formatted string into HTML.</p>
      </td>
      <td class='align-center'>
        <p>
         <code class='filter'>{% raw %}{{ page.excerpt | markdownify }}{% endraw %}</code>
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Tags

### Includes

If you have small page fragments that you wish to include in multiple places on
your site, you can use the `include` tag.

{% highlight ruby %}
{% raw %}{% include sig.md %}{% endraw %}
{% endhighlight %}

Jekyll expects all include files to be placed in an `_includes` directory at the
root of your source directory. This will embed the contents of
`<source>/_includes/sig.md` into the calling file.

### Code snippet highlighting

Jekyll has built in support for syntax highlighting of [over 100
languages](http://pygments.org/languages/) thanks to
[Pygments](http://pygments.org/). In order to take advantage of this you’ll need
to have Pygments installed, and the `pygmentize` binary must be in your `$PATH`.
When you run Jekyll, make sure you run it with [Pygments enabled](../extras).

To render a code block with syntax highlighting, surround your code as follows:

{% highlight text %}
{% raw %}
{% highlight ruby %}
def foo
  puts 'foo'
end
{% endhighlight %}
{% endraw %}
{% endhighlight %}

The argument to the `highlight` tag (`ruby` in the example above) is the
language identifier. To find the appropriate identifier to use for the language
you want to highlight, look for the “short name” on the [Lexers
page](http://pygments.org/docs/lexers/).

#### Line numbers

There is a second argument to `highlight` called `linenos` that is optional.
Including the `linenos` argument will force the highlighted code to include line
numbers. For instance, the following code block would include line numbers next
to each line:

{% highlight text %}
{% raw %}
{% highlight ruby linenos %}
def foo
  puts 'foo'
end
{% endhighlight %}
{% endraw %}
{% endhighlight %}

#### Stylesheets for syntax highlighting

In order for the highlighting to show up, you’ll need to include a highlighting
stylesheet. For an example stylesheet you can look at
[syntax.css](http://github.com/mojombo/tpw/tree/master/css/syntax.css). These
are the same styles as used by GitHub and you are free to use them for your own
site. If you use `linenos`, you might want to include an additional CSS class
definition for the `.lineno` class in `syntax.css` to distinguish the line
numbers from the highlighted code.

### Post URL

If you would like to include a link to a post on your site, the `post_url` tag
will generate the correct permalink URL for the post you specify.

{% highlight text %}
{% raw %}
{% post_url 2010-07-21-name-of-post %}
{% endraw %}
{% endhighlight %}

There is no need to include the file extension when using the `post_url` tag.

You can also use this tag to create a link to a post in Markdown as follows:

{% highlight text %}
{% raw %}
[Name of Link]({% post_url 2010-07-21-name-of-post %})
{% endraw %}
{% endhighlight %}
