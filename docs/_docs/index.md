---
title: Quickstart
permalink: /docs/
redirect_from:
  - /docs/home/
  - /docs/quickstart/
  - /docs/extras/
---
Jekyll is a static site generator. You give it text written in your
favorite markup language and it uses layouts to create a static website. You can
tweak how you want the site URLs to look, what data gets displayed on the
site, and more.

## Prerequisites

See [requirements]({{ '/docs/installation/#requirements' | relative_url }}).

## Instructions

1. Install a full [Ruby development environment]({{ '/docs/installation/' | relative_url }}).
2. Install Jekyll and [bundler]({{ '/docs/ruby-101/#bundler' | relative_url }}) [gems]({{ '/docs/ruby-101/#gems' | relative_url }}).
```
gem install jekyll bundler
```
3. Create a new Jekyll site at `./myblog`.
```
jekyll new myblog
```
4. Change into your new directory.
```
cd myblog
```
5. Build the site and make it available on a local server.
```
bundle exec jekyll serve
```
6. Browse to [http://localhost:4000](http://localhost:4000){:target="_blank"}

If you encounter any errors during this process, see the
[troubleshooting]({{ '/docs/troubleshooting/#configuration-problems' | relative_url }}) page. Also,
make sure you've installed the development headers and other prerequisites as
mentioned on the [requirements]({{ '/docs/installation/#requirements' | relative_url }}) page.

Note: Installation might be different depending on your operating system. See our [guides](https://jekyllrb.com/docs/installation/#guides) for OS specific instructions.