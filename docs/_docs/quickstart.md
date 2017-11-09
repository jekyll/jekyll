---
title: Quick-start guide
permalink: /docs/quickstart/
---


If you already have a full [Ruby](https://www.ruby-lang.org/en/downloads/) development environment with all headers and [RubyGems](https://rubygems.org/pages/download) installed (see Jekyll's [requirements](/docs/installation/#requirements)), you can create a new Jekyll site by doing the following:

```sh
# Install Jekyll and Bundler gems through RubyGems
gem install jekyll bundler

# Create a new Jekyll site at ./myblog
jekyll new myblog

# Change into your new directory
cd myblog

# Build the site on the preview server
bundle exec jekyll serve

# Now browse to http://localhost:4000
```

If you encounter any unexpected errors during the above, please refer to the [troubleshooting](/docs/troubleshooting/#configuration-problems) page or the already-mentioned [requirements](/docs/installation/#requirements) page, as you might be missing development headers or other prerequisites.

## About Bundler

`gem install jekyll bundler` installs the [jekyll](https://rubygems.org/gems/jekyll/) and [bundler](https://rubygems.org/gems/bundler) gems through [RubyGems](https://rubygems.org/). You need only to install the gems one time &mdash; not every time you create a new Jekyll project. Here are some additional details:

* `bundler` is a gem that manages other Ruby gems. It makes sure your gems and gem versions are compatible, and that you have all necessary dependencies each gem requires.
* The `Gemfile` and `Gemfile.lock` files inform Bundler about the gem requirements in your site. If your site doesn't have these Gemfiles, you can omit `bundle exec` and just run `jekyll serve`.

* When you run `bundle exec jekyll serve`, Bundler uses the gems and versions as specified in `Gemfile.lock` to ensure your Jekyll site builds with no compatibility or dependency conflicts.

## Options for creating a new site with Jekyll

`jekyll new <PATH>` installs a new Jekyll site at the path specified (relative to current directory). In this case, Jekyll will be installed in a directory called `myblog`. Here are some additional details:

* To install the Jekyll site into the directory you're currently in, run `jekyll new .` If the existing directory isn't empty, you can pass the `--force` option with `jekyll new . --force`.
* `jekyll new` automatically initiates `bundle install` to install the dependencies required. (If you don't want Bundler to install the gems, use `jekyll new myblog --skip-bundle`.)
* By default, the Jekyll site installed by `jekyll new` uses a gem-based theme called [Minima](https://github.com/jekyll/minima). With [gem-based themes](../themes), some of the directories and files are stored in the theme-gem, hidden from your immediate view.
* We recommend setting up Jekyll with a gem-based theme but if you want to start with a blank slate, use `jekyll new myblog --blank`
* To learn about other parameters you can include with `jekyll new`, type `jekyll new --help`.

When in doubt, use the <code>help</code> command to remind you of all available options and usage, it also works with the <code>new</code>, <code>build</code> and <code>serve</code> subcommands, e.g. <code>jekyll help new</code> or <code>jekyll help build</code>.
{: .note .info }

## Next steps

Building a Jekyll site with the default theme is just the first step. The real magic happens when you start creating blog posts, using the front matter to control templates and layouts, and taking advantage of all the awesome configuration options Jekyll makes available.
