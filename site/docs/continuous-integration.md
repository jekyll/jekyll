---
layout: docs
title: Continuous Integration
prev_section: deployment-methods
next_section: troubleshooting
permalink: /docs/continuous-integration/
---

You can easily test your website build against one or more versions of Ruby.
The following guide show how to set up a free build environment on [Travis][0],
with [GitHub][1] integration for pull requests. Paid alternatives exist for
private repositories.

[0]: https://travis-ci.org/
[1]: https://github.com/

## The Test Script

When testing static sites, there is no better tool than [html-proofer][].

## Enabling Travis and GitHub

## Configuring Your Travis Builds

This file is used to configure your Travis builds. Because Jekyll is built
with Ruby and requires RubyGems to install, we use the Ruby language build
environment. Below is a sample `.travis.yml` file, and what follows that is
an explanation of each line.
