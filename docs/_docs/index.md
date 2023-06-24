---
title: Quickstart
permalink: /docs/
redirect_from:
  - /docs/home/
  - /docs/quickstart/
  - /docs/extras/
---
Jekyll is a static site generator that takes your text file written in your desired markup language and format in the layouts to create the static website. You can further modify the look and feel, URLs, and displayed data on the webpage. 

## Prerequisites

The following are the prerequisites to run Jekyll:

* Ruby version **{{ site.data.ruby.min_version }}** or higher
* RubyGems
* GCC and Make

See [Requirements]({{ '/docs/installation/#requirements' | relative_url }}) for guides and details.

## Instructions

1. Install all the [prerequisites]({{ '/docs/installation/' | relative_url }}).
2. Install the jekyll and bundler [gems]({{ '/docs/ruby-101/#gems' | relative_url }}).
```sh
gem install jekyll bundler
```
3. Create a new Jekyll site at `./myblog`.
```sh
jekyll new myblog
```
4. Change into your new directory.
```sh
cd myblog
```
5. Build the site and make it available on a local server.
```sh
bundle exec jekyll serve
```
6. Browse to [http://localhost:4000](http://localhost:4000){:target="_blank"}

{: .note .warning}
If you are using Ruby version 3.0.0 or higher, step 5 [may fail](https://github.com/github/pages-gem/issues/752). You may fix it by adding `webrick` to your dependencies: `bundle add webrick`

{: .note .info}
Pass the `--livereload` option to `serve` to automatically refresh the page with each change you make to the source files: `bundle exec jekyll serve --livereload`


If you encounter any errors during installation, please ensure all prerequisites are installed correctly. [Requirements]({{ '/docs/installation/#requirements' | relative_url }}). 
If you still have issues, see [Troubleshooting]({{ '/docs/troubleshooting/#configuration-problems' | relative_url }}).

{: .note .info}
Installation procedure depends on your system's *operating system* (OS). Refer to our [guides]({{ '/docs/installation/#guides' | relative_url }}) for OS-specific instructions.
