---
title: Generators
permalink: /docs/plugins/generators/
---

You can create a generator when you need Jekyll to create additional content based on your own rules.

A generator is a subclass of `Jekyll::Generator` that defines a `generate` method, which receives an instance of
[`Jekyll::Site`]({{ site.repository }}/blob/master/lib/jekyll/site.rb). The return value of `generate` is ignored.

Generators run after Jekyll has made an inventory of the existing content, and before the site is generated. Pages with
front matter are stored as instances of [`Jekyll::Page`]({{ site.repository }}/blob/master/lib/jekyll/page.rb) and are
available via `site.pages`. Static files become instances of
[`Jekyll::StaticFile`]({{ site.repository }}/blob/master/lib/jekyll/static_file.rb)
and are available via `site.static_files`. See [the Variables documentation page](/docs/variables/) and
[`Jekyll::Site`]({{ site.repository }}/blob/master/lib/jekyll/site.rb) for details.

In the following example, the generator will inject values computed at build time for template variables. The template
named `reading.html` has two undefined variables `ongoing` and `done` that will be defined or assigned a value when
the generator runs:

```ruby
module Reading
  class Generator < Jekyll::Generator
    def generate(site)
      book_data = site.data['books']
      ongoing = book_data.select { |book| book['status'] == 'ongoing' }
      done = book_data.select { |book| book['status'] == 'finished' }

      # get template
      reading = site.pages.find { |page| page.name == 'reading.html'}

      # inject data into template
      reading.data['ongoing'] = ongoing
      reading.data['done'] = done
    end
  end
end
```

The following example is a more complex generator that generates new pages.

In this example, the aim of the generator is to create a page for each category registered in the `site`. The pages are
created at runtime, so their contents, front matter and other attributes need to be designed by the plugin itself.
* The pages are intended to render a list of all documents under a given category. So the basename of the rendered file
would be better as `index.html`.
* Having the ability to configure the pages via [front matter defaults](/docs/configuration/front-matter-defaults/)
would be awesome! So assigning a particular `type` to these pages would be beneficial.

```ruby
module SamplePlugin
  class CategoryPageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      site.categories.each do |category, posts|
        site.pages << CategoryPage.new(site, category, posts)
      end
    end
  end

  # Subclass of `Jekyll::Page` with custom method definitions.
  class CategoryPage < Jekyll::Page
    def initialize(site, category, posts)
      @site = site             # the current site instance.
      @base = site.source      # path to the source directory.
      @dir  = category         # the directory the page will reside in.

      # All pages have the same filename, so define attributes straight away.
      @basename = 'index'      # filename without the extension.
      @ext      = '.html'      # the extension.
      @name     = 'index.html' # basically @basename + @ext.

      # Initialize data hash with a key pointing to all posts under current category.
      # This allows accessing the list in a template via `page.linked_docs`.
      @data = {
        'linked_docs' => posts
      }

      # Look up front matter defaults scoped to type `categories`, if given key
      # doesn't exist in the `data` hash.
      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, :categories, key)
      end
    end

    # Placeholders that are used in constructing page URL.
    def url_placeholders
      {
        :category   => @dir,
        :basename   => basename,
        :output_ext => output_ext,
      }
    end
  end
end
```

The generated pages can now be set up to use a particular layout or output at a particular path in the destination
directory all via the config file using front matter defaults. For example:

```yaml
# _config.yml

defaults:
  - scope:
      type: categories  # select all category pages
    values:
      layout: category_page
      permalink: categories/:category/
```

## Technical Aspects

Generators need to implement only one method:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Method</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>generate</code></p>
      </td>
      <td>
        <p>Generates content as a side-effect.</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

If your generator is contained within a single file, it can be named whatever you want but it should have an `.rb`
extension. If your generator is split across multiple files, it should be packaged as a Rubygem to be published at
https://rubygems.org/. In this case, the name of the gem depends on the availability of the name at that site because
no two gems can have the same name.

By default, Jekyll looks for generators in the `_plugins` directory. However, you can change the default directory by
assigning the desired name to the key `plugins_dir` in the config file.
