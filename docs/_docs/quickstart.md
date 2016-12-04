---
layout: docs
title: Quick-start guide
permalink: /docs/quickstart/
---

If you already have [Ruby](https://www.ruby-lang.org/en/downloads/) and [RubyGems](https://rubygems.org/pages/download) installed (see Jekyll's [requirements](/docs/installation/#requirements/)), you can create a new Jekyll site by doing the following:

```sh
~ $ gem install jekyll bundler 
# installs Jekyll and Bundler through RubyGems
~ $ jekyll new myblog 
# Creates a new Jekyll site called myblog
~ $ cd myblog
~/myblog $ bundle exec jekyll serve 
# Builds the site on the preview server
# Now browse to http://localhost:4000
```

The `jekyll new myblog` command installs a new Jekyll site into a subdirectory called `myblog`. The `jekyll new` command automatically initiates `bundle install` to install the dependencies required. (To skip `bundle install`, you can add the following flag: `jekyll new myblog --skip-bundle`.) {% comment %} why would someone want to skip bundle install -- seems unnecessary to even mention it. {% endcomment %}

To install jekyll into the directory you're currently in, run `jekyll new .` (If the existing directory isn't empty, you'll also have to pass the `--force` option with `jekyll new . --force`.)  

## Understanding gem-based themes

By default, Jekyll installs a gem-based theme called [Minima](https://github.com/jekyll/minima). With [gem-based themes](/docs/themes/), some of the theme directories and files are stored in the gem, hidden from view in your Jekyll project. As a result, the files and directories shown for your new blog are minimal and include only the following:

```
├── Gemfile
├── Gemfile.lock
├── _config.yml
├── _posts
│   └── 2016-12-04-welcome-to-jekyll.markdown
├── about.md
└── index.md
```

The Gemfiles are what Bundler uses to keep track of the required gems and gem versions you need for project.

Gem-based themes make it easy for theme authors to remotely update the theme for everyone who has the gem. When there's an update, they push the update to RubyGems. You can then run `bundle update` to update all gems in your project (or `bundle update minima` to just update the minima gem). Any new files or updates the theme author has made (such as to stylesheets or includes) will be pulled into your project automatically.

The goal of gem-based themes is to allow you to get all the benefits of a robust, continually updated theme without having all the theme's files getting in your way and over-complicating what might be your primary focus: creating content.

If you need to, you can add theme files into your project &mdash; for example, custom styles or includes. Any files you add locally will overwrite the gem's files. 

## Seeing all the gem-based theme's files

Some people prefer to see all the theme's files directly in their Jekyll project. For example, you may be trying to understand how Jekyll works, or you may be modifying the theme. If you want, you can copy over the gem's files and even remove the theme gem.

To copy the gem's files directly into your Jekyll folder:

1.  Run `bundle show minima`. 
    
    The location of the minimal gem is returned &mdash; usually `/usr/local/lib/ruby/gems/2.3.0/gems/minima-2.1.0` on a Mac. 
    
2.  Copy the path to Minima, change to its directory, and then open its location:

    ```
    cd /usr/local/lib/ruby/gems/2.3.0/gems/minima-2.1.0
    open . 
    # for Windows, use "explorer ."
    ```
    
    A Finder or Explorer window opens showing the Minima files and directories, which include _includes, _layouts, _sass, assets, LICENSE.txt, README.md.
     
3.  Copy these files into your `/myblog` directory.
4.  To remove the gem from the theme:
    
    *  Open **Gemfile** and remove `gem "minima", "~> 2.0"`. 
    *  Open **_config.yml** and remove `theme: minima`. 
    
5.  To build and preview the site, run `bundle exec jekyll serve`.

You've now copied all gem files into your theme directory and removed the gem from the theme. `bundle update` will no longer get updates for the minima gem.

## Gem-based themes and Github Pages

If you're publishing your Jekyll site on [Github Pages](https://pages.github.com/), note that Github Pages supports only some gem-based themes. (Gem-based themes are a new feature.) See [Supported Themes](https://pages.github.com/themes/) in Github's documentation to see which themes are supported. (Currently only Minima is supported.) 

## Using other themes

The `jekyll new <sitename>` command isn't the only way to create a new Jekyll site. You can also simply [find a Jekyll theme](https://www.google.com/search?q=jekyll+themes&oq=jekyll+themes) you like, download the theme, and run the following commands to install and start Jekyll:

```sh
~ $ gem install jekyll bundler 
# installs Jekyll and Bundler through RubyGems. 
~ $ bundle exec jekyll serve
```

The `gem install jekyll bundler` command installs the [jekyll](https://rubygems.org/gems/jekyll/) and [bundler](https://rubygems.org/gems/bundler) gems through [RubyGems](https://rubygems.org/). You need only to install the gems one time &mdash; not every time you create a new Jekyll project. 

`bundler` is a gem that manages other RubyGems. It makes sure your gems and gem versions are compatible, and that you have all necessary dependencies each gem requires. 

Bundler gets its information from the Gemfile and Gemfile.lock files in your theme. If your theme doesn't have these Gemfiles, you can omit `bundle exec` and just run `jekyll serve`.

The Gemfile stores the required gems and allowed gem versions. The versions often indicate a range of allowed versions rather than an exact version. Gemfile.lock records the exact versions of the gem that were used. When you run `bundle exec jekyll serve`, Bundler uses the gems and versions as specified in Gemfile.lock to ensure your Jekyll site builds with no compatibility or dependency conflicts.

## Next steps

Building the default theme is just the first step. The real magic happens when you start creating blog posts, using the front matter to control templates and layouts, and taking advantage of all the awesome configuration options Jekyll makes available.
