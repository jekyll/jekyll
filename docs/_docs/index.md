---
title: Quickstart
permalink: /docs/
redirect_from:
  - /docs/home/
  - /docs/quickstart/
  - /docs/extras/
---
Jekyll is a simple, extendable, static site generator. You give it text written
in your favorite markup language and it churns through layouts to create a
static website. Throughout that process you can tweak how you want the site URLs
to look, what data gets displayed in the layout, and more.

## Instructions

1. Install a full [Ruby development environment](/docs/installation/)
2. Install Jekyll and [bundler](/docs/ruby-101/#bundler) [gems](/docs/ruby-101/#gems)
```
gem install jekyll bundler
```
3. Create a new Jekyll site at `./myblog`
```
jekyll new myblog
```
4. Change into your new directory
```
cd myblog
```
5. Build the site and make it available on a local server
```
bundle exec jekyll serve
```
6. Now browse to [http://localhost:4000](http://localhost:4000){:target="_blank"}

If you encounter any unexpected errors during the above, please refer to the
[troubleshooting](/docs/troubleshooting/#configuration-problems) page or the
already-mentioned [requirements](/docs/installation/#requirements) page, as
you might be missing development headers or other prerequisites.
