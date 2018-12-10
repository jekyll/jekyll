---
title: Plugins
permalink: /docs/plugins/installation/
---

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
  <h5>Plugins on GitHub Pages</h5>
  <p>
    <a href="https://pages.github.com/">GitHub Pages</a> is powered by Jekyll.
    All Pages sites are generated using the <code>--safe</code> option
    to disable plugins (with the exception of some
    <a href="https://pages.github.com/versions">whitelisted plugins</a>) for
    security reasons. Unfortunately, this means
    your plugins won’t work if you’re deploying to GitHub Pages.<br><br>
    You can still use GitHub Pages to publish your site, but you’ll need to
    convert the site locally and push the generated static files to your GitHub
    repository instead of the Jekyll source files.
  </p>
</div>

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
