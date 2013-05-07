---
layout: docs
title: GitHub Pages
prev_section: extras
next_section: deployment-methods
---

[GitHub Pages](http://pages.github.com) are public web pages for users,
organizations, and repositories, that are freely hosted on GitHub's
[github.io]() domain or on a custom domain name of your choice. GitHub Pages are
powered by Jekyll behind the scenes, so in addition to supporting regular HTML
content, they’re also a great way to host your Jekyll-powered website for free.

## Deploying Jekyll to GitHub Pages

GitHub Pages work by looking at certain branches of repositories on GitHub.
There are two basic types available: user/organization pages and project pages.
The way to deploy these two types of sites are nearly identical, except for a
few minor details.

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
structure—the [master branch](https://github.com/mojombo/jekyll) contains the
actual software project for Jekyll, however the Jekyll website (that you’re
looking at right now) is contained in the [gh-pages
branch](https://github.com/mojombo/jekyll/tree/gh-pages) of the same repository.

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
