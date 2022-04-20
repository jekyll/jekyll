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

## Technical Aspects

Generators are required to implement the following public method at minimum:

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
        <p><code>generate(site)</code></p>
      </td>
      <td>
        <p>Generates content as a side-effect.</p>
        <p>
          The method receives a single argument: <code>site</code> which is an instance of the current site
          which under the hood is a Ruby object of class `Jekyll::Site`.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

If the entirety of the plugin's code is contained within a single file, it can be named whatever you want but it should have a `.rb`
extension. If your generator is split across multiple files, it should be packaged as a Rubygem to be published at https://rubygems.org/.
In the latter case, the name of the gem depends on the availability of the name at that site because no two gems can have the same name.

By default, Jekyll loads `.rb` files from the `_plugins` directory. However, you can change this behavior by assigning the desired directory
name to the `plugins_dir` key in the config file.

## Examples

In the following example, the generator will inject values computed at build time for template variables. The template named `reading.html`
has two undefined variables `ongoing` and `done` that will be defined or assigned a value when the generator runs:

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

The following example is a more complex, advanced-level generator that generates new pages. To fully wrap one's head around the implementation
as a whole, it would be best (but not a requirement) to be acquainted with the implementation of `Jekyll::Page` before proceeding ahead.

In this example, the aim of the generator is to create **a page** for each category registered in the `site`. The pages are virtual i.e.
created at runtime. So their content, front matter and other attributes ideally need to be designed by the plugin itself. However, since a
plugin cannot determine the presentational aspects of the render (the desired HTML) which is primarily dictated by the site's theme, the
example plugin will only provide the backend data (`page.linked_docs`) that is expected to be consumed by the user's Liquid template.<br/>
In other words, *the generated pages will be empty* unless linked to a layout (which is outside the scope of current document.)
* The pages are *intended* to render a list of all documents under a given category. So the crux of the generator will be to loop through
`site.categories` and initialize new *objects*, one per registered category.
* Having the ability to configure the pages via [front matter defaults](/docs/configuration/front-matter-defaults/) would be awesome! So
assigning a particular `type` to these pages would be beneficial. The generated virtual pages do not have a hard-coded layout. The layout
attribute is to be assigned via front matter defaults.

```ruby
module SamplePlugin
  # ------------------------- START GENERATOR -------------------------
  #
  class CategoryPageGenerator < Jekyll::Generator
    safe true

    # For every `category` registered under current site, *generate* an
    # instance of `SamplePlugin::CategoryPage` and store them inside
    # `site.pages` which is an array of all standalone pages in the
    # current site.
    def generate(site)
      site.categories.each do |category, documents|
        site.pages << CategoryPage.new(site, category, documents)
      end
    end
  end

  #
  # -------------------------- END GENERATOR --------------------------

  # ----------------------- START VIRTUAL PAGE ------------------------
  #

  # Implement `SamplePlugin::CategoryPage` as a subclass of
  # `Jekyll::Page` which is the core class of all standalone pages in
  # the site.
  #
  # Initializing `Jekyll::Page` objects directly involve reading
  # physical files on disk. Subclassing allows bypassing the
  # *disk-access* logic and additionally giving greater control over
  # attributes of the generated objects.
  class CategoryPage < Jekyll::Page
    # The *initializer* of `Jekyll::Page` takes 4 mandatory arguments,
    # most of which are redundant as well as insufficient for our
    # use-case.
    #
    # The overridden *initializer* takes the following arguments in the
    # given order:
    #        site - The instance of current site (`Jekyll::Site`).
    #    category - Category name (`String`).
    #   documents - Array of posts (instances of `Jekyll::Document`)
    #               under current category name
    #               (`Array<Jekyll::Document>`).
    def initialize(site, category, posts)
      @site = site      # the current site instance.
      @dir  = category  # the directory the page will reside in.

      # All pages have the same filename, so define attributes straight
      # away. Once initialized, the value stored in the following can
      # be accessed via namesake getters and setters.
      # For example, `self.basename`, `self.name`, etc.
      @basename = 'index'       # filename without the extension.
      @ext      = '.html'       # the extension.
      @name     = 'index.html'  # basically @basename + @ext.

      # The `@dir` and `@name` defined by now will be used by Jekyll
      # to construct the `relative_path` attribute automatically at
      # runtime.

      # Initialize data hash with a key pointing to all posts under
      # current category. This allows accessing the list in a Liquid
      # template via `page.linked_docs`.
      @data = {
        'linked_docs' => posts
      }

      # Look up front matter defaults scoped to type `categories`, if
      # given key doesn't exist in the `data` hash. Implementing this
      # allows the user to alter front matter aspects (e.g. `layout`,
      # `permalink`, etc) from the user's config file without editing
      # the plugin code simply by setting the `scope.type` to
      # `categories`.
      #
      # Note: The type assigned here is illustrative. It need not be
      # `:categories` strictly.
      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, :categories, key)
      end
    end

    # Override the URL template used in `Jekyll::Page` to suit our
    # use-case.
    # The result can be manipulated either using default front matter
    #   in the config file or fall back to the site-wide permalink
    #   style used by other pages and docs in the site.
    def template
      Jekyll::Utils.add_permalink_suffix(
        "/:category/:basename", site.permalink_style
      )
    end

    # Override the placeholders from `Jekyll::Page` that are used in
    # constructing page URL.
    def url_placeholders
      {
        :category   => @dir,
        :basename   => basename, # same as `@basename`
        :output_ext => output_ext,
      }
    end
  end
  #
  # ------------------------ END VIRTUAL PAGE -------------------------
end
```

The generated pages since designed to be managed via front matter defaults, the following example will collect all generated pages with type,
`:categories` and do two things:
* assign a layout named `category_page` to all of them.
* configure the destination to be within a directory named `categories` i.e. of the pattern `_site/categories/<category_name>/index.html`. The
destination may be changed to `_site/categories/<category_name>.html` by using `permalink: categories/:category:output_ext` instead.

```yaml
# _config.yml

defaults:
  - scope:
      type: categories  # select all category pages
    values:
      layout: category_page
      permalink: categories/:category/
```
