---
layout: docs
title: Quick-start guide
permalink: /docs/quickstart/
---

If you already have [Ruby](https://www.ruby-lang.org/en/downloads/) and [RubyGems](https://rubygems.org/pages/download) installed (see Jekyll's [requirements](/docs/installation/#requirements/)), you can create a new Jekyll site by doing the following:

```sh
# Install Jekyll and Bundler through RubyGems
~ $ gem install jekyll bundler 

# Create a new Jekyll site at ./myblog
~ $ jekyll new myblog 

# Change into your new directory
~ $ cd myblog

# Build the site on the preview server
~/myblog $ bundle exec jekyll serve 

# Now browse to http://localhost:4000
```

`gem install jekyll bundler` installs the [jekyll](https://rubygems.org/gems/jekyll/) and [bundler](https://rubygems.org/gems/bundler) gems through [RubyGems](https://rubygems.org/). You need only to install the gems one time &mdash; not every time you create a new Jekyll project. Here are some additional details:

* `bundler` is a gem that manages other RubyGems. It makes sure your gems and gem versions are compatible, and that you have all necessary dependencies each gem requires. 
* The Gemfile and Gemfile.lock files inform Bundler about the gem requirements in your theme. If your theme doesn't have these Gemfiles, you can omit `bundle exec` and just run `jekyll serve`.

* When you run `bundle exec jekyll serve`, Bundler uses the gems and versions as specified in Gemfile.lock to ensure your Jekyll site builds with no compatibility or dependency conflicts.

`jekyll new <PATH>` installs a new Jekyll site at the path specified (relative to current directory). In this case, Jekyll will be installed in a directory called `myblog`. Here are some additional details:

* To install jekyll into the directory you're currently in, run `jekyll new .` If the existing directory isn't empty, you'll have to pass the `--force` option with `jekyll new . --force`.  
* `jekyll new` automatically initiates `bundle install` to install the dependencies required. If you don't want Bundler to install the gems, add `jekyll new myblog --skip-bundle`.
* By default, Jekyll installs a gem-based theme called [Minima](https://github.com/jekyll/minima). With gem-based themes, some of the theme directories and files are stored in the gem, hidden from view in your Jekyll project. To better understand themes, see [Themes](../themes).

## Next steps

Building the default theme is just the first step. The real magic happens when you start creating blog posts, using the front matter to control templates and layouts, and taking advantage of all the awesome configuration options Jekyll makes available.
