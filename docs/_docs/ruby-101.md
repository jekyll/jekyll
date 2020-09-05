---
title: Ruby 101
permalink: /docs/ruby-101/
---

Jekyll is written in Ruby. If you're new to Ruby, this page helps you learn some of the terminology.

## Gems

Gems are code you can include in Ruby projects. Gems package specific functionality. You can share gems across multiple projects or with other people. 
Gems can perform actions like:

* Converting a Ruby object to JSON
* Pagination
* Interacting with APIs such as GitHub

Jekyll is a gem. Many Jekyll [plugins]({{ '/docs/plugins/' | relative_url }}) are also gems, including
[jekyll-feed](https://github.com/jekyll/jekyll-feed),
[jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) and
[jekyll-archives](https://github.com/jekyll/jekyll-archives).

## Gemfile

A `Gemfile` is a list of gems used by your site. Every Jekyll site has a Gemfile in the main folder. 

For a simple Jekyll site it might look something like this:

```ruby
source "https://rubygems.org"

gem "jekyll"

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
end
```

## Bundler

[Bundler](https://rubygems.org/gems/bundler) is a gem that installs all gems in your `Gemfile`. 

While you don't have to use `Gemfile` and `bundler`, it is highly recommended as it ensures you're running the same version of Jekyll and its plugins across different environments.

Install Bundler using `gem install bundler`. You only need to install it once, not every time you create a new Jekyll project. 

To install gems in your Gemfile using Bundler, run the following in the directory that has the Gemfile:

```
bundle install
bundle exec jekyll serve
```

To bypass Bundler if you aren't using a Gemfile, run `jekyll serve`.

See [Using Jekyll with Bundler](/tutorials/using-jekyll-with-bundler/) for more information about Bundler in Jekyll and for instructions to get up and running quickly.
