---
title: Read-Only JSON API
author: izdwuut
date: 2020-12-23 10:04:00 +0100
---
{% raw %}
There shouldn't be a necessity to explain what is the [API](https://en.wikipedia.org/wiki/API). I assume that you've landed here to learn it in a context of Jekyll. Let's jump straight to the actual thing, shall we?

A huge inspiration to write this tutorial was a [post](https://forestry.io/blog/build-a-json-api-with-hugo/) written by [Régis Philibert](https://forestry.io/authors/r%C3%A9gis-philibert/). It's about doing the exact same thing in [Hugo](https://gohugo.io/).

I hope that my solution in Jekyll is elegant, too. You just need to define some [layouts]({% link _docs/layouts.md %}) and write a [plugin]({% link _docs/plugins.md %}) to convert your content to JSON. **Don't be afraid if you're not familiar with Ruby** --- the language that Jekyll is written in. It's similar to Python, and you'll get a hang of it quickly.

By the end of the tutorial, you'll expose the following API:
* `/` --- an index of all posts
* `/{url}` --- details of a post
* `/categories` --- an index of categories
* `/categories/{category}` --- an index of posts under a category

Let's dive in!

---

# Setup

First, you need to go through an [installation]({% link _docs/installation.md %}) process. Having that, you can initialize a new Jekyll project. In your directory of choice, invoke the following:

```sh
bundle init
bundle config set --local path 'vendor/bundle'
bundle add jekyll
bundle exec jekyll new --force --skip-bundle .
bundle install
```

* Initialize a new Ruby [bundle](https://bundler.io).
* Instruct Bundler to install dependencies locally.
* Add Jekyll as a dependency.
* Create a new scaffold for the project. 
* Install dependencies.

Now, you need to do some clean up. 

---

# Configuration

There are some things in the bundle that you won't need:

```
.
├── site
│   ├── index.markdown
│   ├── about.markdown
│   ├── 404.html
│   ├── _posts
│   │   └── 2020-12-19-welcome-to-jekyll.markdown
```

Unless you self-host your site, **you can rely on a generic 404 response from your server**. You no longer need `index` --- you will generate a custom one later. Generating pages like `about` is out of scope of this tutorial, but in case you need them, they behave the same way that posts do.

Under `_posts`, create two new documents. Remember that Jekyll requires you to **prepend filenames with a date**:

`2020–12–20-the-first-post.md`

```md
---
title:  "The First Post"
category: update
custom-property: "My custom property"
---
1
```

Please note that you include a `custom-property` that you will fetch later on. 

`2020–12–20-the-second-post.md`

```md
---
title:  "The Second Post"
categories: ["update", "tutorial"]
---
2
```

This one belongs to two categories --- `update` and `tutorial`, and doesn't include the custom property. Because the categories overlap, it will be possible to test getting a list of posts from a category.

You'll also need a couple of layouts. Just add these empty files for now --- you'll fill (one of) them later:

```
.
├── site
│   ├── _layouts
│   │   ├── category.html
│   │   └── default.html
```

The last thing is to link the `default` layout in `config.yml`:

```yml
defaults:
  -
    scope:
      path: ""
    values:
      layout: "default"
```

Since you won't have any pages in your project, leave the `path` to `""` in order to [cover]({% link _docs/configuration/front-matter-defaults.md %}) every file.

---

# Convert Posts to JSON
My approach is a little hacky --- it requires you to specify a JSON output format in a HTML template. The only thing you miss is that your text editor will most probably not recognize the markup file as a properly formatted JSON document. 

## Define the Template
Before you do it, it's worth noting that you can list all the available properties with this little template, which returns an array of available keys:

```liquid
{{ page.keys | jsonify }}
```

If you enter it in a `default.html` template and execute the following command:

```sh
bundle exec jekyll build
```

You'll get this in `/_site/update/2020/12/20/the-first-post.html`:

```json
["url","relative_path","excerpt","title","categories","path","next","previous","id","output","date","tags","content","collection","draft","layout","category","custom-property","slug","ext"]
```

Given that, I'd like you to enter the following template instead of the aforementioned one-liner:

```liquid
{
    "title": {{ page.title | jsonify }},
    "categories": {{ page.categories | jsonify }},
    "tags": {{ page.tags | jsonify }},
    "content": {{ page.content | markdownify | jsonify  }},
    "collection": {{ page.collection | jsonify }},
    "date": {{ page.date | jsonify }},
    "custom-property": {{ page.custom-property | jsonify }}
}
```
* Pass every property through a jsonify [filter]({% link _docs/liquid/filters.md %}#data-to-json). This will add quotation marks for us, convert arrays into strings and escape quotation marks.
* For content, turn Markdown-formatted string into HTML using [markdownify]({% link _docs/liquid/filters.md %}#markdownify) filter.
* Fetch the falue of custom-property variable that you've defined earlier. If it doesn't exist on a post, a null value will be returned.

If you enter `bundle exec jekyll build` command again, you'd get the following output:

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

## Create a Plugin

The rest of the work can be done using a custom plugin. For now, it only needs to convert the output file extension from default `.html` to `.json`. Under `_plugins`, create a new `api_generator.rb` file:

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

* `Converter` --- a [class](https://www.rubydoc.info/github/jekyll/jekyll/Jekyll/Converter) that can handle [conversion]({% link _docs/plugins/converters.md %}) from one output format to another. 
* `safe` and `priority` --- as per [documentation]({% link _docs/plugins/your-first-plugin.md %}#flags):

> Safe --- A boolean flag that informs Jekyll whether this plugin may be safely executed in an environment where arbitrary code execution is not allowed.

> Priority --- This flag determines what order the plugin is loaded in.

* `matches` --- a file extension to match. You target Markdown files, so it should match a filename `*.md`. Optionally, you could add `.markdown` etc.
* `output_ext` --- a method that returns an output extension --- `.json` in our case.
* `convert` --- a function that takes post content **transpiled into HTML** as an argument. Please note that it doesn't parse the file through a template.

## Remove Whitespaces

But, there's another trick. Using [hooks]({% link _docs/plugins/hooks.md %}), you can remove all whitespaces! Before a post is rendered, you can squeeze some custom logic in:

```ruby
Jekyll::Hooks.register :posts, :post_render do |post|
  post.output = JSON.generate(JSON.parse(post.output))
end
```

* Register for a `post_render` event owned by `posts`.
* With every post, parse the JSON layout you've defined before and generate a new JSON string from it. It will remove all whitespace characters for you.

After building the site, you'd get the following:

```json
{"title":"The First Post","categories":["update"],"tags":[],"content":"<p>1</p>\n","collection":"posts","date":"2020-12-20 00:00:00 +0100","custom-property":"My custom property"}
``` 

---

# Generate Listings

The last step is to generate categories and an index of all posts.

## Define a Page

In `api_generator.rb`, add the following class as a part of `Jekyll` module:

```ruby
class ListingPage < Page
  def initialize(site, base, dir, data)
    @site = site
    @base = base
    @dir  = dir
    @name = 'index.json'

    self.process(@name)
    self.read_yaml(File.join(base, '_layouts'), 'category.html')
    self.content = JSON.generate(data)
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

* Assign some [instance variables](https://www.ruby-lang.org/en/documentation/faq/8/) that Jekyll will utilize to generate the page.
* Process the page filename. It will extract the extension and base name.
* `read_yaml` is only needed to define some instance variable for us. It's just simpler than doing it by hand. You can use any other layout as rendered content will be overwritten.
* Overwrite content with JSON generated from a [hash](https://ruby-doc.org/core-2.7.2/Hash.html) provided in the `data` argument.

## Generate Pages

The last class you'll write is a [generator]({% link _docs/plugins/generators.md %}) that creates listings for you. It's the last piece of code in this tutorial. It's rather lengthy, but really simple in principle:

```ruby
class ApiGenerator < Generator
  safe true
  priority :normal

  def generate(site)
    categories = {}
    posts = {}
    
    site.categories.each_key do |category|
      categories[category] = {}
      site.categories[category].each_entry do |post|
        if post.data['draft']
          continue
        end
        inserted_post = post.data.clone
        title = inserted_post['title']
        inserted_post.delete('draft')
        inserted_post.delete('ext')
        inserted_post.delete('title')
        inserted_post['url'] = post.url
        categories[category][title] = inserted_post
        posts[title] = inserted_post
      end
    end

    category_dir = site.config['category_dir'] || 'categories'
    site.categories.each_key do |category|
      site.pages << ListingPage.new(site, site.source, File.join(category_dir, category), categories[category])
    end
    site.pages << ListingPage.new(site, site.source, "", posts)
    site.pages << ListingPage.new(site, site.source, category_dir, categories.keys)
  end
end
```

* There is only one method you have to implement --- `generate`.
* Iterate through every category and post.
* I opted for skipping on drafts, but you can choose to generate them as well.
* Clone the `post` and delete unused keys. If you'd like to see what fields are available, just enter `puts post` in the inner loop and build the site.
* Assign a post URL.
* Insert the post to `categories` and `posts` hashes.
* Generate categories, categories index and the index of all posts (in that order)

And that's it! If you hit `bundle exec jekyll build` again, you'd get the following output:

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
{% endraw %}
