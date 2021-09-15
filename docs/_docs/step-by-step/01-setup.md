---
layout: step
title: Setup
menu_name: Step by Step Tutorial
position: 1
---
Welcome to Jekyll's step-by-step tutorial. This tutorial takes
you from having some front-end web development experience to building your
first Jekyll site from scratch without relying on the default gem-based theme.

## Installation

Jekyll is a Ruby gem. First, install Ruby on your machine. 
Go to [Installation]({{ '/docs/installation/' | relative_url }}) and follow the
instructions for your operating system.

With Ruby installed, install Jekyll from the terminal:

```sh
gem install jekyll bundler
```

Create a new `Gemfile` to list your project's dependencies:

```sh
bundle init
```

Edit the `Gemfile` in a text editor and add jekyll as a dependency:

```ruby
gem "jekyll"
```

Run `bundle` to install jekyll for your project.

You can now prefix all jekyll commands listed in this tutorial with `bundle exec`
to make sure you use the jekyll version defined in your `Gemfile`.

## Create a site

It's time to create a site! Create a new directory for your site and name
it whatever you want. Through the rest of this tutorial we'll refer to this
directory as **root**.

You can also initialize a Git repository here.

One of the great things about Jekyll is there's no database. All content and
site structure are files that a Git repository can version. Using a repository
is optional but is recommended. You can learn more
about using Git by reading the
[Git Handbook](https://guides.github.com/introduction/git-handbook/).

Let's add your first file. Create `index.html` in **root** with the following
content:

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Home</title>
  </head>
  <body>
    <h1>Hello World!</h1>
  </body>
</html>
```

## Build

Since Jekyll is a static site generator, it has to build the site
before we can view it. Run either of the following commands to build your site:

* `jekyll build` - Builds the site and outputs a static site to a directory
called `_site`.
* `jekyll serve` - Does `jekyll build` and runs it on a local web server at `http://localhost:4000`, rebuilding the site any time you make a change.

{: .note .info}
When you're developing a site, use `jekyll serve`. To force the browser to refresh with every change, use `jekyll serve --livereload`.
If there's a conflict or you'd like Jekyll to serve your development site at a different URL, use the `--host` and `--port` arguments,
as described in the [serve command options]({{ '/docs/configuration/options/#serve-command-options' | relative_url }}).

{: .note .warning}
The version of the site that `jekyll serve` builds in `_site` is not suited for deployment. Links and asset URLs in sites created
with `jekyll serve` will use `https://localhost:4000` or the value set with command-line configuration, instead of the values set
in [your site's configuration file]({{ '/docs/configuration/' | relative_url }}). To learn about how to build your site when it's
ready for deployment, read the [Deployment]({{ '/docs/step-by-step/10-deployment/' | relative_url }}) section of this tutorial.


Run `jekyll serve` and go to
<a href="http://localhost:4000" target="_blank" data-proofer-ignore>http://localhost:4000</a> in
your browser. You should see "Hello World!".

At this point, you might be thinking, "So what?". The only thing that happened was that Jekyll copied an
HTML file from one place to another. 

Patience, young grasshopper, there's
still much to learn!

Next. you'll learn about Liquid and templating.
