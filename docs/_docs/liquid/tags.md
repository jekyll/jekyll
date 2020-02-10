---
title: Tags Filters
permalink: "/docs/liquid/tags/"
---
All of the standard Liquid
[tags](https://shopify.github.io/liquid/tags/control-flow/) are supported.
Jekyll has a few built in tags to help you build your site. You can also create
your own tags using [plugins](/docs/plugins/).

## Includes

If you have page snippets that you use repeatedly across your site, an
[include](/docs/includes/) is the perfect way to make this more maintainable.

## Code snippet highlighting

Jekyll has built in support for syntax highlighting of over 100 languages
thanks to [Rouge](http://rouge.jneen.net). Rouge is the default highlighter
in Jekyll 3 and above.

<div class="note warning">
  <p>Using Pygments has been deprecated and is not supported in
  Jekyll 4, the configuration setting <code>highlighter: pygments</code>
  now automatically falls back to using <em>Rouge</em> which is written in Ruby
  and 100% compatible with stylesheets for Pygments.</p>
</div>

To render a code block with syntax highlighting, surround your code as follows:

{% raw %}
```liquid
{% highlight ruby %}
def foo
  puts 'foo'
end
{% endhighlight %}
```
{% endraw %}

The argument to the `highlight` tag (`ruby` in the example above) is the
language identifier. To find the appropriate identifier to use for the language
you want to highlight, look for the “short name” on the [Rouge
wiki](https://github.com/jayferd/rouge/wiki/List-of-supported-languages-and-lexers).

<div class="note">
  <h5>Jekyll processes all Liquid filters in code blocks</h5>
  <p>If you are using a language that contains curly braces, you
    will likely need to place <code>{&#37; raw &#37;}</code> and
    <code>{&#37; endraw &#37;}</code> tags around your code.
    Since {% include docs_version_badge.html version="4.0" %} you can add <code>render_with_liquid: false</code> in your front matter to disable Liquid entirely for a particular document.</p>
</div>

### Line numbers

There is a second argument to `highlight` called `linenos` that is optional.
Including the `linenos` argument will force the highlighted code to include line
numbers. For instance, the following code block would include line numbers next
to each line:

{% raw %}
```liquid
{% highlight ruby linenos %}
def foo
  puts 'foo'
end
{% endhighlight %}
```
{% endraw %}

### Stylesheets for syntax highlighting

In order for the highlighting to show up, you’ll need to include a highlighting
stylesheet. For Pygments or Rouge you can use a stylesheet for Pygments, you
can find an example gallery 
[here](https://jwarby.github.io/jekyll-pygments-themes/languages/ruby.html) 
or from [its repository](https://github.com/jwarby/jekyll-pygments-themes).

Copy the CSS file (`native.css` for example) into your css directory and import
the syntax highlighter styles into your `main.css`:

```css
@import "native.css";
```

## Links

{: .note }
Since Jekyll {% include docs_version_badge.html version="v4.0"%} you don't need to prepend `link` and `post_url` tags with `site.baseurl`

### Linking to pages {#link}

To link to a post, a page, collection item, or file, the `link` tag will generate the correct permalink URL for the path you specify. For example, if you use the `link` tag to link to `mypage.html`, even if you change your permalink style to include the file extension or omit it, the URL formed by the `link` tag will always be valid.

You must include the file's original extension when using the `link` tag. Here are some examples:

{% raw %}
```liquid
{% link _collection/name-of-document.md %}
{% link _posts/2016-07-26-name-of-post.md %}
{% link news/index.html %}
{% link /assets/files/doc.pdf %}
```
{% endraw %}

You can also use the `link` tag to create a link in Markdown as follows:

{% raw %}
```liquid
[Link to a document]({% link _collection/name-of-document.md %})
[Link to a post]({% link _posts/2016-07-26-name-of-post.md %})
[Link to a page]({% link news/index.html %})
[Link to a file]({% link /assets/files/doc.pdf %})
```
{% endraw %}

The path to the post, page, or collection is defined as the path relative to the root directory (where your config file is) to the file, not the path from your existing page to the other page.

For example, suppose you're creating a link in `page_a.md` (stored in `pages/folder1/folder2`) to `page_b.md` (stored in  `pages/folder1`). Your path in the link would not be `../page_b.html`. Instead, it would be `/pages/folder1/page_b.md`.

If you're unsure of the path, add `{% raw %}{{ page.path }}{% endraw %}` to the page and it will display the path.

One major benefit of using the `link` or `post_url` tag is link validation. If the link doesn't exist, Jekyll won't build your site. This is a good thing, as it will alert you to a broken link so you can fix it (rather than allowing you to build and deploy a site with broken links).

Note you cannot add filters to `link` tags. For example, you cannot append a string using Liquid filters, such as `{% raw %}{% link mypage.html | append: "#section1" %} {% endraw %}`. To link to sections on a page, you will need to use regular HTML or Markdown linking techniques.

### Linking to posts

If you want to include a link to a post on your site, the `post_url` tag will generate the correct permalink URL for the post you specify.

{% raw %}
```liquid
{% post_url 2010-07-21-name-of-post %}
```
{% endraw %}

If you organize your posts in subdirectories, you need to include subdirectory path to the post:

{% raw %}
```liquid
{% post_url /subdir/2010-07-21-name-of-post %}
```
{% endraw %}

There is no need to include the file extension when using the `post_url` tag.

You can also use this tag to create a link to a post in Markdown as follows:

{% raw %}
```liquid
[Name of Link]({% post_url 2010-07-21-name-of-post %})
```
{% endraw %}
