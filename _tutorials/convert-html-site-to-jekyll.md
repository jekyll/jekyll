---
layout: tutorials
permalink: /tutorials/convert-html-site-to-jekyll/
title: Convert an HTML site to Jekyll
---

If you're looking for themes for your Jekyll site, you don't have to restrict yourself to existing Jekyll themes. You can convert almost any static HTML site into a Jekyll theme. Understanding how to convert any HTML site into a Jekyll website will open your world to many more options for Jekyll themes.

Although websites can have sophisticated features and controls, we'll keep things simple in this tutorial. This tutorial contains the following sections:

* TOC
{:toc}

## 1. Understand a basic Jekyll site

First let's start with a grounding in the basics. Stripping a Jekyll site down to an extremely basic level will help clarify what happens in a Jekyll site. If you haven't already installed the jekyll gem, [install it]({% link _docs/installation.md %}).

A simple Jekyll site can consist of just 3 files:

```
├── _config.yaml
├── _layouts
│   └── default.html
└── index.md
```

Create these 3 files in a folder called `myjekyllsite`. (Put `default.html` inside a folder called `_layouts`.) Then populate the content of the files as follows:

**_config.yml**

```yaml
markdown: kramdown
```

**_layouts/default.html**

```html
<html>
  <body>
     {% raw %}{{ content }}{% endraw %}
  </body>
</html>
```

**index.md**

```yaml
---
title: My page
layout: default.html
---

Some **bold** content.
```

Now `cd` to `myjekyllsite` and build the site:

```
jekyll serve
```

This is a Jekyll site at the most basic level. Here's what is happening:

* The `_config.yml` file contains settings that Jekyll uses as it processes your site. This basic config file tells Jekyll to convert Markdown to HTML using the kramdown filter.
* Jekyll looks for files with front matter tags (like those in `index.md`) and [processes the files]({% link _tutorials/orderofinterpretation.md %}) (populating site variables, rendering any Liquid, and converting Markdown to HTML).
* Jekyll pushes the content from all pages and posts into the `{% raw %}{{ content }}{% endraw %}` tags in the layout specified (`default`) in the front matter tags.
* The processed files get written as `.html` files in the `_site` directory.

With this basic foundation of how a Jekyll site works, you can convert almost any HTML theme into a Jekyll site. The following sections will walk you through a step-by-step tutorial on converting an HTML template into a Jekyll site.

## 2. Establish the Default Layout

Find your HTML theme and save it as a default layout. If you're converting or cloning (with permission to do so) an existing site, you can right-click the page and view the source code. Copy and paste the source code into a file called `default.html` inside a folder called `_layouts`. This will be the layout template for your pages and posts.

Note that in looking for templates, you want the HTML output of the template. If the template has PHP tags or other dynamic scripts, these dynamic elements will need to be converted to HTML or stripped out, since Jekyll handles only static content.

Open `default.html` into your browser locally to ensure the site looks and functions like it does online. You will likely need to adjust CSS, JS, and image paths so they work. 

If the paths were relative on the site you copied, you'll need to either download the same assets into your Jekyll site or use absolute paths to the same assets in the cloud. (Note that syntax such as `src="//` requires a prefix such as `src="http://` to work in your local browser.)

Does the local `default.html` page look good in your browser? Are all images, styles, and other elements showing up correctly? Okay, go to the next section and we'll start jekyllizing the site.

## 3. Identify the content part of the layout

In `default.html`, find where the page content begins (usually at `h1` or `h2` tags). Replace the title that appears inside these tags with `{% raw %}{{ page.title }}{% endraw %}`.

Remove the body content from the page (but not content from the top nav, sidebar, or footer) and replace it with `{% raw %}{{ content }}{% endraw %}`.

Check the layout again in your browser and make sure you didn't mess it up by inadvertently removing a crucial `div` tag or other element.

## 4. Create a couple of files with front matter tags

Create a couple of files in your root directory: `index.md` and `about.md`.

In your `index.md` file, add some front matter tags containing a title and layout property, like this:

```yaml
---
title: Home
layout: default
---

Some page content here...
```

Create another page for testing called `about.md` with similar front matter tags as your `index.md` file.

## 5. Add a configuration file

Add a `_config.yml` file in your root directory. In `_config.yml`, specify the markdown filter you want (usually [kramdown](https://kramdown.gettalong.org/)):

```
markdown: kramdown
```

You can also specify [some options](https://kramdown.gettalong.org/converter/html.html) for kramdown to make it behave more like Github-flavored Markdown:

```
kramdown:
 input: GFM
 auto_ids: true
 hard_wrap: false
 syntax_highlighter: rouge
```

## 6. Test your pages

Now run `jekyll serve` and toggle between your `index.html` and `about.html` pages. The layouts should load for both pages. 

You've now extracted your content out into separate files and defined a common layout for pages.

## 7. Configure site variables

You already configured the page title using `{% raw %}{{ page.title }}{% endraw %}` tags. But there are more `title` tags to populate. Pages also have a [`title`](https://moz.com/learn/seo/title-tag) tag that appears in the browser tab window. Typically you put the page title followed by the site title here.

Look for the `title` tags below your `head` tags:

```
<title></title>
```

Insert the following site variables:

```
{% raw %}<title>{{ page.title }} | {{ site.title }}</title>{% endraw %}
```

Open `_config.yml` and add a property for `name`:

```
title: My Awesome site
```

Any properties you add in your `_config.yml` file are accessible through the `site` namespace. Similarly, any properties in your page's front matter are accessible through the `page` namespace.

Stop your Jekyll server (**Ctrl + C**) and restart it. Verify that the `title` tags are populating correctly.

## 8. Show posts on homepage

It's common to show a list of posts on the homepage. First let's create some posts so that our loop will have something to display. 

Add some posts in your `_posts` folder following the standard post format:

* `2017-01-02-my-first-post.md`
* `2017-01-15-my-second-post.md`
* `2017-02-08-my-third-post.md`

In each post, add some basic content:

```
---
title: My First Post
layout: default
---

Some sample content...
```

Create a new file in `_layouts` called `home.html`. In `home.html`, add the following logic:

```
---
layout: default
---

{% raw %}<ul class="myposts">
{% for post in site.posts %}
    <li><a href="{{ post.url }}">{{ post.title}}</a>
    <span class="postDate">{{ post.date | date: "%b %-d, %Y" }}</span>
    </li>
{% endfor %}
</ul>{% endraw %}
```

Open `index.md` in your root directory and specify the `home` layout:

```
---
title: My Awesome Site
layout: home
---
```

When a layout specifies another layout, it means the content of this layout will be stuffed into the `{% raw %}{{ content }}{% endraw %}` tag of the layout specified in the front matter. In this case, the content from `index.md` will be pushed into the `{% raw %}{{ content }}{% endraw %}` tags in the `home` layout. Then the `home` layout will be pushed into the `{% raw %}{{ content }}{% endraw %}` tags of the `default` layout.

(If you don't specify a layout, `default` is used by default. Specifying it in the front matter tags is optional.)

By the way, the we've only scratched the surface of what you can do with `for` loops in retrieving posts. For example, if you want to display posts from a specific category, you can do so by adding a `categories` property to your post's front matter, and then looking in those categories. Further, you can limit the number of results by adding a `limit` property. Here's an example:

```
{% raw %}<ul class="myposts">
{% for post in site.categories.podcasts limit:3 %}
    <li><a href="{{ post.url }}">{{ post.title}}</a>
    <span class="postDate">{{ post.date | date: "%b %-d, %Y" }}</span>
    </li>
{% endfor %}{% endraw %}
```

This loop would get the latest 3 posts that have a category called `podcasts` in the front matter.

## 9. Configure navigation

Now that you've configured posts, let's configure page navigation. Most websites have some navigation either in the sidebar or header area.  

In this tutorial, we'll assume you've got a simple list of pages you want to generate. You can use Jekyll's `for` loop to iterate through a list of pages that you maintain in a separate data file.

Create a folder in your Jekyll project called `_data`. In it, create a file called `sidebar_links.yml` with this content:

```
- title: Sample page 1
  url: /sample1/

- title: Sample page 2
  url: /sample2/

- title: Sample page 3
  url: /sample3/
```

(You can store additional properties for each item in this YAML file as desired .)

Identify the part of your code where the list of pages appears. Usually this is a `<ul>` element with various child `<li>` elements. Replace the code with the following:

```
{% raw %}<ul>
    {% for p in site.data.sidebar_links %}
    <li><a href="{{ p.url }}">{{ p.title }}</a></li>
    {% endfor %}
</ul>{% endraw %}
```

If you have more sophisticated requirements around navigation, see the [detailed tutorial on navigation]({% link _tutorials/navigation.md %}). 


## 10. RSS feed

Your Jekyll site needs an RSS feed. Here's the [basic RSS feed syntax](http://www.w3schools.com/xml/xml_rss.asp). To create an RSS file in Jekyll, create a file called `feed.xml` and add the following:

```xml
---
layout: null
---

{% raw %}<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">

    <channel>
        <title>{{ site.title }}</title>
        <link>{{ site.url }}</link>
        <description>{{ site.description }}</description>
        <lastBuildDate>{{ site.time | date_to_rfc822 }}</lastBuildDate>
        {% for post in site.posts %}
        <item>
            <description>
                {{ post.content | escape | truncate: '400' }}
            </description>
            <pubDate>{{ post.date | date_to_rfc822 }}</pubDate>
            <guid>
                {{ post.url | prepend: site.baseurl | prepend: site.url }}
            </guid>
        </item>
        {% endfor %}
    </channel>
</rss>{% endraw %}
```

Make sure your `_config.yml` file has properties for `title`, `url` (and potentially `baseurl`), and `description`.

This code uses a `for` loop to look through your last 20 posts. The content from the posts gets escaped and truncated to the last 400 characters using [Liquid filters](https://help.shopify.com/themes/liquid/filters).

In your `default.html` layout, look for a reference to the RSS or Atom feed in your header, and replace it with a reference to the file you just created.

```html
<link rel="alternate" type="application/rss+xml"  href="/feed.xml" title="{% raw %}{{ site.title }}{% endraw %}">
```

Note that if you're publishing your site on Github Pages, you can add a Github Pages gem called [`jekyll-feed`][jekyll-feed] to auto-generate your feed.

## 11. Add a sitemap

Finally, add a [site map](https://www.sitemaps.org/protocol.html) in your root directory. Create a `sitemap.xml` file and add this code:

```xml
---
layout: null
search: exclude
---

{% raw %}<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">

    {% for page in site.pages %}
    <url>
        <loc>{{page.url}}</loc>
        <lastmod>{{site.time | date: '%Y-%B-%d' }}</lastmod>
        <changefreq>daily</changefreq>
        <priority>0.5</priority>
    </url>
    {% endfor %}

    {% for post in site.posts %}
    <url>
        <loc>{{post.url}}</loc>
        <lastmod>{{site.time | date: '%Y-%B-%d' }}</lastmod>
        <changefreq>daily</changefreq>
        <priority>0.5</priority>
    </url>
    {% endfor %}
   
</urlset>{% endraw %}
```

Note that if you're publishing your site on Github Pages, you can add a Github Pages gem called [`jekyll-sitemap`][jekyll-sitemap] to auto-generate your sitemap.

## 12. Add external services

For other services you might need (such as contact forms, search, comments, and more) ee this [list of services for static sites](http://jekyll.tips/services/). For example, you might use the following:

* For comments -> [Disqus](https://disqus.com/)
* For a newsletter -> [Tinyletter](https://tinyletter.com/)
* For forms -> [Wufoo](https://www.wufoo.com/)
* For search -> [Algolia Docsearch](https://community.algolia.com/docsearch/)

## 13. Conclusion

Although websites can implement more sophisticated features and functionality, we've covered the basics in this tutorial. You now have a fully functional Jekyll site. 

To deploy your site, consider using [Github Pages](https://pages.github.com/), [Amazon AWS S3](https://aws.amazon.com/s3/) using the [s3_website plugin](https://github.com/laurilehmijoki/s3_website), or just FTP your files to your web server.

You can also take your Jekyll theme to the next level by [packaging it as a Ruby gem](docs/themes/#creating-a-theme). 

## Additional resources

Here are some additional tutorials on creating Jekyll sites: 

* [Convert a static site to Jekyll](http://jekyll.tips/jekyll-casts/converting-a-static-site-to-jekyll/)
* [Building a Jekyll Site – Part 1 of 3: Converting a Static Website To Jekyll](https://css-tricks.com/building-a-jekyll-site-part-1-of-3/)

[jekyll-sitemap]: https://help.github.com/articles/sitemaps-for-github-pages/
[jekyll-feed]: https://help.github.com/articles/atom-rss-feeds-for-github-pages/


