---
layout: docs
title: Installation
prev_section: home
next_section: usage
---

Getting Jekyll installed and ready-to-go should only take a few minutes. If it ever becomes a pain in the ass, you should [file an issue](../issues) (or submit a pull request) about what might be a better way to do things.

### Requirements

Installing Jekyll is easy and straight-forward, but there’s a few requirements you’ll need to make sure your system has before you start.

- [Ruby](http://www.ruby-lang.org/en/downloads/)
- [RubyGems](http://rubygems.org/pages/download)
- Linux, Unix, or Mac OS X

Note: It is possible to get [Jekyll running on Windows](http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html), however the official documentation does not support installation on Windows platforms.

## Install with RubyGems

The best way to install Jekyll is via
[RubyGems](http://docs.rubygems.org/read/chapter/3). At the terminal prompt, simply run the following command to install Jekyll:

{% highlight bash %}
gem install jekyll
{% endhighlight %}

All Jekyll’s gem dependancies are automatically installed by the above command, so you won’t have to worry about them at all. If you have problems installing Jekyll, check out the [troubleshooting](../troubleshooting) page or [report an issue](../issues) so the Jekyll community can improve the experience for everyone.

## Optional Extras

There are a number of (optional) extra features that Jekyll supports that you may want to install, depending on how you plan to use Jekyll. These extras include syntax highlighting of code snippets using [Pygments](http://pygments.org/), LaTeX support, and the use of alternative content rendering engines. Check out [the extras page](../extras) for more information.
