---
title: Plugins
permalink: /docs/plugins/installation/
---

There are three options for installing plugins:

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

## Plugins on GitHub Pages

[GitHub Pages](https://pages.github.com/) is powered by Jekyll.
However, all Pages sites are generated using the `--safe` option
to disable plugins (with the exception of some
[whitelisted plugins](https://pages.github.com/versions)) for
security reasons. Unfortunately, this means
your plugins won’t work if you’re deploying to GitHub Pages.

You can still use GitHub Pages to publish your site, but you’ll need to
convert the site locally and push the generated static files to your GitHub
repository instead of the Jekyll source files.

## jekyll_plugins group

Jekyll gives this particular group of gems in your `Gemfile` a different
treatment. Any gem included in this group is loaded before Jekyll starts
processing the rest of your source directory.

A gem included here will be activated even if its not explicitly listed under
the `plugins:` key in your site's config file.


Gems included in the `:jekyll-plugins` group are activated
regardless of the `--safe` mode setting. Be aware of what
gems are included under this group!
{: .warning }
