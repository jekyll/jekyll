---
title: Quickstart
permalink: /docs/
redirect_from:
  - /docs/home/
  - /docs/quickstart/
  - /docs/extras/
---
Jekyll is a static site generator. It takes text written in your
favorite markup language and uses layouts to create a static website. You can
tweak the site's look and feel, URLs, the data displayed on the page, and more. 

## Setup

1. Install all [prerequisites]({{ '/docs/installation/' | relative_url }}) (basicly Ruby **{{ site.data.ruby.min_version }}** or higher, GCC and Make.
2. Install the jekyll and bundler [gems]({{ '/docs/ruby-101/#gems' | relative_url }}).
```sh
gem install jekyll bundler
```

## Create a site

1. Create a new Jekyll site at `./my-awesome-site`.
```sh
jekyll new my-awesome-site
```

2. Change into your new directory.
```sh
cd my-awesome-site
```

Jekyll automatically creates several files and directories to help start your site faster.

3. Edit file `index.markdown` in `./my-awesome-site`, replacing its content with:
```markdown
---
layout: home
title: My really awesome site!
---
# My really awesome site

Lots of awesome things!
```

## Check the result

Build the site and make it available on a local server.
```sh
bundle exec jekyll serve
```

Now, browse to [http://localhost:4000](http://localhost:4000){:target="_blank"}

## Use version control (Git)

You can initialize a Git repository on your site's directory. 

One of the great things about Jekyll is there’s no database. All content and site structure are files that a Git repository can version. Using a repository is optional but is recommended. You can learn more about using Git by reading the Git Handbook.

{: .note .warning}
If you are using Ruby version 3.0.0 or higher, step 5 [may fail](https://github.com/github/pages-gem/issues/752). You may fix it by adding `webrick` to your dependencies: `bundle add webrick`

{: .note .info}
Pass the `--livereload` option to `serve` to automatically refresh the page with each change you make to the source files: `bundle exec jekyll serve --livereload`


If you encounter any errors during this process, check that you have installed all the prerequisites in [Requirements]({{ '/docs/installation/#requirements' | relative_url }}). 
If you still have issues, see [Troubleshooting]({{ '/docs/troubleshooting/#configuration-problems' | relative_url }}).

{: .note .info}
Installation varies based on your operating system. See our [guides]({{ '/docs/installation/#guides' | relative_url }}) for OS-specific instructions.
