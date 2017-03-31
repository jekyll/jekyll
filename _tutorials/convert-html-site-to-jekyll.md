---
layout: tutorials
permalink: /tutorials/convert-html-site-to-jekyll/
title: Create your first Jekyll theme
---

If you're looking for themes for your Jekyll site, you don't have to restrict yourself to existing Jekyll themes. It's pretty easy to convert almost any static HTML site into a Jekyll theme.

In many ways, any site that is currently a static site *already* is a Jekyll site. Jekyll just allows you to automate parts of the site (like inserting pages into templates, rendering lists for navigation, generating feeds and sitemaps, and more) as it processes the files.

Understanding how to convert any HTML site into a Jekyll website will open your world to many more options for Jekyll themes. Instead of searching online for "Jekyll themes," you can choose from the large variety of HTML templates for your site, quickly Jekyll-ize the files as you want, and build the output with Jekyll.

Although websites can have sophisticated features and controls, we'll keep things simple in this tutorial. This tutorial contains the following sections:

* TOC
{:toc}

## Understand a basic Jekyll site

First, let's start with a grounding in the basics. Stripping a Jekyll site down to an extremely basic level will help clarify what happens in a Jekyll site. If you haven't already installed the jekyll gem, [install it]({% link _docs/installation.md %}).

A simple Jekyll site might consist of just 3 files:

```
├── _config.yaml
├── _layouts
│   └── default.html
└── index.md
```

Create these 3 files in a folder called `myjekyllsite`. (Put `default.html` inside a folder called `_layouts`.) Then populate the content of the files as follows:

**_config.yml**

```
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

When you build the site, you get a preview URL such as `http://127.0.0.1:4001/`. The site's files are built in the `_site` folder.

This is a Jekyll site at the most basic level. Here's what is happening:

* The `_config.yml` file contains settings that Jekyll uses as it processes your site. This basic config file tells Jekyll to convert Markdown to HTML using the [kramdown Markdown filter](https://rubygems.org/gems/kramdown/).
* Jekyll looks for files with [front matter tags]({% link _docs/frontmatter.md %}) (the two sets of dashed lines `---` like those in `index.md`) and processes the files (populating site variables, rendering any [Liquid](https://shopify.github.io/liquid/), and converting Markdown to HTML).
* Jekyll pushes the content from all pages and posts into the `{% raw %}{{ content }}{% endraw %}` tags in the layout specified (`default`) in the front matter tags.
* The processed files get written as `.html` files in the `_site` directory.

You can read more about how Jekyll processes the files in [Order of Interpretation](/tutorials/orderofinterpretation/).

With this basic foundation of how a Jekyll site works, you can convert almost any HTML theme into a Jekyll site. The following sections will take you through a step-by-step tutorial on converting an HTML template into a Jekyll site.

## 1. Create a template for your default layout

Find your HTML theme and save it as a default layout. If you're converting or cloning an existing site, you can right-click the page and view the source code. For example, suppose you're cloning your company site to create a documentation site with the same branding. Or suppose you have a personal site that you built with HTML and now want to make it a Jekyll theme. Get the HTML source code for your site.

Copy and paste the source code into a file called `default.html` inside a folder called `_layouts`. This will be the default layout template for your pages and posts.

Note that in looking for templates, you want the HTML output of the template. If the template has PHP tags or other dynamic scripts, these dynamic elements will need to be converted to HTML or stripped out, since Jekyll handles only static content.

Open `default.html` into your browser locally to ensure the site looks and functions like it does online. You will likely need to adjust CSS, JS, and image paths so they work.

For example, if the paths were relative on the site you copied, you'll need to either download the same assets into your Jekyll site or use absolute paths to the same assets in the cloud. Syntax such as `src="//` requires a prefix such as `src="http://` to work in your local browser.

Does the local `default.html` page look good in your browser? Are all images, styles, and other elements showing up correctly? If so, great. Keep going.

In the next steps, you'll use this template as the layout for all your pages. In the next section, you'll blank out the content of the layout and replace it with placeholder tags that get populated dynamically with your Jekyll pages.

## 2. Identify the content part of the layout

In `default.html`, find where the page content begins (usually at `h1` or `h2` tags). Replace the title that appears inside these tags with `{% raw %}{{ page.title }}{% endraw %}`.

Remove the page content (but not code from the top nav, sidebar, or footer) and replace the page content with `{% raw %}{{ content }}{% endraw %}`.

Check the layout again in your browser and make sure you didn't mess it up by inadvertently removing a crucial `div` tag or other element.

## 3. Create a couple of files with front matter tags

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

(Note: If you don't specify a layout in your pages, the page will use the template labeled `default` by default. But we specify it here to make it explicit what's happening.)

## 4. Add a configuration file

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

## 5. Test your pages

Now run `jekyll serve` and toggle between your `index.html` and `about.html` pages. The layouts should load for both pages.

You've now extracted your content out into separate files and defined a common layout for pages.

You could define any number of layouts you want for pages. Then just identify the layout you want that particular page to use. For example:

```
---
title: Sample page
layout: homepage
---
```

This page would then use the `homepage.html` template in the `_layouts` folder.

You can even set [default front matter tags](/docs/configuration/#front-matter-defaults) for pages, posts, or [collections]({% link _docs/collections.md %}) in your `_config.yml` file so that you don't have to specify the layout in your front matter tags, but that's more advanced than this basic tutorial will cover.

## 6. Configure site variables

You already configured the page title using `{% raw %}{{ page.title }}{% endraw %}` tags. But there are more `title` tags to populate. Pages also have a [`title`](https://moz.com/learn/seo/title-tag) tag that appears in the browser tab or window. Typically you put the page title followed by the site title here.

In your `default.html` layout, look for the `title` tags below your `head` tags:

```
<title></title>
```

Insert the following site variables:

```
{% raw %}<title>{{ page.title }} | {{ site.name }}</title>{% endraw %}
```

Open `_config.yml` and add a `name` property for your site's name.

```
name: My Awesome site
```

Any properties you add in your `_config.yml` file are accessible through the `site` namespace. Similarly, any properties in your page's front matter are accessible through the `page` namespace. Use dot notation after `site` or `page` to access the value.

Stop your Jekyll server (**Ctrl + C**) and restart it. Verify that the `title` tags are populating correctly. (Every time you modify your config file, you have to restart Jekyll for the changes to take effect. When you modify other files, Jekyll automatically picks up the changes when it rebuilds.)

## 7. Show posts on a page

It's common to show a list of posts on the homepage. First, let's create some posts so that our loop will have something to display.

Add some posts in a `_posts` folder following the standard `YYYY-MM-DD-title.md` post format:

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

Now let's create a layout that will display the posts. Create a new file in `_layouts` called `home.html`. In your `home.html` layout, add the following logic:

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

Create a file called `blog.md` in your root directory and specify the `home` layout:

```
---
title: My blog
layout: home
---
```

When a layout specifies another layout, it means the content of this layout will be stuffed into the `{% raw %}{{ content }}{% endraw %}` tag of the layout specified in the front matter. As an analogy, think of Russian dolls that fit into each other. Each layout fits into another layout that it specifies.

```
home --> default
```

In this case, the content from `home.md` will be pushed into the `{% raw %}{{ content }}{% endraw %}` tags in the `home` layout. Then the `home` layout will be pushed into the `{% raw %}{{ content }}{% endraw %}` tags of the `default` layout.

In your browser, go to `home.html` and see the list of posts. (Note that you didn't have to use the method described here. You could have simply added the for loop to any page, such as `index.md`, to display it. But given that you may have more complex logic for other features, it can be helpful to store this logic in templates separate from the page area where you frequently type your content.)

By the way, let's pause here to look at the `for` loop logic a little more closely. [For loops in Liquid](https://help.shopify.com/themes/liquid/tags/iteration-tags#for) are one of the most commonly used Liquid tags to iterate through content in your Jekyll site and build out a result. The `for` loop also has [certain properties available](https://help.shopify.com/themes/liquid/objects/for-loops) based on the loop's position in the iteration as well.

We've only scratched the surface of what you can do with `for` loops in retrieving posts. For example, if you wanted to display posts from a specific category, you could do so by adding a `categories` property to your post's front matter and then looking in those categories. Further, you could limit the number of results by adding a `limit` property. Here's an example:

```liquid
{% raw %}<ul class="myposts">
{% for post in site.categories.podcasts limit:3 %}
    <li><a href="{{ post.url }}">{{ post.title}}</a>
    <span class="postDate">{{ post.date | date: "%b %-d, %Y" }}</span>
    </li>
{% endfor %}{% endraw %}
```

This loop would get the latest 3 posts that have a category called `podcasts` in the front matter.

## 8. Configure navigation

Now that you've configured posts, let's configure page navigation. Most websites have some navigation either in the sidebar or header area.  

In this tutorial, we'll assume you've got a simple list of pages you want to generate. You can use Jekyll's `for` loop to iterate through a list of pages that you maintain in a separate data file.

Create a folder in your Jekyll project called `_data`. In this folder, create a file called `sidebar_links.yml` with this content:

```
- title: Sample page 1
  url: /sample1/

- title: Sample page 2
  url: /sample2/

- title: Sample page 3
  url: /sample3/
```

(You can store additional properties for each item in this YAML file as desired.)

Identify the part of your code where the list of pages appears. Usually this is a `<ul>` element with various child `<li>` elements. Replace the code with the following:

```liquid
{% raw %}<ul>
    {% for p in site.data.sidebar_links %}
    <li><a href="{{ p.url }}">{{ p.title }}</a></li>
    {% endfor %}
</ul>{% endraw %}
```

If you have more sophisticated requirements around navigation, see the [detailed tutorial on navigation](/tutorials/navigation/).

## 9. Simplify your site with includes

Let's suppose your `default.html` file is massive and hard to work with. You can break up your theme by putting some of the content in include files.

Add a folder called `_includes` in your root directory, and add a file there called `sidebar.html`.

From the previous section, copy the `ul` code there and insert it into the `sidebar.html` file.

In place of the `<ul>` list code in `default.html`, add your include like this:

```liquid
{% raw %}{% include sidebar.html %}{% endraw %}
```

You can break up other elements of your theme like this, such as your header or footer. Then you can apply these common elements to other layout files.

## 10. RSS feed

Your Jekyll site needs an RSS feed. Here's the [basic RSS feed syntax](http://www.w3schools.com/xml/xml_rss.asp). To create an RSS file in Jekyll, create a file called `feed.xml` in your root directory and add the following:

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
                {{ post.url | prepend: site.url }}
            </guid>
        </item>
        {% endfor %}
    </channel>
</rss>{% endraw %}
```

Make sure your `_config.yml` file has properties for `title`, `url`, and `description`.

This code uses a `for` loop to look through your last 20 posts. The content from the posts gets escaped and truncated to the last 400 characters using [Liquid filters](https://help.shopify.com/themes/liquid/filters).

In your `default.html` layout, look for a reference to the RSS or Atom feed in your header, and replace it with a reference to the file you just created.

```html
<link rel="alternate" type="application/rss+xml"  href="{% raw %}{{ site.url }}{% endraw %}/feed.xml" title="{% raw %}{{ site.title }}{% endraw %}">
```

Note that if you're publishing your site on Github Pages, you can add a Github Pages gem called [`jekyll-feed`][jekyll-feed] to auto-generate your feed.

## 11. Add a sitemap

Finally, add a [site map](https://www.sitemaps.org/protocol.html). Create a `sitemap.xml` file in your root directory and add this code:

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

Again, we're using a for loop here to iterate through all posts and pages to add them to the sitemap.

Note that if you're publishing your site on Github Pages, you can add a Github Pages gem called [`jekyll-sitemap`][jekyll-sitemap] to auto-generate your sitemap.

## 12. Add external services

For other services you might need (such as contact forms, search, comments, and more) see this [list of services for static sites](http://jekyll.tips/services/). For example, you might use the following:

* For comments: [Disqus](https://disqus.com/)
* For a newsletter: [Tinyletter](https://tinyletter.com/)
* For contact forms: [Wufoo](https://www.wufoo.com/)
* For search: [Algolia Docsearch](https://community.algolia.com/docsearch/)

For more details, see the [Third Parties](https://learn.cloudcannon.com/jekyll-third-parties/) list and tutorials from CloudCannon.

Your Jekyll pages consist of HTML, CSS, and JavaScript, so pretty much any code you need to embed will work flawlessly. If the page doesn't have front matter tags, Jekyll won't process any of the content. The page will just be passed to the `_site` folder when you build your site.

If you do want Jekyll to process some page content (for example, to populate a variable that you define in your site's config file), just add front matter tags to the page. If you don't want the `default` layout applied to the page, specify `layout: null` like this:

```
---
layout: null
---
```

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
