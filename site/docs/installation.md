---
layout: docs
title: Installation
prev_section: quickstart
next_section: usage
permalink: /docs/installation/
---

Getting Jekyll installed and ready-to-go should only take a few minutes. If it
ever becomes a pain in the ass, please [file an
issue]({{ site.repository }}/issues/new) (or submit a pull request)
describing the issue you encountered and how we might make the process easier.

### Requirements

Installing Jekyll is easy and straight-forward, but there are a few requirements
you’ll need to make sure your system has before you start.

- [Ruby](http://www.ruby-lang.org/en/downloads/)
- [RubyGems](http://rubygems.org/pages/download)
- Linux, Unix, or Mac OS X

<div class="note info">
  <h5>Running Jekyll on Windows</h5>
  <p>
    It is possible to get
    <a href="http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html">
    Jekyll running on Windows</a>, but the official documentation does not
    support installation on Windows platforms.
  </p>
</div>

## Install with RubyGems

The best way to install Jekyll is via
[RubyGems](http://docs.rubygems.org/read/chapter/3). At the terminal prompt,
simply run the following command to install Jekyll:

{% highlight bash %}
$ gem install jekyll
{% endhighlight %}

All of Jekyll’s gem dependencies are automatically installed by the above
command, so you won’t have to worry about them at all. If you have problems
installing Jekyll, check out the [troubleshooting](../troubleshooting/) page or
[report an issue]({{ site.repository }}/issues/new) so the Jekyll
community can improve the experience for everyone.

<div class="note info">
  <h5>Installing Xcode Command-Line Tools</h5>
  <p>
    If you run into issues installing Jekyll's dependencies which make use of
    native extensions and are using Mac OS X, you will need to install Xcode
    and the Command-Line Tools it ships with. Download in
    <code>Preferences &#8594; Downloads &#8594; Components</code>.
  </p>
</div>

## Optional Extras

There are a number of (optional) extra features that Jekyll supports that you
may want to install, depending on how you plan to use Jekyll. These extras
include LaTeX support, and the use of alternative content rendering engines.
Check out [the extras page](../extras/) for more information.

<div class="note">
  <h5>ProTip™: Enable Syntax Highlighting</h5>
  <p>
    If you’re the kind of person who is using Jekyll, then chances are you’ll
    want to enable syntax highlighting using Pygments. You should really
    <a href="../templates/#code_snippet_highlighting">check out how to do
    that</a> before you go any further.
  </p>
</div>

Now that you’ve got everything installed, let’s get to work!
