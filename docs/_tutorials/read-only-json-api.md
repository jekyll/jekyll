---
title: Read-Only JSON API
author: izdwuut
date: 2020-12-23 10:04:00 +0100
plugin_disclaimer: true
---
In this tutorial, you'll create a kind of a [REST](https://restfulapi.net/) [API](https://en.wikipedia.org/wiki/API)
serving static [JSON](https://www.json.org/json-en.html) files generated from Markdown posts in your Jekyll site.

JSON is a popular cross-language method of transferring data on the web, without all the presentation layer of HTML.
The files you output are similar to a REST API in a server side language like Ruby, Python, or Node. You
can access them directly in your browser from e.g. `/foo.json`. They can be used to build a custom frontend using Angular, React, 
Vue, and so on.

A huge inspiration to write this tutorial was a [post](https://forestry.io/blog/build-a-json-api-with-hugo/) written
by [Régis Philibert](https://forestry.io/authors/r%C3%A9gis-philibert/). It's about doing the exact same thing in
[Hugo](https://gohugo.io/).

I hope that this solution in Jekyll is elegant, too. You will need to define a number of [layouts]({% link _docs/layouts.md %})
and write a [plugin]({% link _docs/plugins.md %}) to convert your content to JSON. **Don't be afraid if you're not
familiar with Ruby** --- the language that Jekyll is written in. It's similar to Python, and you should get a hang of it
quickly.

By the end of the tutorial, you'll expose the following API:
* `/` --- an index of all posts
* `/{url}` --- details of a post
* `/categories` --- an index of categories
* `/categories/{category}` --- an index of posts under a category

Let's dive in!

{: .note .info}
This solution needs a custom environment to support its Ruby code. This means that you can't host the site on GitHub
Pages as-is - you'd need to use [Actions]({% link _docs/continuous-integration/github-actions.md %}) to deploy your
site. First, see if a simpler [solution](https://gist.github.com/MichaelCurrin/f8d908596276bdbb2044f04c352cb7c7)
created by [Michael Currin](https://github.com/MichaelCurrin) fits your needs.

## Setup

First, you need to go through an [installation]({% link _docs/installation.md %}) process. Having done that, you can
initialize a new Jekyll project by invoking the command `bundle exec jekyll new`. 

### Directories Structure

You need to create the following structure:

```
.
├── site
│   ├── config.yml
│   ├── _includes
│   │   └── post.rb
│   ├── _layouts
│   │   ├── categories_index.html
│   │   ├── items_index.html
│   │   └── default.html
│   ├── _plugins
│   │   └── api_generator.rb
│   ├── _posts
│   │   ├── 2020–12–20-the-first-post.md
│   │   └── 2020–12–20-the-second-post.md
```

Unless you self-host your site, **you can rely on a generic 404 response from your server**. You no longer need `index`
 --- you will generate a custom one later. Generating pages like `about` is out of scope for this tutorial, but in case
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

This one belongs to two categories --- `update` and `tutorial` --- and doesn't include the custom property. Because the
categories overlap, it will be possible to test getting a list of posts from a category.

### Layouts

The last thing is to define the layouts. First, declare them in `config.yml`:

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

* You have four various content types: an index of all categories, a listing of all posts under a category, a 
listing of all posts in the system and a single post. 
* You specify a layout using a `layout` key.
* You will reference `type` when you'll start writing the plugin. For purposes of this tutorial, it's only 
required to be unique.
* For some of the items you declare permalink. You can do it for all of them. It can come in handy if you want to 
define your own API endpoints.

Now you can define them. Before you do it, it's worth noting that you can list all the available properties with this little template, which
returns an array of available keys:

{% raw %}
```liquid
{{ page.keys | jsonify }}
```
{% endraw %}

If you enter it in a `post.html` template and execute the following command:

```sh
bundle exec jekyll build
```

You'll get this in `/_site/update/2020/12/20/the-first-post.html`:

```json
["url","relative_path","excerpt","title","categories","path","next",
 "previous","id","output","date","tags","content","collection",
 "draft","layout","category","custom-property","slug","ext"]
```

Given that, I'd like you to enter the following template:

{% raw %}
```liquid
{% include post.html post=page %}
```
{% endraw %}

* Include a partial template `post.html` from `_includes` directory. 
* Assign a value to internal `post` variable

Partial template `post.html` should look like this:

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
* Pass every property through a jsonify [filter]({% link _docs/liquid/filters.md %}#data-to-json). This will add
quotation marks for us, convert arrays into strings, and escape quotation marks.
* For content, turn Markdown-formatted strings into HTML using [markdownify]({% link _docs/liquid/filters.md %}#markdownify)
filter.
* Fetch the falue of custom-property variable that you defined earlier. If it doesn't exist on a post, a null value
will be returned.

If you enter `bundle exec jekyll build` again, you'd get the following output:

```json
{
    "title": "The First Post",
    "categories": ["update"],
    "tags": [],
    "content": "<p>1</p>\n",
    "collection": "posts",
    "date": "2020-12-20 00:00:00 +0100",
    "custom-property": "My custom property"
}
```

The next template is `categories_index.html`. It's simple. The only thing it does is output
an array of categories. You'll handle the `entries` variable in a bit:

{% raw %}
```liquid
{{ page.entries | jsonify }}
```
{% endraw %}

The last template --- `items_index.html` --- outputs a list of posts under a category and the 
index of all posts:

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

* Iterate through every `item` in `entires` array.
* Output the `item` using the partial template defined before passing the iterator variable.
* Separate the entries using a colon, but skip it for the last one. This ensures that the loop 
will generate a valid json.


## Convert Posts to JSON
My approach is a little hacky --- it requires you to specify a JSON output format in an HTML template. The only 
thing you will miss is that your text editor will probably not recognize the markup file as a properly formatted 
JSON document.

### Create the Plugin

The rest of the work can be done using a custom plugin. For now, it only needs to convert the output filename extension
from default `.html` to `.json`. Under `_plugins`, create a new `api_generator.rb` file:

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

> Safe --- A boolean flag that informs Jekyll whether this plugin may be safely executed in an environment where
arbitrary code execution is not allowed.

> Priority --- This flag determines what order the plugin is loaded in.

* `matches` --- a file extension to match. You target Markdown files, so it should match a filename `*.md`.
Optionally, you could add `.markdown` etc.
* `output_ext` --- a method that returns an output extension --- `.json` in our case.
* `convert` --- a function that takes post content **transpiled into HTML** as an argument. Please note that it
doesn't parse the file through a template.

### Remove Whitespace

But, there's another trick. Using [hooks]({% link _docs/plugins/hooks.md %}), you can remove all whitespace! Before a
post is rendered, you can add some custom logic in:

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
* Create a `Jekyll.serialize` method to generate a new JSON string from an item (a post or page). 
It will remove all whitespace characters for you. 
* Register for a `post_render` event owned by `:posts` and `:pages`.
* With every post, parse the JSON layout you've defined before and 

After building the site, you'd get the following:

```json
{"title":"The First Post","categories":["update"],"tags":[],
 "content":"<p>1</p>\n","collection":"posts",
 "date":"2020-12-20 00:00:00 +0100",
 "custom-property":"My custom property"}
```

## Generate Listings

The last step is to generate categories and an index of all posts.

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
      :path => @dir,
      :basename   => basename,
      :output_ext => output_ext,
    }
  end
end
```

* [`Page`](https://www.rubydoc.info/github/jekyll/jekyll/Jekyll/Page) means that `ListingPage` represents a generated page.
* Override `initialize` method. According to the [documentation](https://www.rubydoc.info/github/jekyll/jekyll/Jekyll%2FPage:initialize):

> `site` - The Site object.
>
> `base` - The String path to the source.
>
> `dir` - The String path between the source and the file.
>
> `name` - The String filename of the file.
  
* `@basename` and `@ext` are only parts of the `@name`.
* `@data` contains your entries --- posts and categories --- that will be rendered.
* Look up front matter [defaults]({% link _docs/plugins/generators.md %}) scoped to a given type, and assign them to every 
entry of `data.entries` array.
* Define placeholders used in constructing page URL.

### Generate Pages

The last class you'll write is a [generator]({% link _docs/plugins/generators.md %}) that creates listings for you.
It's the last piece of code in this tutorial. It's rather lengthy, but really simple in principle:

```ruby
class ApiGenerator < Generator
  safe true
  priority :normal

  def generate(site)
    categories = {}
    posts = []

    site.categories.each_key do |category|
      categories[category] = []
      site.categories[category].each_entry do |post|
        if post.data['draft']
          continue
        end
        inserted_post = post.data.clone
        categories[category].append(inserted_post)
        posts.append(inserted_post)
      end
    end

    site.categories.each_key do |category|
      site.pages << ListingPage.new(site, category, categories[category], :categories)
    end
    site.pages << ListingPage.new(site, "", posts, :posts_index)
    site.pages << ListingPage.new(site, "", categories.keys, :categories_index)
  end
end
```

* There is only one method you have to implement --- `generate`.
* Iterate through every category and post.
* I opted for skipping on drafts, but you can choose to generate them as well.
* Insert the post to `categories` and `posts` hashes.
* Generate categories, the index of all posts and categories index (in that order).

And that's it! If you hit `bundle exec jekyll build` again, you'll get the following output:

```
.
├── site
│   ├── _site
│   │   ├── index.json
│   │   ├── categories
│   │   │   ├── index.json
│   │   │   ├── tutorial
│   │   │   │   └── index.json
│   │   │   ├── update
│   │   │   │   └── index.json
```
