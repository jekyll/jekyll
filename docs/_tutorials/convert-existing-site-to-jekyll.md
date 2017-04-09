---
layout: tutorials
permalink: /tutorials/convert-existing-site-to-jekyll/
title: Convert existing site to Jekyll
---

Any static site is *already* a Jekyll site. Jekyll just allows you to automate parts of the site (like inserting pages into templates, rendering lists for navigation, generating feeds and sitemaps, and more) as it processes the files.

Understanding how to convert any HTML site into a Jekyll template will open your world to many more options for Jekyll themes. Instead of searching online for "Jekyll themes," you can choose from the large variety of HTML templates for your site, quickly Jekyll-ize the HTML template as you need to, and build the output with Jekyll.

Although websites can have sophisticated features and controls, we'll keep things simple in this tutorial. This tutorial contains the following sections:

* TOC
{:toc}

In this tutorial we'll reverse-engineer [this site](https://ashmaroli.github.io/reverse-jekyll/) into a Jekyll Project.


## Getting Started

This tutorial requires prior knowledge about HTML, CSS, SASS, and Jekyll Basics. We'll nevertheless touch upon various aspects of Jekyll along the way.

Throughout this tutorial,

  * **Jekyll Project** refers to our working directory &mdash; source directory.
  * **FrontMatter** refers to a section between a pair of triple-dashes `---` at the start of a file.


## Assess the source-code and permissions

Let's study the site's source code first. Right-click anywhere in your site's homepage and select `View Page Source` (or similar), and assess the displayed code. Search through the source-code to see if the site's author has included licence info or similar attribution that we need to make note of.

Proceed when you have the appropriate licence to modify the site for a CMS.


## Initialize the project directory

Lets start defining our workspace by creating a directory for our project. Lets name it **Reverse Engineering**. Then create the following files:

  * A file named `_config.yml`. This is our project's configuration file, in `YAML` format, that Jekyll looks for while building or serving the site.  
  Since the example site is hosted as a project page at Github Pages, all relative paths in the source-code will have the `reverse-jekyll` prepended to it. This will be our project's `baseurl` setting.  
  Open the config file and write `baseurl: /reverse-jekyll` to it.
  * An index file that is required as the landing page for every website out there. Jekyll will be content with either an `index.html` **without FrontMatter** or will process an `index.md` (or `index.html`) **with FrontMatter** into a landing page.

## Layouts in a Jekyll Project

Layouts are essentially HTML files that define the structure of a page in a Jekyll Site. If the generated site is going to be a single-page site, the layout code may be simply written into the `index.md` or `index.html` itself.

A Jekyll Project may therefore contain no layouts, or may have just a single layout or may have multiple layouts. Jekyll looks for layouts in a directory named `_layouts`, by default. This tutorial will use multiple layouts.

{: .note .info}
Layouts themselves are subject to processing by Jekyll when they contain FrontMatter. This allows us to nest a layout within another by using the `layout` key.


### Creating the base layout

We'll start with creating a directory named `_layouts`, and our base layout named `default.html` in it.
Copy and paste the source code into a file called `default.html`.


### Previewing the base layout

Open `default.html` into your browser locally to ensure the site looks and functions like it does online. You will most likely need to adjust paths to various assets so they work as intended.

For example, when the paths are relative on the site you copied, you'll need to either download the same assets into your Jekyll site or use absolute paths to the same assets in the cloud. (Syntax such as `src="//` requires a prefix such as `src="http://` to work in your local browser.)

Does your local `default.html` page look good in your browser? Are all images, styles, and other elements showing up correctly? If so, great. Keep going. You'll use this template as the layout for all your pages in the project.


### Simplifying the base layout with includes

Our base layout can be simplified for better maintainability by extracting sections of code into **includes**.<br />

Includes reside in a dedicated directory (`_includes` by default) and are inserted into place by employing a Liquid tag `{% raw %}{% include <file> %}{% endraw %}`.

We'll simplify our `default.html` by extracting the `<head></head>` into an include named `head.html`.<br />
Begin by creating the `_includes` directory and a `head.html` in it.<br />
Then simply cut the entire `<head></head>` section from `default.html` and paste into `_includes/head.html`.<br />
Where the code chunk previously existed in our base layout, insert the following:

```html
{% raw %}{% include head.html %}{% endraw %}
```

With this our base layout will look like the following:

```html
<!DOCTYPE html>
<html lang="en">
  {% raw %}{% include head.html %}{% endraw %}
  <body>
    [...]
  </body>
</html>
```

You may further simplify the base layout by extracting the site's main header and footer in respective includes.


### Extracting the content part of the base layout

The `<body></body>` section houses the code for everything that is visible via the browser window &mdash; essentially the **"content"** of the layout.<br />
We may thus replace that entire chunk of code with a **Liquid variable** `{% raw %}{{ content }}{% endraw %}`.But its better that we leave the header and footer sections in our base layout and condense just the code between `<main></main>`.

We're now left with a very lean base layout:

```html
<!DOCTYPE html>
<html lang="en">
  {% raw %}{% include head.html %}{% endraw %}
  <body>
    {% raw %}{% include header.html %}{% endraw %}
    <main class="page-content" aria-label="Content">
      {% raw %}{{ content }}{% endraw %}
    </main>
    {% raw %}{% include footer.html %}{% endraw %}
  </body>
</html>
```

The chunk of code we replaced above will be placed into another file. That file may be another layout or our `index.md`. We'll go with the former.


### Creating inherited layouts

We'll create a new layout file at `_layouts/page.html` and paste the chunk of code from the previous step. We'll define FrontMatter for this file to link this file with our base layout:

```html
---
layout: default
---
<div class="wrapper">
  [...]
</div>
```

Now any file with Frontmatter set to use the `page` layout will be processed to contain the code from `default.html` as well.
A similar layout may be created for "posts" especially if their content structure differ from regular "pages"


## Additional pages

Create two additional Markdown documents:
  * A regular page at root: `about.md`
  * A post document...

Posts have a uniquely formatted filename that incorporates the post's date and title:
  * date is incorporated as `YYYY-MM-DD`
  * title is incorporated as its "slugified" version: `welcome-post`

On inspecting the available post's URL, we see the following:

```
https://ashmaroli.github.io/reverse-jekyll/jekyll/update/2017/04/06/welcome-to-jekyll.html
```
For now, we'll focus on string starting from what *could* be the post's date:

```
2017/04/06/welcome-to-jekyll.html
```
Fortunately, the string above is indeed a consolidation of the post's date and title! <br />
So, we'll proceed to create the markdown file for our post in a specially named directory (`_posts`): `_posts/2017-04-06-welcome-to-jekyll.md`


## Pages and FrontMatter

Till now we have been creating the necessary files in our Jekyll Project. Now lets embed some metadata within some of them to be used by Jekyll. This is achieved by using FrontMatter. FrontMatter takes data in the YAML format and is accessed via the `page` namespace.

So our `about.md` would have the following:

```
---
layout: page
title: About
---
```

Earlier in our post's URL, we found an extra string of directories between our "baseurl" and the "consolidated post metadata" :
 `/jekyll/update/`. Yet, we never created those sub-directories within `_posts`.

Fortunately, Jekyll creates directories on-the-run for every `category` item in the post's FrontMatter. With that, our "welcome post" will have the following FrontMatter:

```
---
layout: post
title: Welcome To Jekyll
date: 2017-04-06
categories: jekyll update
---
```

## Replacing data with variables

Following the steps above would have provided you with the following directory structure:

```sh
. # ./reverse-jekyll
├── _config.yml
├── _includes
|   ├── footer.html
|   ├── head.html
|   └── header.html
├── _layouts
|   ├── default.html
|   ├── page.html
|   └── post.html
├── _posts
|   └── 2017-04-06-welcome-to-jekyll.md
├── assets # you may have created this while previewing the base layout
|   └── main.css
├── about.md
└── index.html # or an 'index.md' with valid YAML Frontmatter
```

This is where the real reverse engineering happens and therefore requires a lot of assumptions and is best to follow this route:
  * start defining variables for basic data
  * once all the variables under `site` namespace have been reasonably defined,
  * start a Jekyll server with `jekyll serve`, and
  * proceed with defining variables under `page` namespace.

Start with the base layout. The `<html>` element has an attribute for the site's language. This could be made a global variable under the `site` namespace by defining the attribute in the configuration file:

```yaml
# _config.yml
baseurl: /reverse-jekyll
lang: en
```
The `<html>` element can now be modified as:

```
<!DOCTYPE html>
<html lang="{% raw %}{{ site.lang }}{% endraw %}">
  {% raw %}{% include head.html %}{% endraw %}
  <body>
```

Proceed to `_includes/head.html`

There three things we're concerned about here:
  * the `<title></title>` element
  * the site description metadata that ideally shouldn't exceed 160 characters
  * path references

The `<title>` element can be modified similar to how the `<html>` element was handled earlier.<br />
The path references will be modified by making use of special filters provided by Jekyll:
  * `relative_url` for relative paths, and
  * `absolute_url` for absolute paths

Among the path references, `canonical URL` is of special interest because:
  * its always an "absolute URL" to the "current page"
  * the canonical URL of the landing page will not have "index.html" in it.

FrontMatter data within individual pages can be accessed via the `page` namespace.

With this your `_includes/head.html` will look like the following:

```html
{% raw %}
<head>
  [...]
  <title>{{ site.title }}</title>
  <meta name="description" content="{{ site.description | normalize_whitespace | truncate: 160 }}">
  <link rel="stylesheet" href="{{ 'assets/main.css' | relative_url }}">
  <link rel="canonical" href="{{ page.url | replace:'index.html','' | absolute_url }}">
  <link rel="alternate" type="application/rss+xml" title="{{ site.title | escape }}" href="{{ 'feed.xml' | relative_url }}">
</head>
{% endraw %}
```
and your `_config.yml` be modified to:

```yaml
# _config.yml
baseurl: /reverse-jekyll
lang: en
title: Reverse Jekyll
description: > # ignore newlines till next key
  A demo site to be used to walkthrough developers reverse engineer a
  static site to Jekyll Structure.
```

Proceed similarly to every other "layout" and "include".

{: .note .info}
Every time you modify your config file, you have to restart Jekyll Server for the changes to take effect. When you modify other files, Jekyll automatically picks up the changes when it rebuilds.


## Listing posts on the Index page

On examining the contents of the <body> element on the index page, we see that there's an unordered list consisting of post title linked to a page that displays the entire post content. Additionally, there's a `<span>` element to display the post's date. To replicate that we'll employ a "for loop" that will iterate through a given array and output required data for each entry in the array.

Create a new `home` layout with the following content:

```html
{% raw %}<ul class="post-list">
  {% for post in site.posts %}
  <li>
    <span class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</span>
    <h2>
      <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title | escape }}</a>
    </h2>
  </li>
  {% endfor %}
</ul>{% endraw %}
```

## RSS feed

The source-code for the index page shows that there's a link to the site's feed. This is achieved by using a plugin called [`jekyll-feed`](https://github.com/jekyll/jekyll-feed) and updating the `home` layout with the markup for the link:

```yaml
# _config.yml

# the 'gems' key is an array of all plugins for the site
gems:
  - jekyll-feed
```
<br />

```html
<!-- _layouts/home.html -->{% raw %}
<ul class="post-list">[...]</ul>
<p class="rss-subscribe">subscribe <a href="{{ 'feed.xml' | relative_url }}">via RSS</a></p>{% endraw %}

```


## Conclusion

You should have a functional Jekyll project by now. However, there are still areas that have been deliberately left out of this tutorial and is left to the developers to polish their templates. Notably, Jekyll supports `sass` out-of-the-box. This can be used to break up `main.css` into sass partials that should reside in a sub-directory named `_sass`


## Additional resources

### How layouts work

When a layout specifies another layout, it means the content of the first layout will be stuffed into the `{% raw %}{{ content }}{% endraw %}` tag of the second layout. As an analogy, think of Russian dolls that fit into each other. Each layout fits into another layout that it specifies.

The following diagram shows how layouts work in Jekyll:

<img src="../../img/jekylllayoutconcept.png" alt="Concept of Jekyll layouts" />

{: .image-description}
In this example, the content from a Markdown document `document.md` that specifies `layout: docs` gets pushed into the `{% raw %}{{ content }}{% endraw %}` tag of the layout file `docs.html`. Because the `docs` layout itself specifies `layout: page`, the content from `docs.html` gets pushed into the `{% raw %}{{ content }}{% endraw %}` tag in the layout file `page.html`. Finally because the `page` layout specifies `layout: default`, the content from `page.html` gets pushed into the `{% raw %}{{ content }}{% endraw %}` tag of the layout file `default.html`.

{: .note .info}
At minimum, a layout should contain `{% raw %}{{ content }}{% endraw %}`, which acts as a receiver for the *content* to be rendered.
