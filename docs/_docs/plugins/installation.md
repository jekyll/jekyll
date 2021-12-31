---
title: Plugins
permalink: /docs/plugins/installation/
---

Jekyll has built-in support for using plugins to extend the core functionality.

Primarily, any file with extension `.rb` placed within a `_plugins` directory at the root of the site's `source`, will be automatically loaded
during a build session.

This behavior can be configured as follows:

- The `_plugins` directory may be changed either directly via the command-line or via the configuration file(s).
- Plugins in the `_plugins` directory (or its equivalent(s)) will not be loaded when Jekyll is running in `safe` mode.
- This route cannot be used to extend the Jekyll CLI.

To work with plugins packaged as gems, one has to list the desired gems in the configuration file under a top-level key named `plugins`.
Additionally, if you're building in `safe` mode, the gem needs to be listed under a top-level key named `whitelist`. For example:

```yaml
plugins:
  - jekyll-gist
  - jekyll-coffeescript
  - jekyll-seo-tag
  - some-other-jekyll-plugin

# Enable safe mode
safe: true

# Whitelist plugins under safe mode.
# Note that `some-other-jekyll-plugin` is not listed here. Therefore,
# it will not be loaded under safe mode.
whitelist:
  - jekyll-gist
  - jekyll-coffeescript
  - jekyll-seo-tag
```

In the absence of a Gemfile, one must manually ensure that listed plugins have been installed prior to invoking Jekyll. For example, the
latest versions of gems in the above list may be installed to a system-wide location by running:

```sh
gem install jekyll-gist jekyll-coffeescript jekyll-remote-theme some-other-jekyll-plugin
```

## Using a Gemfile

The maintenance of various gem dependencies may be greatly simplified by using a Gemfile (usually at the root of the site's source) in
conjunction with a Rubygem named `bundler`. The Gemfile however **should** list all the primary dependencies of your site, including Jekyll
itself, not just gem-based plugins of the site because Bundler narrows the scope of installed gems to just *runtime dependencies* resolved by
evaluating the Gemfile. For example:

```ruby
source "https://rubygems.org"

# Use the latest version.
gem "jekyll"

# The theme of current site, locked to a certain version.
gem "minima", "2.4.1"

# Plugins of this site loaded during a build with proper
# site configuration.
gem "jekyll-gist"
gem "jekyll-coffeescript"
gem "jekyll-seo-tag", "~> 1.5"
gem "some-other-jekyll-plugin"

# A dependency of a custom-plugin inside `_plugins` directory.
gem "nokogiri", "~> 1.11"
```

The gems listed in the Gemfile can be collectively installed by simply running `bundle install`.

### The `:jekyll_plugins` Gemfile group
{: #the-jekyll_plugins-group}

Jekyll gives a special treatment to gems listed as part of the `:jekyll_plugins` group in a Gemfile. Any gem under this group is loaded at
the very beginning of any Jekyll process, irrespective of the `--safe` CLI flag or entries in the configuration file(s).

While this route allows one to enhance Jekyll's CLI with additional subcommands and options, or avoid having to list gems in the configuration
file, the downside is the necessity to be mindful of what gems are included in the group. For example:

```ruby
source "https://rubygems.org"

# Use the latest version.
gem "jekyll"

# The theme of current site, locked to a certain version.
gem "minima", "2.4.1"

# Plugins of this site loaded only if configured correctly.
gem "jekyll-gist"
gem "jekyll-coffeescript"

# Gems loaded irrespective of site configuration.
group :jekyll_plugins do
  gem "jekyll-cli-plus"
  gem "jekyll-seo-tag", "~> 1.5"
  gem "some-other-jekyll-plugin"
end
```

<div class="note info">
  <h5>Plugins on GitHub Pages</h5>
  <p>
    <a href="https://pages.github.com/">GitHub Pages</a> is powered by Jekyll. All GitHub Pages sites are generated using the
    <code>--safe</code> option to disable plugins (with the exception of some
    <a href="https://pages.github.com/versions">whitelisted plugins</a>) for security reasons. Unfortunately, this means your plugins won't
    work if you’re deploying via GitHub Pages.<br><br>
    You can still use GitHub Pages to publish your site, but you’ll need to build the site locally and push the generated files to your
    GitHub repository instead of the Jekyll source files.
  </p>
</div>

<div class="note">
  <h5>
    <code>_plugins</code>, <code>_config.yml</code> and <code>Gemfile</code> can be used simultaneously
  </h5>
  <p>
    You may use any of the aforementioned plugin routes simultaneously in the same site if you so choose.
    Use of one does not restrict the use of the others.
  </p>
</div>
