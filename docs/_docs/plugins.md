---
title: Plugins
permalink: /docs/plugins/
---

Jekyll has a plugin system with hooks that allow you to create custom generated
content specific to your site. You can run custom code for your site without
having to modify the Jekyll source itself.

<div class="note info">
  <h5>Plugins on GitHub Pages</h5>
  <p>
    <a href="https://pages.github.com/">GitHub Pages</a> is powered by Jekyll.
    However, all Pages sites are generated using the <code>--safe</code> option
    to disable custom plugins for security reasons. Unfortunately, this means
    your plugins won’t work if you’re deploying to GitHub Pages.<br><br>
    You can still use GitHub Pages to publish your site, but you’ll need to
    convert the site locally and push the generated static files to your GitHub
    repository instead of the Jekyll source files.
  </p>
</div>

## Installing a plugin

You have 3 options for installing plugins:

1. In your site source root, make a `_plugins` directory. Place your plugins
   here. Any file ending in `*.rb` inside this directory will be loaded before
   Jekyll generates your site.

2. In your `_config.yml` file, add a new array with the key `plugins` (or `gems` for Jekyll < `3.5.0`) and the
   values of the gem names of the plugins you'd like to use. An example:

   ```yaml
   # This will require each of these plugins automatically.
   plugins:
     - jekyll-gist
     - jekyll-coffeescript
     - jekyll-assets
     - another-jekyll-plugin
   ```

   Then install your plugins using `gem install jekyll-gist jekyll-coffeescript jekyll-assets another-jekyll-plugin`

3. Add the relevant plugins to a Bundler group in your `Gemfile`. An
   example:

   ```ruby
    group :jekyll_plugins do
      gem "jekyll-gist"
      gem "jekyll-coffeescript"
      gem "jekyll-assets"
      gem "another-jekyll-plugin"
    end
   ```

   Now you need to install all plugins from your Bundler group by running single command `bundle install`.

<div class="note info">
  <h5>
    <code>_plugins</code>, <code>_config.yml</code> and <code>Gemfile</code>
    can be used simultaneously
  </h5>
  <p>
    You may use any of the aforementioned plugin options simultaneously in the
    same site if you so choose. Use of one does not restrict the use of the
    others.
  </p>
</div>

### The jekyll_plugins group

Jekyll gives this particular group of gems in your `Gemfile` a different
treatment. Any gem included in this group is loaded before Jekyll starts
processing the rest of your source directory.

A gem included here will be activated even if its not explicitly listed under
the `plugins:` key in your site's config file.

<div class="note warning">
  <p>
    Gems included in the <code>:jekyll-plugins</code> group are activated
    regardless of the <code>--safe</code> mode setting. Be aware of what
    gems are included under this group!
  </p>
</div>


In general, plugins you make will fall broadly into one of five categories:

1. [Generators](#generators)
2. [Converters](#converters)
3. [Commands](#commands)
4. [Tags](#tags)
5. [Hooks](#hooks)

See the bottom of the page for a [list of available plugins](#available-plugins)

## Generators

You can create a generator when you need Jekyll to create additional content
based on your own rules.

A generator is a subclass of `Jekyll::Generator` that defines a `generate`
method, which receives an instance of
[`Jekyll::Site`]({{ site.repository }}/blob/master/lib/jekyll/site.rb). The
return value of `generate` is ignored.

Generators run after Jekyll has made an inventory of the existing content, and
before the site is generated. Pages with YAML Front Matters are stored as
instances of
[`Jekyll::Page`]({{ site.repository }}/blob/master/lib/jekyll/page.rb)
and are available via `site.pages`. Static files become instances of
[`Jekyll::StaticFile`]({{ site.repository }}/blob/master/lib/jekyll/static_file.rb)
and are available via `site.static_files`. See
[the Variables documentation page](/docs/variables/) and
[`Jekyll::Site`]({{ site.repository }}/blob/master/lib/jekyll/site.rb)
for more details.

For instance, a generator can inject values computed at build time for template
variables. In the following example the template `reading.html` has two
variables `ongoing` and `done` that we fill in the generator:

```ruby
module Reading
  class Generator < Jekyll::Generator
    def generate(site)
      ongoing, done = Book.all.partition(&:ongoing?)

      reading = site.pages.detect {|page| page.name == 'reading.html'}
      reading.data['ongoing'] = ongoing
      reading.data['done'] = done
    end
  end
end
```

This is a more complex generator that generates new pages:

```ruby
module Jekyll
  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || 'categories'
        site.categories.each_key do |category|
          site.pages << CategoryPage.new(site, site.source, File.join(dir, category), category)
        end
      end
    end
  end
end
```

In this example, our generator will create a series of files under the
`categories` directory for each category, listing the posts in each category
using the `category_index.html` layout.

Generators are only required to implement one method:

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

## Converters

If you have a new markup language you’d like to use with your site, you can
include it by implementing your own converter. Both the Markdown and
[Textile](https://github.com/jekyll/jekyll-textile-converter) markup
languages are implemented using this method.

<div class="note info">
  <h5>Remember your YAML Front Matter</h5>
  <p>
    Jekyll will only convert files that have a YAML header at the top, even for
    converters you add using a plugin.
  </p>
</div>

Below is a converter that will take all posts ending in `.upcase` and process
them using the `UpcaseConverter`:

```ruby
module Jekyll
  class UpcaseConverter < Converter
    safe true
    priority :low

    def matches(ext)
      ext =~ /^\.upcase$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      content.upcase
    end
  end
end
```

Converters should implement at a minimum 3 methods:

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
        <p><code>matches</code></p>
      </td>
      <td><p>
        Does the given extension match this converter’s list of acceptable
        extensions? Takes one argument: the file’s extension (including the
        dot). Must return <code>true</code> if it matches, <code>false</code>
        otherwise.
      </p></td>
    </tr>
    <tr>
      <td>
        <p><code>output_ext</code></p>
      </td>
      <td><p>
        The extension to be given to the output file (including the dot).
        Usually this will be <code>".html"</code>.
      </p></td>
    </tr>
    <tr>
      <td>
        <p><code>convert</code></p>
      </td>
      <td><p>
        Logic to do the content conversion. Takes one argument: the raw content
        of the file (without YAML Front Matter). Must return a String.
      </p></td>
    </tr>
  </tbody>
</table>
</div>

In our example, `UpcaseConverter#matches` checks if our filename extension is
`.upcase`, and will render using the converter if it is. It will call
`UpcaseConverter#convert` to process the content. In our simple converter we’re
simply uppercasing the entire content string. Finally, when it saves the page,
it will do so with a `.html` extension.

## Commands

As of version 2.5.0, Jekyll can be extended with plugins which provide
subcommands for the `jekyll` executable. This is possible by including the
relevant plugins in a `Gemfile` group called `:jekyll_plugins`:

```ruby
group :jekyll_plugins do
  gem "my_fancy_jekyll_plugin"
end
```

Each `Command` must be a subclass of the `Jekyll::Command` class and must
contain one class method: `init_with_program`. An example:

```ruby
class MyNewCommand < Jekyll::Command
  class << self
    def init_with_program(prog)
      prog.command(:new) do |c|
        c.syntax "new [options]"
        c.description 'Create a new Jekyll site.'

        c.option 'dest', '-d DEST', 'Where the site should go.'

        c.action do |args, options|
          Jekyll::Site.new_site_at(options['dest'])
        end
      end
    end
  end
end
```

Commands should implement this single class method:

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
        <p><code>init_with_program</code></p>
      </td>
      <td><p>
        This method accepts one parameter, the
        <code><a href="https://github.com/jekyll/mercenary#readme">Mercenary::Program</a></code>
        instance, which is the Jekyll program itself. Upon the program,
        commands may be created using the above syntax. For more details,
        visit the Mercenary repository on GitHub.com.
      </p></td>
    </tr>
  </tbody>
</table>
</div>

## Tags

If you’d like to include custom liquid tags in your site, you can do so by
hooking into the tagging system. Built-in examples added by Jekyll include the
`highlight` and `include` tags. Below is an example of a custom liquid tag that
will output the time the page was rendered:

```ruby
module Jekyll
  class RenderTimeTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      "#{@text} #{Time.now}"
    end
  end
end

Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTag)
```

At a minimum, liquid tags must implement:

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
        <p><code>render</code></p>
      </td>
      <td>
        <p>Outputs the content of the tag.</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

You must also register the custom tag with the Liquid template engine as
follows:

```ruby
Liquid::Template.register_tag('render_time', Jekyll::RenderTimeTag)
```

In the example above, we can place the following tag anywhere in one of our
pages:

{% raw %}
```ruby
<p>{% render_time page rendered at: %}</p>
```
{% endraw %}

And we would get something like this on the page:

```html
<p>page rendered at: Tue June 22 23:38:47 –0500 2010</p>
```

### Liquid filters

You can add your own filters to the Liquid template system much like you can
add tags above. Filters are simply modules that export their methods to liquid.
All methods will have to take at least one parameter which represents the input
of the filter. The return value will be the output of the filter.

```ruby
module Jekyll
  module AssetFilter
    def asset_url(input)
      "http://www.example.com/#{input}?#{Time.now.to_i}"
    end
  end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)
```

<div class="note">
  <h5>ProTip™: Access the site object using Liquid</h5>
  <p>
    Jekyll lets you access the <code>site</code> object through the
    <code>context.registers</code> feature of Liquid at <code>context.registers[:site]</code>. For example, you can
    access the global configuration file <code>_config.yml</code> using
    <code>context.registers[:site].config</code>.
  </p>
</div>

### Flags

There are two flags to be aware of when writing a plugin:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Flag</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>safe</code></p>
      </td>
      <td>
        <p>
          A boolean flag that informs Jekyll whether this plugin may be safely
          executed in an environment where arbitrary code execution is not
          allowed. This is used by GitHub Pages to determine which core plugins
          may be used, and which are unsafe to run. If your plugin does not
          allow for arbitrary code execution, set this to <code>true</code>.
          GitHub Pages still won’t load your plugin, but if you submit it for
          inclusion in core, it’s best for this to be correct!
        </p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>priority</code></p>
      </td>
      <td>
        <p>
          This flag determines what order the plugin is loaded in. Valid values
          are: <code>:lowest</code>, <code>:low</code>, <code>:normal</code>,
          <code>:high</code>, and <code>:highest</code>. Highest priority
          matches are applied first, lowest priority are applied last.
        </p>
      </td>
    </tr>
  </tbody>
</table>
</div>

To use one of the example plugins above as an illustration, here is how you’d
specify these two flags:

```ruby
module Jekyll
  class UpcaseConverter < Converter
    safe true
    priority :low
    ...
  end
end
```

## Hooks

Using hooks, your plugin can exercise fine-grained control over various aspects
of the build process. If your plugin defines any hooks, Jekyll will call them
at pre-defined points.

Hooks are registered to a container and an event name. To register one, you
call Jekyll::Hooks.register, and pass the container, event name, and code to
call whenever the hook is triggered. For example, if you want to execute some
custom functionality every time Jekyll renders a post, you could register a
hook like this:

```ruby
Jekyll::Hooks.register :posts, :post_render do |post|
  # code to call after Jekyll renders a post
end
```

Jekyll provides hooks for <code>:site</code>, <code>:pages</code>,
<code>:posts</code>, and <code>:documents</code>. In all cases, Jekyll calls
your hooks with the container object as the first callback parameter. However,
all `:pre_render` hooks and the`:site, :post_render` hook will also provide a
payload hash as a second parameter. In the case of `:pre_render`, the payload
gives you full control over the variables that are available while rendering.
In the case of `:site, :post_render`, the payload contains final values after
rendering all the site (useful for sitemaps, feeds, etc).

The complete list of available hooks is below:

<div class="mobile-side-scroller">
<table>
  <thead>
    <tr>
      <th>Container</th>
      <th>Event</th>
      <th>Called</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:after_init</code></p>
      </td>
      <td>
        <p>Just after the site initializes, but before setup & render. Good
        for modifying the configuration of the site.</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:after_reset</code></p>
      </td>
      <td>
        <p>Just after site reset</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:post_read</code></p>
      </td>
      <td>
        <p>After site data has been read and loaded from disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering the whole site</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering the whole site, but before writing any files</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:site</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing the whole site to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:post_init</code></p>
      </td>
      <td>
        <p>Whenever a page is initialized</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a page</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a page, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:pages</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a page to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:post_init</code></p>
      </td>
      <td>
        <p>Whenever a post is initialized</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a post</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a post, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:posts</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a post to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:post_init</code></p>
      </td>
      <td>
        <p>Whenever a document is initialized</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:pre_render</code></p>
      </td>
      <td>
        <p>Just before rendering a document</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:post_render</code></p>
      </td>
      <td>
        <p>After rendering a document, but before writing it to disk</p>
      </td>
    </tr>
    <tr>
      <td>
        <p><code>:documents</code></p>
      </td>
      <td>
        <p><code>:post_write</code></p>
      </td>
      <td>
        <p>After writing a document to disk</p>
      </td>
    </tr>
  </tbody>
</table>
</div>

## Available Plugins

You can find a few useful plugins at the following locations:

#### Generators

- [ArchiveGenerator by Ilkka Laukkanen](https://gist.github.com/707909): Uses [this archive page](https://gist.github.com/707020) to generate archives.
- [LESS.js Generator by Andy Fowler](https://gist.github.com/642739): Renders
LESS.js files during generation.
- [Version Reporter by Blake Smith](https://gist.github.com/449491): Creates a version.html file containing the Jekyll version.
- [Sitemap.xml Generator by Michael Levin](https://github.com/kinnetica/jekyll-plugins): Generates a sitemap.xml file by traversing all of the available posts and pages.
- [Full-text search by Pascal Widdershoven](https://github.com/PascalW/jekyll_indextank): Adds full-text search to your Jekyll site with a plugin and a bit of JavaScript.
- [AliasGenerator by Thomas Mango](https://github.com/tsmango/jekyll_alias_generator): Generates redirect pages for posts when an alias is specified in the YAML Front Matter.
- [Pageless Redirect Generator by Nick Quinlan](https://github.com/nquinlan/jekyll-pageless-redirects): Generates redirects based on files in the Jekyll root, with support for htaccess style redirects.
- [RssGenerator by Assaf Gelber](https://github.com/agelber/jekyll-rss): Automatically creates an RSS 2.0 feed from your posts.
- [Monthly archive generator by Shigeya Suzuki](https://github.com/shigeya/jekyll-monthly-archive-plugin): Generator and template which renders monthly archive like MovableType style, based on the work by Ilkka Laukkanen and others above.
- [Category archive generator by Shigeya Suzuki](https://github.com/shigeya/jekyll-category-archive-plugin): Generator and template which renders category archive like MovableType style, based on Monthly archive generator.
- [Emoji for Jekyll](https://github.com/yihangho/emoji-for-jekyll): Seamlessly enable emoji for all posts and pages.
- [Compass integration for Jekyll](https://github.com/mscharley/jekyll-compass): Easily integrate Compass and Sass with your Jekyll website.
- [Pages Directory by Ben Baker-Smith](https://github.com/bbakersmith/jekyll-pages-directory): Defines a `_pages` directory for page files which routes its output relative to the project root.
- [Page Collections by Jeff Kolesky](https://github.com/jeffkole/jekyll-page-collections): Generates collections of pages with functionality that resembles posts.
- [Windows 8.1 Live Tile Generation by Matt Sheehan](https://github.com/sheehamj13/jekyll-live-tiles): Generates Internet Explorer 11 config.xml file and Tile Templates for pinning your site to Windows 8.1.
- [Typescript Generator by Matt Sheehan](https://github.com/sheehamj13/jekyll_ts): Generate Javascript on build from your Typescript.
- [Jekyll::AutolinkEmail by Ivan Tse](https://github.com/ivantsepp/jekyll-autolink_email): Autolink your emails.
- [Jekyll::GitMetadata by Ivan Tse](https://github.com/ivantsepp/jekyll-git_metadata): Expose Git metadata for your templates.
- [Jekyll Http Basic Auth Plugin](https://gist.github.com/snrbrnjna/422a4b7e017192c284b3): Plugin to manage http basic auth for jekyll generated pages and directories.
- [Jekyll Auto Image by Merlos](https://github.com/merlos/jekyll-auto-image): Gets the first image of a post. Useful to list your posts with images or to add [twitter cards](https://dev.twitter.com/cards/overview) to your site.
- [Jekyll Portfolio Generator by Shannon Babincsak](https://github.com/codeinpink/jekyll-portfolio-generator): Generates project pages and computes related projects out of project data files.
- [Jekyll-Umlauts by Arne Gockeln](https://github.com/webchef/jekyll-umlauts): This generator replaces all german umlauts (äöüß) case sensitive with html.
- [Jekyll Flickr Plugin](https://github.com/lawmurray/indii-jekyll-flickr) by [Lawrence Murray](http://www.indii.org): Generates posts for photos uploaded to a Flickr photostream.
- [Jekyll::Paginate::Category](https://github.com/midnightSuyama/jekyll-paginate-category): Pagination Generator for Jekyll Category.
- [AMP-Jekyll by Juuso Mikkonen](https://github.com/juusaw/amp-jekyll): Generate [Accelerated Mobile Pages](https://www.ampproject.org) of Jekyll posts.
- [Jekyll Art Gallery plugin](https://github.com/alexivkin/Jekyll-Art-Gallery-Plugin): An advanced art/photo gallery generation plugin for creating galleries from a set of image folders. Supports image tagging, thumbnails, sorting, image rotation, post-processing (remove EXIF, add watermark), multiple collections and much more.
- [jekyll-ga](https://github.com/developmentseed/jekyll-ga): A Jekyll plugin that downloads Google Analytics data and adds it to posts. Useful for making a site that lists "most popular" content. [Read the introduction](https://developmentseed.org/blog/google-analytics-jekyll-plugin/) post on the developmentSEED blog.
- [jekyll-multi-paginate](https://github.com/fadhilnapis/jekyll-multi-paginate): Simple Jekyll paginator for multiple page. Ease you to make pagination on multiple page especially like multiple language.
- [jekyll-category-pages](https://github.com/field-theory/jekyll-category-pages): Easy-to-use category index pages with and without pagination. Supports non-URL-safe category keywords and has extensive documentation and test coverage.
- [Tweetsert](https://github.com/ibrado/jekyll-tweetsert): Imports tweets (Twitter statuses) as new posts. Features multiple timeline support, hashtag import, filtering, automatic category and/or tags, optional retweets and replies.
- [Stickyposts](https://github.com/ibrado/jekyll-stickyposts): Moves or copies (pins) posts marked `sticky: true` to the top of the list. Perfect for keeping important announcements on the home page, or giving collections a descriptive entry. Paginator friendly.
- [Jekyll::Paginate::Content](https://github.com/ibrado/jekyll-paginate-content): Content paginator in the style of jekyll-paginator-v2 that splits pages, posts, and collection entries into several pages. Specify a separator or use HTML &lt;h1&gt; etc. headers. Automatic splitting, single-page view, pager/trail, self-adjusting links, multipage TOC, SEO support.

#### Converters

- [Pug plugin by Doug Beney](http://jekyll-pug.dougie.io): Use the popular Pug (previously Jade) templating language in Jekyll. Complete with caching, includes support, and much more.
- [Textile converter](https://github.com/jekyll/jekyll-textile-converter): Convert `.textile` files into HTML. Also includes the `textilize` Liquid filter.
- [Slim plugin](https://github.com/slim-template/jekyll-slim): Slim converter and includes for Jekyll with support for Liquid tags.
- [HAML plugin by Sam Z](https://gist.github.com/517556): HAML converter for Jekyll.
- [HAML-Sass Converter by Adam Pearson](https://gist.github.com/481456): Simple HAML-Sass converter for Jekyll. [Fork](https://gist.github.com/528642) by Sam X.
- [Sass SCSS Converter by Mark Wolfe](https://gist.github.com/960150): Sass converter which uses the new CSS compatible syntax, based Sam X’s fork above.
- [LESS Converter by Jason Graham](https://gist.github.com/639920): Convert LESS files to CSS.
- [LESS Converter by Josh Brown](https://gist.github.com/760265): Simple LESS converter.
- [Upcase Converter by Blake Smith](https://gist.github.com/449463): An example Jekyll converter.
- [CoffeeScript Converter by phaer](https://gist.github.com/959938): A [CoffeeScript](http://coffeescript.org) to Javascript converter.
- [Markdown References by Olov Lassus](https://github.com/olov/jekyll-references): Keep all your markdown reference-style link definitions in one \_references.md file.
- [Stylus Converter](https://gist.github.com/988201): Convert .styl to .css.
- [ReStructuredText Converter](https://github.com/xdissent/jekyll-rst): Converts ReST documents to HTML with Pygments syntax highlighting.
- [Jekyll-pandoc-multiple-formats](https://github.com/fauno/jekyll-pandoc-multiple-formats) by [edsl](https://github.com/edsl): Use pandoc to generate your site in multiple formats. Supports pandoc’s markdown extensions.
- [Transform Layouts](https://gist.github.com/1472645): Allows HAML layouts (you need a HAML Converter plugin for this to work).
- [Org-mode Converter](https://gist.github.com/abhiyerra/7377603): Org-mode converter for Jekyll.
- [Customized Kramdown Converter](https://github.com/mvdbos/kramdown-with-pygments): Enable Pygments syntax highlighting for Kramdown-parsed fenced code blocks.
- [Bigfootnotes Plugin](https://github.com/TheFox/jekyll-bigfootnotes): Enables big footnotes for Kramdown.
- [AsciiDoc Plugin](https://github.com/asciidoctor/jekyll-asciidoc): AsciiDoc convertor for Jekyll using [Asciidoctor](http://asciidoctor.org/).
- [Lazy Tweet Embedding](https://github.com/takuti/jekyll-lazy-tweet-embedding): Automatically convert tweet urls into twitter cards.
- [jekyll-commonmark](https://github.com/pathawks/jekyll-commonmark): Markdown converter that uses [libcmark](https://github.com/jgm/CommonMark), the reference parser for CommonMark.

#### Filters

- [Truncate HTML](https://github.com/MattHall/truncatehtml) by [Matt Hall](https://codebeef.com/): A Jekyll filter that truncates HTML while preserving markup structure.
- [Domain Name Filter by Lawrence Woodman](https://github.com/LawrenceWoodman/domain_name-liquid_filter): Filters the input text so that just the domain name is left.
- [Summarize Filter by Mathieu Arnold](https://gist.github.com/731597): Remove markup after a `<div id="extended">` tag.
- [Smilify](https://github.com/SaswatPadhi/jekyll_smilify) by [SaswatPadhi](https://github.com/SaswatPadhi): Convert text emoticons in your content to themeable smiley pics.
- [Read in X Minutes](https://gist.github.com/zachleat/5792681) by [zachleat](https://github.com/zachleat): Estimates the reading time of a string (for blog post content).
- [Jekyll-timeago](https://github.com/markets/jekyll-timeago): Converts a time value to the time ago in words.
- [pluralize](https://github.com/bdesham/pluralize): Easily combine a number and a word into a grammatically-correct amount like “1 minute” or “2 minute**s**”.
- [reading_time](https://github.com/bdesham/reading_time): Count words and estimate reading time for a piece of text, ignoring HTML elements that are unlikely to contain running text.
- [Table of Content Generator](https://github.com/dafi/jekyll-toc-generator): Generate the HTML code containing a table of content (TOC), the TOC can be customized in many way, for example you can decide which pages can be without TOC.
- [jekyll-toc](https://github.com/toshimaru/jekyll-toc): A liquid filter plugin for Jekyll which generates a table of contents.
- [jekyll-humanize](https://github.com/23maverick23/jekyll-humanize): This is a port of the Django app humanize which adds a "human touch" to data. Each method represents a Fluid type filter that can be used in your Jekyll site templates. Given that Jekyll produces static sites, some of the original methods do not make logical sense to port (e.g. naturaltime).
- [Jekyll-Ordinal](https://github.com/PatrickC8t/Jekyll-Ordinal): Jekyll liquid filter to output a date ordinal such as "st", "nd", "rd", or "th".
- [Deprecated articles keeper](https://github.com/kzykbys/JekyllPlugins) by [Kazuya Kobayashi](http://blog.kazuya.co/): A simple Jekyll filter which monitor how old an article is.
- [Jekyll-jalali](https://github.com/mehdisadeghi/jekyll-jalali) by [Mehdi Sadeghi](http://mehdix.ir): A simple Gregorian to Jalali date converter filter.
- [Jekyll Thumbnail Filter](https://github.com/matallo/jekyll-thumbnail-filter): Related posts thumbnail filter.
- [liquid-md5](https://github.com/pathawks/liquid-md5): Returns an MD5 hash. Helpful for generating Gravatars in templates.
- [jekyll-roman](https://github.com/paulrobertlloyd/jekyll-roman): A liquid filter for Jekyll that converts numbers into Roman numerals.
- [jekyll-typogrify](https://github.com/myles/jekyll-typogrify): A Jekyll plugin that brings the functions of [typogruby](http://avdgaag.github.io/typogruby/).
- [Jekyll Email Protect](https://github.com/vwochnik/jekyll-email-protect): Email protection liquid filter for Jekyll
- [Jekyll Uglify Filter](https://github.com/mattg/jekyll-uglify-filter): A Liquid filter that runs your JavaScript through UglifyJS.
- [match_regex](https://github.com/sparanoid/match_regex): A Liquid filter to perform regex match.
- [replace_regex](https://github.com/sparanoid/replace_regex): A Liquid filter to perform regex replace.
- [Jekyll Money](https://rubygems.org/gems/jekyll-money): A Jekyll plugin for dealing with money. Because we all have to at some point.

#### Tags

You can find a few useful plugins at the following locations:

- [Jekyll-gist](https://github.com/jekyll/jekyll-gist): Use the `gist` tag to easily embed a GitHub Gist onto your site. This works with public or secret gists.
- [Asset Path Tag](https://github.com/samrayner/jekyll-asset-path-plugin) by [Sam Rayner](http://www.samrayner.com/): Allows organisation of assets into subdirectories by outputting a path for a given file relative to the current post or page.
- [Delicious Plugin by Christian Hellsten](https://github.com/christianhellsten/jekyll-plugins): Fetches and renders bookmarks from delicious.com.
- [Ultraviolet Plugin by Steve Alex](https://gist.github.com/480380): Jekyll tag for the [Ultraviolet](https://github.com/grosser/ultraviolet) code highligher.
- [Tag Cloud Plugin by Ilkka Laukkanen](https://gist.github.com/710577): Generate a tag cloud that links to tag pages.
- [GIT Tag by Alexandre Girard](https://gist.github.com/730347): Add Git activity inside a list.
- [MathJax Liquid Tags by Jessy Cowan-Sharp](https://gist.github.com/834610): Simple liquid tags for Jekyll that convert inline math and block equations to the appropriate MathJax script tags.
- [Non-JS Gist Tag by Brandon Tilley](https://gist.github.com/1027674) A Liquid tag that embeds Gists and shows code for non-JavaScript enabled browsers and readers.
- [Render Time Tag by Blake Smith](https://gist.github.com/449509): Displays the time a Jekyll page was generated.
- [Status.net/OStatus Tag by phaer](https://gist.github.com/912466): Displays the notices in a given status.net/ostatus feed.
- [Embed.ly client by Robert Böhnke](https://github.com/robb/jekyll-embedly-client): Autogenerate embeds from URLs using oEmbed.
- [Logarithmic Tag Cloud](https://gist.github.com/2290195): Flexible. Logarithmic distribution. Documentation inline.
- [oEmbed Tag by Tammo van Lessen](https://gist.github.com/1455726): Enables easy content embedding (e.g. from YouTube, Flickr, Slideshare) via oEmbed.
- [FlickrSetTag by Thomas Mango](https://github.com/tsmango/jekyll_flickr_set_tag): Generates image galleries from Flickr sets.
- [Tweet Tag by Scott W. Bradley](https://github.com/scottwb/jekyll-tweet-tag): Liquid tag for [Embedded Tweets](https://dev.twitter.com/docs/embedded-tweets) using Twitter’s shortcodes.
- [Jekyll Twitter Plugin](https://github.com/rob-murray/jekyll-twitter-plugin): A Liquid tag plugin that renders Tweets from Twitter API. Currently supports the [oEmbed](https://dev.twitter.com/rest/reference/get/statuses/oembed) API.
- [Jekyll-contentblocks](https://github.com/rustygeldmacher/jekyll-contentblocks): Lets you use Rails-like content_for tags in your templates, for passing content from your posts up to your layouts.
- [Generate YouTube Embed](https://gist.github.com/1805814) by [joelverhagen](https://github.com/joelverhagen): Jekyll plugin which allows you to embed a YouTube video in your page with the YouTube ID. Optionally specify width and height dimensions. Like “oEmbed Tag” but just for YouTube.
- [Jekyll-beastiepress](https://github.com/okeeblow/jekyll-beastiepress): FreeBSD utility tags for Jekyll sites.
- [Jsonball](https://gist.github.com/1895282): Reads json files and produces maps for use in Jekyll files.
- [Bibjekyll](https://github.com/pablooliveira/bibjekyll): Render BibTeX-formatted bibliographies/citations included in posts and pages using bibtex2html.
- [Jekyll-citation](https://github.com/archome/jekyll-citation): Render BibTeX-formatted bibliographies/citations included in posts and pages (pure Ruby).
- [Jekyll Dribbble Set Tag](https://github.com/ericdfields/Jekyll-Dribbble-Set-Tag): Builds Dribbble image galleries from any user.
- [Debbugs](https://gist.github.com/2218470): Allows posting links to Debian BTS easily.
- [Jekyll-devonly_tag](https://gist.github.com/2403522): A block tag for including markup only during development.
- [JekyllGalleryTag](https://github.com/redwallhp/JekyllGalleryTag) by [redwallhp](https://github.com/redwallhp): Generates thumbnails from a directory of images and displays them in a grid.
- [Youku and Tudou Embed](https://gist.github.com/Yexiaoxing/5891929): Liquid plugin for embedding Youku and Tudou videos.
- [Jekyll-swfobject](https://github.com/sectore/jekyll-swfobject): Liquid plugin for embedding Adobe Flash files (.swf) using [SWFObject](https://github.com/swfobject/swfobject).
- [Jekyll Picture Tag](https://github.com/robwierzbowski/jekyll-picture-tag): Easy responsive images for Jekyll. Based on the proposed [`<picture>`](https://html.spec.whatwg.org/multipage/embedded-content.html#the-picture-element) element, polyfilled with Scott Jehl’s [Picturefill](https://github.com/scottjehl/picturefill).
- [Jekyll Image Tag](https://github.com/robwierzbowski/jekyll-image-tag): Better images for Jekyll. Save image presets, generate resized images, and add classes, alt text, and other attributes.
- [Jekyll Responsive Image](https://github.com/wildlyinaccurate/jekyll-responsive-image): Responsive images for Jekyll. Automatically resizes images, supports all responsive methods (`<picture>`, `srcset`, Imager.js, etc), super-flexible configuration.
- [Ditaa Tag](https://github.com/matze/jekyll-ditaa) by [matze](https://github.com/matze): Renders ASCII diagram art into PNG images and inserts a figure tag.
- [Jekyll Suggested Tweet](https://github.com/davidensinger/jekyll-suggested-tweet) by [David Ensinger](https://github.com/davidensinger/): A Liquid tag for Jekyll that allows for the embedding of suggested tweets via Twitter’s Web Intents API.
- [Jekyll Date Chart](https://github.com/GSI/jekyll_date_chart) by [GSI](https://github.com/GSI): Block that renders date line charts based on textile-formatted tables.
- [Jekyll Image Encode](https://github.com/GSI/jekyll_image_encode) by [GSI](https://github.com/GSI): Tag that renders base64 codes of images fetched from the web.
- [Jekyll Quick Man](https://github.com/GSI/jekyll_quick_man) by [GSI](https://github.com/GSI): Tag that renders pretty links to man page sources on the internet.
- [jekyll-font-awesome](https://gist.github.com/23maverick23/8532525): Quickly and easily add Font Awesome icons to your posts.
- [Lychee Gallery Tag](https://gist.github.com/tobru/9171700) by [tobru](https://github.com/tobru): Include [Lychee](https://lychee.electerious.com/) albums into a post. For an introduction, see [Jekyll meets Lychee - A Liquid Tag plugin](https://tobrunet.ch/articles/jekyll-meets-lychee-a-liquid-tag-plugin/)
- [Image Set/Gallery Tag](https://github.com/callmeed/jekyll-image-set) by [callmeed](https://github.com/callmeed): Renders HTML for an image gallery from a folder in your Jekyll site. Just pass it a folder name and class/tag options.
- [jekyll_figure](https://github.com/lmullen/jekyll_figure): Generate figures and captions with links to the figure in a variety of formats
- [Jekyll GitHub Sample Tag](https://github.com/bwillis/jekyll-github-sample): A liquid tag to include a sample of a github repo file in your Jekyll site.
- [Jekyll Project Version Tag](https://github.com/rob-murray/jekyll-version-plugin): A Liquid tag plugin that renders a version identifier for your Jekyll site sourced from the git repository containing your code.
- [Piwigo Gallery](https://github.com/AlessandroLorenzi/piwigo_gallery) by [Alessandro Lorenzi](http://blog.alorenzi.eu/): Jekyll plugin to generate thumbnails from a Piwigo gallery and display them with a Liquid tag
- [mathml.rb](https://github.com/tmthrgd/jekyll-plugins) by Tom Thorogood: A plugin to convert TeX mathematics into MathML for display.
- [webmention_io.rb](https://github.com/aarongustafson/jekyll-webmention_io) by [Aaron Gustafson](http://aaron-gustafson.com/): A plugin to enable [webmention](https://indieweb.org/webmention) integration using [Webmention.io](https://webmention.io/). Includes an optional JavaScript for updating webmentions automatically between publishes and, if available, in realtime using WebSockets.
- [Jekyll 500px Embed](https://github.com/lkorth/jekyll-500px-embed) by Luke Korth. A Liquid tag plugin that embeds [500px](https://500px.com/) photos.
- [inline\_highlight](https://github.com/bdesham/inline_highlight): A tag for inline syntax highlighting.
- [jekyll-mermaid](https://github.com/jasonbellamy/jekyll-mermaid): Simplify the creation of mermaid diagrams and flowcharts in your posts and pages.
- [twa](https://github.com/Ezmyrelda/twa): Twemoji Awesome plugin for Jekyll. Liquid tag allowing you to use twitter emoji in your jekyll pages.
- [Fetch remote file content](https://github.com/dimitri-koenig/jekyll-plugins) by [Dimitri König](https://www.dimitrikoenig.net/): Using `remote_file_content` tag you can fetch the content of a remote file and include it as if you would put the content right into your markdown file yourself. Very useful for including code from github repo's to always have a current repo version.
- [jekyll-asciinema](https://github.com/mnuessler/jekyll-asciinema): A tag for embedding asciicasts recorded with [asciinema](https://asciinema.org) in your Jekyll pages.
- [Jekyll-Youtube](https://github.com/dommmel/jekyll-youtube)  A Liquid tag that embeds Youtube videos. The default emded markup is responsive but you can also specify your own by using an include/partial.
- [Jekyll Flickr Plugin](https://github.com/lawmurray/indii-jekyll-flickr) by [Lawrence Murray](http://www.indii.org): Embeds Flickr photosets (albums) as a gallery of thumbnails, with lightbox links to larger images.
- [jekyll-figure](https://github.com/paulrobertlloyd/jekyll-figure): A liquid tag for Jekyll that generates `<figure>` elements.
- [Jekyll Video Embed](https://github.com/eug/jekyll-video-embed): It provides several tags to easily embed videos (e.g. Youtube, Vimeo, UStream and Ted Talks)
- [jekyll-i18n_tags](https://github.com/KrzysiekJ/jekyll-i18n_tags): Translate your templates.
- [Jekyll Ideal Image Slider](https://github.com/jekylltools/jekyll-ideal-image-slider): Liquid tag plugin to create image sliders using [Ideal Image Slider](https://github.com/gilbitron/Ideal-Image-Slider).
- [Jekyll Tags List Plugin](https://github.com/crispgm/jekyll-tags-list-plugin): A Liquid tag plugin that creates tags list in specific order.
- [Jekyll Maps](https://github.com/ayastreb/jekyll-maps) by [Anatoliy Yastreb](https://github.com/ayastreb): A Jekyll plugin to easily embed maps with filterable locations.
- [Jekyll Cloudinary](https://nhoizey.github.io/jekyll-cloudinary/) by [Nicolas Hoizey](https://nicolas-hoizey.com/): a Jekyll plugin adding a Liquid tag to ease the use of Cloudinary for responsive images in your Markdown/Kramdown posts.
- [jekyll-include-absolute-plugin](https://github.com/tnhu/jekyll-include-absolute-plugin) by [Tan Nhu](https://github.com/tnhu): A Jekyll plugin to include a file from its path relative to Jekyll's source folder.
- [Jekyll Download Tag](https://github.com/mattg/jekyll-download-tag): A Liquid tag that acts like `include`, but for external resources.
- [Jekyll Brand Social Wall](https://github.com/MediaComem/jekyll-brand-social-wall): A jekyll plugin to generate a social wall with your favorite social networks
- [Jekyll If File Exists](https://github.com/k-funk/jekyll-if-file-exists): A Jekyll Plugin that checks if a file exists with an if/else block.
- [BibSonomy](https://github.com/rjoberon/bibsonomy-jekyll): Jekyll
  plugin to generate publication lists from [BibSonomy](https://www.bibsonomy.org/).
- [github-cards](https://github.com/edward-shen/github-cards): Creates styleable Github cards for your Github projects.
- [disqus-for-jekyll](https://github.com/kacperduras/disqus-for-jekyll): A Jekyll plugin to view the comments powered by Disqus.


#### Collections

- [Jekyll Plugins by Recursive Design](https://github.com/recurser/jekyll-plugins): Plugins to generate Project pages from GitHub readmes, a Category page, and a Sitemap generator.
- [Company website and blog plugins](https://github.com/flatterline/jekyll-plugins) by Flatterline, a Ruby on Rails development company: Portfolio/project page generator, team/individual page generator, an author bio liquid tag for use on posts, and a few other smaller plugins.
- [Jekyll plugins by Aucor](https://github.com/aucor/jekyll-plugins): Plugins for trimming unwanted newlines/whitespace and sorting pages by weight attribute.

#### Other

- [Analytics for Jekyll](https://github.com/hendrikschneider/jekyll-analytics) by Hendrik Schneider: An effortless way to add  various trackers like Google Analytics, Piwik, etc. to your site
- [ditaa-ditaa](https://github.com/tmthrgd/ditaa-ditaa) by Tom Thorogood: a drastic revision of jekyll-ditaa that renders diagrams drawn using ASCII art into PNG images.
- [Pygments Cache Path by Raimonds Simanovskis](https://github.com/rsim/blog.rayapps.com/blob/master/_plugins/pygments_cache_patch.rb): Plugin to cache syntax-highlighted code from Pygments.
- [Draft/Publish Plugin by Michael Ivey](https://gist.github.com/49630): Save posts as drafts.
- [Growl Notification Generator by Tate Johnson](https://gist.github.com/490101): Send Jekyll notifications to Growl.
- [Growl Notification Hook by Tate Johnson](https://gist.github.com/525267): Better alternative to the above, but requires his “hook” fork.
- [Related Posts by Lawrence Woodman](https://github.com/LawrenceWoodman/related_posts-jekyll_plugin): Overrides `site.related_posts` to use categories to assess relationship.
- [jekyll-tagging-related_posts](https://github.com/toshimaru/jekyll-tagging-related_posts): Jekyll related_posts function based on tags (works on Jekyll3).
- [Tiered Archives by Eli Naeher](https://gist.github.com/88cda643aa7e3b0ca1e5): Create tiered template variable that allows you to group archives by year and month.
- [Jekyll-localization](https://github.com/blackwinter/jekyll-localization): Jekyll plugin that adds localization features to the rendering engine.
- [Jekyll-rendering](https://github.com/blackwinter/jekyll-rendering): Jekyll plugin to provide alternative rendering engines.
- [Jekyll-pagination](https://github.com/blackwinter/jekyll-pagination): Jekyll plugin to extend the pagination generator.
- [Jekyll-tagging](https://github.com/pattex/jekyll-tagging): Jekyll plugin to automatically generate a tag cloud and tag pages.
- [Jekyll-scholar](https://github.com/inukshuk/jekyll-scholar): Jekyll extensions for the blogging scholar.
- [Jekyll-assets](http://jekyll.github.io/jekyll-assets/) by [ixti](https://github.com/ixti): Rails-alike assets pipeline (write assets in CoffeeScript, Sass, LESS etc; specify dependencies for automatic bundling using simple declarative comments in assets; minify and compress; use JST templates; cache bust; and many-many more).
- [JAPR](https://github.com/kitsched/japr): Jekyll Asset Pipeline Reborn - Powerful asset pipeline for Jekyll that collects, converts and compresses JavaScript and CSS assets.
- [File compressor](https://gist.github.com/2758691) by [mytharcher](https://github.com/mytharcher): Compress HTML and JavaScript files on site build.
- [Jekyll-minibundle](https://github.com/tkareine/jekyll-minibundle): Asset bundling and cache busting using external minification tool of your choice. No gem dependencies.
- [Singlepage-jekyll](https://github.com/JCB-K/singlepage-jekyll) by [JCB-K](https://github.com/JCB-K): Turns Jekyll into a dynamic one-page website.
- [generator-jekyllrb](https://github.com/robwierzbowski/generator-jekyllrb): A generator that wraps Jekyll in [Yeoman](http://yeoman.io/), a tool collection and workflow for building modern web apps.
- [grunt-jekyll](https://github.com/dannygarcia/grunt-jekyll): A straightforward [Grunt](http://gruntjs.com/) plugin for Jekyll.
- [jekyll-postfiles](https://github.com/indirect/jekyll-postfiles): Add `_postfiles` directory and {% raw %}`{{ postfile }}`{% endraw %} tag so the files a post refers to will always be right there inside your repo.
- [A layout that compresses HTML](http://jch.penibelst.de/): GitHub Pages compatible, configurable way to compress HTML files on site build.
- [Jekyll CO₂](https://github.com/wdenton/jekyll-co2): Generates HTML showing the monthly change in atmospheric CO₂ at the Mauna Loa observatory in Hawaii.
- [remote-include](http://www.northfieldx.co.uk/remote-include/): Includes files using remote URLs
- [jekyll-minifier](https://github.com/digitalsparky/jekyll-minifier): Minifies HTML, XML, CSS, and Javascript both inline and as separate files utilising yui-compressor and htmlcompressor.
- [Jekyll views router](https://bitbucket.org/nyufac/jekyll-views-router): Simple router between generator plugins and templates.
- [Jekyll Language Plugin](https://github.com/vwochnik/jekyll-language-plugin): Jekyll 3.0-compatible multi-language plugin for posts, pages and includes.
- [Jekyll Deploy](https://github.com/vwochnik/jekyll-deploy): Adds a `deploy` sub-command to Jekyll.
- [Official Contentful Jekyll Plugin](https://github.com/contentful/jekyll-contentful-data-import): Adds a `contentful` sub-command to Jekyll to import data from Contentful.
- [jekyll-paspagon](https://github.com/KrzysiekJ/jekyll-paspagon): Sell your posts in various formats for cryptocurrencies.
- [Hawkins](https://github.com/awood/hawkins): Adds a `liveserve` sub-command to Jekyll that incorporates [LiveReload](http://livereload.com/) into your pages while you preview them.  No more hitting the refresh button in your browser!
- [Jekyll Autoprefixer](https://github.com/vwochnik/jekyll-autoprefixer): Autoprefixer integration for Jekyll
- [Jekyll-breadcrumbs](https://github.com/git-no/jekyll-breadcrumbs): Creates breadcrumbs for Jekyll 3.x, includes features like SEO optimization, optional breadcrumb item translation and more.
- [generator-jekyllized](https://github.com/sondr3/generator-jekyllized): A Yeoman generator for rapidly developing sites with Gulp. Live reload your site, automatically minify and optimize your assets and much more.
- [Jekyll-Spotify](https://github.com/MertcanGokgoz/Jekyll-Spotify): Easily output Spotify Embed Player for jekyll
- [jekyll-menus](https://github.com/forestryio/jekyll-menus): Hugo style menus for your Jekyll site... recursive menus included.
- [jekyll-data](https://github.com/ashmaroli/jekyll-data): Read data files within Jekyll Theme Gems.
- [jekyll-pinboard](https://github.com/snaptortoise/jekyll-pinboard-plugin): Access your Pinboard bookmarks within your Jekyll theme.
- [jekyll-migrate-permalink](https://github.com/mpchadwick/jekyll-migrate-permalink): Adds a `migrate-permalink` sub-command to help deal with side effects of changing your permalink.
- [Jekyll-Post](https://github.com/robcrocombe/jekyll-post): A CLI tool to easily draft, edit, and publish Jekyll posts.
- [jekyll-numbered-headings](https://github.com/muratayusuke/jekyll-numbered-headings): Adds ordered number to headings.
- [jekyll-pre-commit](https://github.com/mpchadwick/jekyll-pre-commit): A framework for running checks against your posts using a git pre-commit hook before you publish them.
- [jekyll-pwa-plugin](https://github.com/lavas-project/jekyll-pwa): A plugin provides PWA support for Jekyll. It generates a service worker in Jekyll build process and makes precache and runtime cache available in the runtime with Google Workbox.

<div class="note info">
  <h5>Jekyll Plugins Wanted</h5>
  <p>
    If you have a Jekyll plugin that you would like to see added to this list,
    you should <a href="../contributing/">read the contributing page</a> to find
    out how to make that happen.
  </p>
</div>
