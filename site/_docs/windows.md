---
layout: docs
title: Jekyll on Windows
permalink: /docs/windows/
---

While Windows is not an officially-supported platform, it can be used to run
Jekyll with the proper tweaks. This page aims to collect some of the general
knowledge and lessons that have been unearthed by Windows users.

## Installation

Julian Thilo has written up instructions to get
[Jekyll running on Windows][windows-installation] and it seems to work for most.
The instructions were written for Ruby 2.0.0, but should work for later versions
[prior to 2.2][hitimes-issue].

## Encoding

If you use UTF-8 encoding, make sure that no `BOM` header
characters exist in your files or very, very bad things will happen to
Jekyll. This is especially relevant if you're running Jekyll on Windows.

Additionally, you might need to change the code page of the console window to UTF-8
in case you get a "Liquid Exception: Incompatible character encoding" error during
the site generation process. It can be done with the following command:

{% highlight bash %}
$ chcp 65001
{% endhighlight %}

[windows-installation]: http://jekyll-windows.juthilo.com/
[hitimes-issue]: https://github.com/copiousfreetime/hitimes/issues/40

## Auto-regeneration

As of v1.3.0, Jekyll uses the `listen` gem to watch for changes when the
`--watch` switch is specified during a build or serve. While `listen` has
built-in support for UNIX systems, it requires an extra gem for compatibility
with Windows. Add the following to the Gemfile for your site:

{% highlight ruby %}
gem 'wdm', '~> 0.1.0' if Gem.win_platform?
{% endhighlight %}
