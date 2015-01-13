---
layout: docs
title: GitHub Pages
permalink: /docs/github-pages/
---

[GitHub Pages](http://pages.github.com) are public web pages for users,
organizations, and repositories, that are freely hosted on GitHub's
`github.io` domain or on a custom domain name of your choice. GitHub Pages are
powered by Jekyll behind the scenes, so in addition to supporting regular HTML
content, they’re also a great way to host your Jekyll-powered website for free.

## Deploying Jekyll to GitHub Pages

GitHub Pages work by looking at certain branches of repositories on GitHub.
There are two basic types available: user/organization pages and project pages.
The way to deploy these two types of sites are nearly identical, except for a
few minor details.

<div class="note protip">
  <h5>Use the <code>github-pages</code> gem</h5>
  <p>
    Our friends at GitHub have provided the
    <a href="https://github.com/github/pages-gem">github-pages</a>
    gem which is used to manage Jekyll and its dependencies on
    GitHub Pages. Using it in your projects means that when you deploy
    your site to GitHub Pages, you will not be caught by unexpected
    differences between various versions of the gems. To use the
    currently-deployed version of the gem in your project, add the
    following to your <code>Gemfile</code>:

{% highlight ruby %}
source 'https://rubygems.org'

require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)

gem 'github-pages', versions['github-pages']
{% endhighlight %}

    This will ensure that when you run <code>bundle install</code>, you
    have the correct version of the <code>github-pages</code> gem.
  </p>
</div>

### User and Organization Pages

User and organization pages live in a special GitHub repository dedicated to
only the GitHub Pages files. This repository must be named after the account
name. For example, [@mojombo’s user page
repository](https://github.com/mojombo/mojombo.github.io) has the name
`mojombo.github.io`.

Content from the `master` branch of your repository will be used to build and
publish the GitHub Pages site, so make sure your Jekyll site is stored there.

<div class="note info">
  <h5>Custom domains do not affect repository names</h5>
  <p>
    GitHub Pages are initially configured to live under the
    <code>username.github.io</code> subdomain, which is why repositories must
    be named this way <strong>even if a custom domain is being used</strong>.
  </p>
</div>

### Project Pages

Unlike user and organization Pages, Project Pages are kept in the same
repository as the project they are for, except that the website content is
stored in a specially named `gh-pages` branch. The content of this branch will
be rendered using Jekyll, and the output will become available under a subpath
of your user pages subdomain, such as `username.github.io/project` (unless a
custom domain is specified—see below).

The Jekyll project repository itself is a perfect example of this branch
structure—the [master branch]({{ site.repository }}) contains the
actual software project for Jekyll, however the Jekyll website (that you’re
looking at right now) is contained in the [gh-pages
branch]({{ site.repository }}/tree/gh-pages) of the same repository.

<div class="note warning">
  <h5>Source Files Must be in the Root Directory</h5>
  <p>
Github Pages <a href="https://help.github.com/articles/troubleshooting-github-pages-build-failures#source-setting">overrides</a> the <a href="http://jekyllrb.com/docs/configuration/#global-configuration">“Site Source”</a> configuration value, so if you locate your files anywhere other than the root directory, your site may not build correctly.
  </p>
</div>


### Project Page URL Structure

Sometimes it's nice to preview your Jekyll site before you push your `gh-pages`
branch to GitHub. However, the subdirectory-like URL structure GitHub uses for
Project Pages complicates the proper resolution of URLs. Here is an approach to
utilizing the GitHub Project Page URL structure (`username.github.io/project-name/`)
whilst maintaining the ability to preview your Jekyll site locally.

1. In `_config.yml`, set the `baseurl` option to `/project-name` -- note the
   leading slash and the **absence** of a trailing slash.
2. When referencing JS or CSS files, do it like this:
   `{% raw %}{{ site.baseurl }}/path/to/css.css{% endraw %}` -- note the slash
   immediately following the variable (just before "path").
3. When doing permalinks or internal links, do it like this:
   `{% raw %}{{ site.baseurl }}{{ post.url }}{% endraw %}` -- note that there
   is **no** slash between the two variables.
4. Finally, if you'd like to preview your site before committing/deploying using
   `jekyll serve`, be sure to pass an **empty string** to the `--baseurl` option,
   so that you can view everything at `localhost:4000` normally (without
   `/project-name` at the beginning): `jekyll serve --baseurl ''`

This way you can preview your site locally from the site root on localhost,
but when GitHub generates your pages from the gh-pages branch all the URLs
will start with `/project-name` and resolve properly.

<div class="note">
  <h5>GitHub Pages Documentation, Help, and Support</h5>
  <p>
    For more information about what you can do with GitHub Pages, as well as for
    troubleshooting guides, you should check out <a
    href="https://help.github.com/categories/20/articles">GitHub’s Pages Help
    section</a>. If all else fails, you should contact <a
    href="https://github.com/contact">GitHub Support</a>.
  </p>
</div>
