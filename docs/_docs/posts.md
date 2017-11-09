---
title: Writing posts
permalink: /docs/posts/
---

One of Jekyll’s best aspects is that it is “blog aware”. What does this mean,
exactly? Well, simply put, it means that blogging is baked into Jekyll’s
functionality. If you write articles and publish them online, you can publish
and maintain a blog simply by managing a folder of text-files on your computer.
Compared to the hassle of configuring and maintaining databases and web-based
CMS systems, this will be a welcome change!

## The Posts Folder

As explained on the [directory structure](../structure/) page, the `_posts`
folder is where your blog posts will live. These files are generally
[Markdown](https://daringfireball.net/projects/markdown/) or HTML, but can
be other formats with the proper converter installed.
All posts must have [YAML Front Matter](../frontmatter/), and they will be
converted from their source format into an HTML page that is part of your
static site.

### Creating Post Files

To create a new post, all you need to do is create a file in the `_posts`
directory. How you name files in this folder is important. Jekyll requires blog
post files to be named according to the following format:

```
YEAR-MONTH-DAY-title.MARKUP
```

Where `YEAR` is a four-digit number, `MONTH` and `DAY` are both two-digit
numbers, and `MARKUP` is the file extension representing the format used in the
file. For example, the following are examples of valid post filenames:

```
2011-12-31-new-years-eve-is-awesome.md
2012-09-12-how-to-write-a-blog.md
```

<div class="note">
  <h5>ProTip™: Link to other posts</h5>
  <p>
    Use the <a href="../templates/#linking-to-posts"><code>post_url</code></a>
    tag to link to other posts without having to worry about the URLs
    breaking when the site permalink style changes.
  </p>
</div>

### Content Formats

All blog post files must begin with [YAML Front Matter](../frontmatter/). After
that, it's simply a matter of deciding which format you prefer. Jekyll supports
[Markdown](https://daringfireball.net/projects/markdown/) out of the box,
and has [myriad extensions for other formats as well](/docs/plugins/#converters-1),
including the popular [Textile](http://redcloth.org/textile) format. These
formats each have their own way of marking up different types of content
within a post, so you should familiarize yourself with these formats and
decide which one best suits your needs.

<div class="note info">
  <h5>Be aware of character sets</h5>
  <p>
    Content processors can modify certain characters to make them look nicer.
    For example, the <code>smart</code> extension in Redcarpet converts standard,
    ASCII quotation characters to curly, Unicode ones. In order for the browser
    to display those characters properly, define the charset meta value by
    including <code>&lt;meta charset=&quot;utf-8&quot;&gt;</code> in the
    <code>&lt;head&gt;</code> of your layout.
  </p>
</div>

## Including images and resources

Chances are, at some point, you'll want to include images, downloads, or other
digital assets along with your text content. While the syntax for linking to
these resources differs between Markdown and Textile, the problem of working
out where to store these files in your site is something everyone will face.

There are a number of ways to include digital assets in Jekyll.
One common solution is to create a folder in the root of the project directory
called something like `assets`, into which any images, files
or other resources are placed. Then, from within any post, they can be linked
to using the site’s root as the path for the asset to include. Again, this will
depend on the way your site’s (sub)domain and path are configured, but here are
some examples in Markdown of how you could do this using the `absolute_url`
filter in a post.

Including an image asset in a post:

{% raw %}
```markdown
... which is shown in the screenshot below:
![My helpful screenshot]({{ "/assets/screenshot.jpg" | absolute_url }})
```
{% endraw %}

Linking to a PDF for readers to download:

{% raw %}
```markdown
... you can [get the PDF]({{ "/assets/mydoc.pdf" | absolute_url }}) directly.
```
{% endraw %}

<div class="info">

</div>

## A typical post

Jekyll can handle many different iterations of the idea you might associate with a "post," however a standard blog style post, including a Title, Layout, Publishing Date, and Categories might look like this:

```markdown
---
layout: post
title:  "Welcome to Jekyll!"
date:   2015-11-17 16:16:01 -0600
categories: jekyll update
---

You’ll find this post in your `_posts` directory. Go ahead and edit it and re-build the site to see your changes. You can rebuild the site in many different ways, but the most common way is to run `bundle exec jekyll serve`, which launches a web server and auto-regenerates your site when a file is updated.

To add new posts, simply add a file in the `_posts` directory that follows the convention `YYYY-MM-DD-name-of-post.ext` and includes the necessary front matter. Take a look at the source for this post to get an idea about how it works.
```

Everything in between the first and second `---` are part of the YAML Front Matter, and everything after the second `---` will be rendered with Markdown and show up as "Content".

## Displaying an index of posts

It’s all well and good to have posts in a folder, but a blog is no use unless
you have a list of posts somewhere. Creating an index of posts on another page
(or in a [template](../templates/)) is easy, thanks to the [Liquid template
language](https://docs.shopify.com/themes/liquid/basics) and its tags. Here’s a
basic example of how to create a list of links to your blog posts:

{% raw %}
```html
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
```
{% endraw %}

Of course, you have full control over how (and where) you display your posts,
and how you structure your site. You should read more about [how templates
work](../templates/) with Jekyll if you want to know more.

Note that the `post` variable only exists inside the `for` loop above. If
you wish to access the currently-rendering page/posts's variables (the
variables of the post/page that has the `for` loop in it), use the `page`
variable instead.

## Displaying post categories or tags

Hey, that's pretty neat, but what about showing just some of your posts that are
related to each other? For that you can use any of the [variables definable in
Front Matter](https://jekyllrb.com/docs/frontmatter/). In the "typical post"
section you can see how to define categories. Simply add the categories to your
Front Matter as a [yaml
list](https://en.wikipedia.org/wiki/YAML#Basic_components).

Now that your posts have a category or multiple categories, you can make a page
or a template displaying just the posts in those categories you specify. Here's
a basic example of how to create a list of posts from a specific category.

First, in the `_layouts` directory create a new file called `category.html` - in
that file put (at least) the following:

{% raw %}
```liquid
---
layout: page
---

{% for post in site.categories[page.category] %}
    <a href="{{ post.url | absolute_url }}">
      {{ post.title }}
    </a>
{% endfor %}
```
{% endraw %}

Next, in the root directory of your Jekyll install, create a new directory
called `category` and then create a file for each category you want to list. For
example, if you have a category `blog` then create a file in the new directory
called `blog.html` with at least

```yaml
---
layout: category
title: Blog
category: blog
---
```

In this case, the listing pages will be accessible at `{baseurl}/category/blog.html`

While this example is done with categories, you can easily extend your lists to
filter by tags or any other variable created with extensions.

## Post excerpts

Each post automatically takes the first block of text, from the beginning of
the content to the first occurrence of `excerpt_separator`, and sets it as the `post.excerpt`.
Take the above example of an index of posts. Perhaps you want to include
a little hint about the post's content by adding the first paragraph of each of
your posts:

{% raw %}
```liquid
<ul>
  {% for post in site.posts %}
    <li>
      <a href="{{ post.url }}">{{ post.title }}</a>
      {{ post.excerpt }}
    </li>
  {% endfor %}
</ul>
```
{% endraw %}

Because Jekyll grabs the first paragraph you will not need to wrap the excerpt
in `p` tags, which is already done for you. These tags can be removed with the
following if you'd prefer:

{% raw %}
```liquid
{{ post.excerpt | remove: '<p>' | remove: '</p>' }}
```
{% endraw %}

If you don't like the automatically-generated post excerpt, it can be
explicitly overridden by adding an `excerpt` value to your post's YAML
Front Matter. Alternatively, you can choose to define a custom
`excerpt_separator` in the post's YAML front matter:

```yaml
---
excerpt_separator: <!--more-->
---

Excerpt
<!--more-->
Out-of-excerpt
```

You can also set the `excerpt_separator` globally in your `_config.yml`
configuration file.

Completely disable excerpts by setting your `excerpt_separator` to `""`.

Also, as with any output generated by Liquid tags, you can pass the
`| strip_html` filter to remove any html tags in the output. This is
particularly helpful if you wish to output a post excerpt as a
`meta="description"` tag within the post `head`, or anywhere else having
html tags along with the content is not desirable.

## Highlighting code snippets

Jekyll also has built-in support for syntax highlighting of code snippets using
either Pygments or Rouge, and including a code snippet in any post is easy.
Just use the dedicated Liquid tag as follows:

{% raw %}
```liquid
{% highlight ruby %}
def show
  @widget = Widget(params[:id])
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @widget }
  end
end
{% endhighlight %}
```
{% endraw %}

And the output will look like this:

```ruby
def show
  @widget = Widget(params[:id])
  respond_to do |format|
    format.html # show.html.erb
    format.json { render json: @widget }
  end
end
```

<div class="note">
  <h5>ProTip™: Show line numbers</h5>
  <p>
    You can make code snippets include line-numbers by adding the word
    <code>linenos</code> to the end of the opening highlight tag like this:
    <code>{% raw %}{% highlight ruby linenos %}{% endraw %}</code>.
  </p>
</div>

These basics should be enough to get you started writing your first posts. When
you’re ready to dig into what else is possible, you might be interested in
doing things like [customizing post permalinks](../permalinks/) or
using [custom variables](../variables/) in your posts and elsewhere on your
site.
