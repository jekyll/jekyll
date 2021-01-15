---
title: Read-Only JSON API
author: izdwuut
date: 2020-12-23 10:04:00 +0100
plugin_disclaimer: true
---

In this tutorial, you'll create a kind of a [REST](https://restfulapi.net/) [API](https://en.wikipedia.org/wiki/API) serving
static [JSON](https://www.json.org/json-en.html) files generated from Markdown posts in your Jekyll site.

JSON is a popular format to structure and exchange data on the web, without the presentation layer of HTML. The files you
output are similar to a REST API in a server-side language like Ruby, Python, or Node. You can access them directly in your
browser from e.g. `/foo.json`. They can be used to build a custom frontend using Angular, React, Vue, and so on.

A huge inspiration to write this tutorial was a [post](https://forestry.io/blog/build-a-json-api-with-hugo/) written by
[Régis Philibert](https://twitter.com/regisphilibert). It's about doing the exact same thing in [Hugo](https://gohugo.io/).

You will need to define a number of [layouts]({% link _docs/layouts.md %}) and write a [plugin]({% link _docs/plugins.md %})
to convert your content to JSON. **Don't be afraid if you're not familiar with Ruby** --- the language that Jekyll is
written in --- it can be learned quite quickly.

By the end of the tutorial, you'll expose the following API endpoints:
* `/` --- an index of all posts
* `/{url}` --- details of a post
* `/categories` --- an index of categories
* `/categories/{category}` --- an index of posts under a category

Let's dive in!

{: .note .info}
This solution needs a custom environment to support its Ruby code. This means that you can't host the site on GitHub Pages
using your source files alone --- you'd need to host your static files, too. To achieve that, you can use
[GitHub Actions]({% link _docs/continuous-integration/github-actions.md %}) to deploy your site. First, see if a simpler
[solution](https://gist.github.com/MichaelCurrin/f8d908596276bdbb2044f04c352cb7c7) created by
[Michael Currin](https://github.com/MichaelCurrin) fits your needs.

{: .note .info}
This tutorial comes with [a repository](https://github.com/izdwuut/jekyll-json-api-tutorial). It contains the full project
(`main` branch), a deployed version of the site (`gh-pages` branch), and the tutorial barebones (`tutorial` branch). The
repository includes a GitHub Action workflow that builds the site on every push to the default branch.

## Setup

Here you will prepare the project for adding custom Ruby code later on.

### Installation

Once you have a working [installation]({% link _docs/installation.md %}) of Jekyll, choose one of the following options:
* Clone the aforementioned [repository](https://github.com/izdwuut/jekyll-json-api-tutorial). Then create or check out to
a branch named `tutorial` and pull in the contents of the remote `tutorial` branch. Finally install necessary dependencies
by running `bundler install`.
* Initialize a new Jekyll project by invoking the command `bundle exec jekyll new` and create the directory structure
manually, mirroring the structure in the `tutorial` branch of the repository.

Unless you self-host your site, **you can rely on a generic 404 response from your server**. You no longer need `index.html`
 --- you will generate a custom one later. Generating pages like `about.html` is out of scope for this tutorial, but in case
you need them, they behave the same way that posts do.

### Dummy Posts

Under `_posts`, create two new documents. Remember that Jekyll requires you to **prepend post filenames with a date**:

`2020–12–20-the-first-post.md`

```md
---
title:  "The First Post"
category: update
custom-property: "My custom property"
---
1
```

Make sure to include a `custom-property` so that you can fetch it later on. 

`2020–12–20-the-second-post.md`

```md
---
title:  "The Second Post"
categories: ["update", "tutorial"]
---
2
```

This post belongs to two categories --- `update` and `tutorial` --- and doesn't include the custom property. Because the
categories overlap with that of the previous post, it will be possible to test getting a list of posts from a category.

## Create the Plugin

The majority of work can be done using a custom plugin. For now, it only needs to convert the output filename extension 
from default `.html` to `.json`. Edit a file `_plugins/api_generator.rb`:

```ruby
module Jekyll
  class PostConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /^\.md$/i
    end

    def output_ext(ext)
      ".json"
    end

    def convert(content)
      content
    end
  end
end
```

* `Converter` --- a [class](https://www.rubydoc.info/github/jekyll/jekyll/Jekyll/Converter) that can handle
[conversion]({% link _docs/plugins/converters.md %}) from one output format to another.
* `safe` and `priority` --- as per [documentation]({% link _docs/plugins/your-first-plugin.md %}#flags):
  > `safe` --- A boolean flag that informs Jekyll whether this plugin may be safely executed in an environment where
  arbitrary code execution is not allowed.
  > `priority` --- This flag determines what order the plugin is loaded in.
* `matches` --- a file extension to match. You target Markdown files, so it should match the extension `.md`. Optionally,
you could add `.markdown` and other Markdown file extensions.
* `output_ext` --- a method that returns an output extension --- `.json` in our case.
* `convert` --- a function that takes post content **transpiled into HTML** as an argument. Please note that it doesn't
parse the file through a template.

### Remove Whitespace

Using [hooks]({% link _docs/plugins/hooks.md %}), you can remove all whitespace. Before a post is rendered, you can add some
custom logic in:

```ruby
def Jekyll.serialize(item)
  JSON.generate(JSON.parse(item))
end

Hooks.register :posts, :post_render do |post|
  post.output = serialize(post.output)
end

Hooks.register :pages, :post_render do |page|
  page.output = serialize(page.output)
end
```
* Create a `Jekyll.serialize` method to generate a new JSON string from an item (a post or page). It will remove all
whitespace characters for you.
* Register for a `post_render` event owned by `:posts` and `:pages`.
* With every post, parse its layout and serialize it.

### Define a Page

In `api_generator.rb`, add the following class as a part of the `Jekyll` module:

```ruby
class ListingPage < Page
  def initialize(site, category, entries, type)
    @site = site
    @base = site.source
    @dir = category
    
    @basename = 'index'
    @ext = '.json'
    @name = 'index.json'
    @data = {
      'entries' => entries
    }
    data.default_proc = proc do |_, key|
      site.frontmatter_defaults.find(relative_path, type, key)
    end
  end

  def url_placeholders
    {
      :category   => @dir,
      :path       => @dir,
      :basename   => basename,
      :output_ext => output_ext,
    }
  end
end
```

* [`Page`](https://www.rubydoc.info/github/jekyll/jekyll/Jekyll/Page) means that `ListingPage` represents a generated page.
* Override `initialize` method. According to the [documentation](https://www.rubydoc.info/github/jekyll/jekyll/Jekyll%2FPage:initialize):
  > `site` --- The Site object.
  > `base` --- The String path to the source.
  > `dir`  --- The String path between the source and the file.
  > `name` --- The String filename of the file.
  
* `@basename` and `@ext` are parts of the `@name`.
* `@data` contains your `entries` --- posts and categories --- that will be rendered.
* Look up front matter [defaults]({% link _docs/plugins/generators.md %}) scoped to a given type, and assign them to every 
entry of `data.entries` array.
* Define placeholders used in constructing the page URL.

### Generate Pages

The last class you'll write is a [generator]({% link _docs/plugins/generators.md %}) that creates listings for you.

```ruby
class ApiGenerator < Generator
  safe true
  priority :normal

  def generate(site)
    posts = site.posts.docs.map{ |post| post.data.clone if !post.data['draft'] }

    site.categories.each_key do |category|
      categories = site.categories[category].map{ |post| post.data.clone }

      site.pages << ListingPage.new(site, 
                                    category, 
                                    categories, 
                                    :categories)
    end
    site.pages << ListingPage.new(site, 
                                  "", 
                                  posts, 
                                  :posts_index)
    site.pages << ListingPage.new(site, 
                                  "", 
                                  site.categories.keys, 
                                  :categories_index)
  end
end
```

* There is only one method you have to implement --- `generate`.
* Make an array of every post. I opted to skip on drafts, but you can choose to generate them as well.
* Iterate through every category to generate indices of posts under a category.
* Generate index of all posts and categories index.

### Layouts

The last thing to do is to define the layouts. First, declare them in `config.yml`:

```yml
defaults:
  - scope:
      type: categories
    values:
      layout: items_index
      permalink: categories/:category/
  - scope:
      type: categories_index
    values:
      layout: categories_index
      permalink: categories/
  - scope:
      type: posts
    values:
      layout: post
  - scope:
      type: posts_index
    values:
      layout: items_index
```

* You have four various scopes: an index of all categories, a listing of all posts under a category, a listing of all posts
in the system, and a single post.
* You specify a layout using a `layout` key.
* Define a `type` used by the plugin. For purposes of this tutorial, it's only required to be unique.
* For some of the items, you declare a `permalink`. If you'd like to, you can do it for all of them. It can come in handy if
you want to define your own API endpoints.

Now you can define the layouts. Before you do it, it's worth noting that you can look up the available variables in
[the documentation]({% link _docs/variables.md %}#page-variables). Knowing that, you can define a partial template in
`_includes/post.html`:

{% raw %}
```liquid
{
    "title": {{ include.post.title | jsonify }},
    "categories": {{ include.post.categories | jsonify }},
    "tags": {{ include.post.tags | jsonify }},
    "content": {{ include.post.content | markdownify | jsonify  }},
    "collection": {{ include.post.collection | jsonify }},
    "date": {{ include.post.date | jsonify }},
    "custom-property": {{ include.post.custom-property | jsonify }}
}
```
{% endraw %}

* Use `include.post` to reference the variable you passed before.
* Pass every property through a `jsonify` [filter]({% link _docs/liquid/filters.md %}#data-to-json). This will add quotation
marks for us, convert arrays into strings, and escape quotation marks.
* For `content`, turn Markdown-formatted strings into HTML using [`markdownify`]({% link _docs/liquid/filters.md %}#markdownify)
filter.
* Fetch the value of `custom-property` variable that you defined earlier. If it doesn't exist on a post, a `null` value will
be returned.

Now you can include it in `_layouts/post.html`:

{% raw %}
```liquid
{% include post.html post=page %}
```
{% endraw %}

* Include a partial template `post.html` from `_includes` directory.
* Assign a value to the internal `post` variable

The next template is `categories_index.html`. The only thing it does is output an array of categories:

{% raw %}
```liquid
{{ page.entries | jsonify }}
```
{% endraw %}

The last template --- `items_index.html` --- would output a list of posts under a category and the index of all posts:

{% raw %}
```liquid
[
    {%- for item in page.entries %}
        {% include post.html post=item%}
        {% if forloop.last != true %}
            ,
        {% endif %}
    {% endfor -%}
]
```
{% endraw %}

* Iterate through every `item` in the `entires` array.
* Passing the iterator variable, output the `item` using the partial template defined before.
* Separate the `entries` using a colon, but skip it for the last one. This ensures that the loop will generate a valid JSON.

And that's it! If you enter the command below:

```sh
bundle exec jekyll build
```

You'll get the following output in your `_site` directory:

```
.
├── index.json
├── categories
│   ├── index.json
│   ├── tutorial
│   │   └── index.json
│   └── update
│       └── index.json
└── update
    ├── 2020
    │   └── 12
    │       └── 20
    │           └── the-first-post.json
    └── tutorial
        └── 2020
            └── 12
                └── 20
                    └── the-second-post.json
```
