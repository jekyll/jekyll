---
title: Ruby 101
permalink: /docs/ruby-101/
---

Jekyll is written in Ruby. If you're new to Ruby, this page is to help you get
up to speed with some of the terminology.

## Gems

A gem is code you can include in Ruby projects. It allows you to package up functionality and share it across other projects or with other people. Gems can perform functionality such as:

* Converting a Ruby object to JSON
* Pagination
* Interacting with APIs such as GitHub
* Jekyll itself is a gem as well as many Jekyll plugins including
[jekyll-feed](https://github.com/jekyll/jekyll-feed),
[jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) and
[jekyll-archives](https://github.com/jekyll/jekyll-archives).


## Gemfile

A `Gemfile` is a list of gems required for your site. For a simple Jekyll site it might look something like this:

```ruby
source "https://rubygems.org"

gem "jekyll"

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
end
```

## Bundler

Bundler installs the gems in your `Gemfile`. It's not a requirement for you to use a `Gemfile` and `bundler` however it's highly recommended as it ensures you're running the same version of Jekyll and Jekyll plugins across different environments.

`gem install bundler` installs [Bundler](https://rubygems.org/gems/bundler). You only need to install it once &mdash; not every time you create a new Jekyll project. Here are some additional details:

If you're using a `Gemfile` you would first run `bundle install` to install the gems, then `bundle exec jekyll serve` to build your site. This guarantees you're using the gem versions set in the `Gemfile`. If you're not using a `Gemfile` you can just run `jekyll serve`.

For more information about how to use Bundler in your Jekyll project, this [tutorial](/tutorials/using-jekyll-with-bundler/) should provide answers to the most common questions and explain how to get up and running quickly.
