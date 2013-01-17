---
layout: docs
title: Troubleshooting
prev_section: contributing
next_section: sites
---

If you ever run into problems installing or using Jekyll, here’s a few tips that might be of help. If the problem you’re experiencing isn’t covered below, please [report an issue](https://github.com/mojombo/jekyll/issues/new) so the Jekyll community can make everyone’s experience better.

## Installation Problems

If you encounter errors during gem installation, you may need to install
the header files for compiling extension modules for ruby 1.9.1. This
can be done on Ubunutu or Debian by running:

{% highlight bash %}
sudo apt-get install ruby1.9.1-dev
{% endhighlight %}

On Red Hat, CentOS, and Fedora systems you can do this by running:

{% highlight bash %}
sudo yum install ruby-devel
{% endhighlight %}

On [NearlyFreeSpeech](http://nearlyfreespeech.net/) you need to run the command with the following environment variable:

{% highlight bash %}
RB_USER_INSTALL=true gem install jekyll
{% endhighlight %}

On OSX, you may need to update RubyGems:

{% highlight bash %}
sudo gem update --system
{% endhighlight %}

To install RubyGems on Gentoo:

{% highlight bash %}
sudo emerge -av dev-ruby/rubygems
{% endhighlight %}

On Windows, you may need to install [RubyInstaller
DevKit](http://wiki.github.com/oneclick/rubyinstaller/development-kit).

## Problems running Jekyll

On Debian or Ubuntu, you may need to add /var/lib/gems/1.8/bin/ to your path in order to have the `jekyll` executable be available in your Terminal.

## Base-URL Problems

If you are using base-url option like `jekyll serve --baseurl '/blog'` then make sure that you access the site at `http://localhost:4000/blog/index.html`. Just accessing `http://localhost:4000/blog` will not work.

## Configuration problems


The order of precedence for conflicting [configuration settings](../configuration) is as follows:

1.  Command-line flags
2.  Configuration file settings
3.  Defaults

That is: defaults are overridden by options specified in `_config.yml`, and flags specified at the command-line will override all other settings specified elsewhere.

## Markup Problems

The various markup engines that Jekyll uses may have some issues. This
page will document them to help others who may run into the same
problems.

### Maruku

If your link has characters that need to be escaped, you need to use
this syntax:

`![Alt text](http://yuml.me/diagram/class/[Project]->[Task])`

If you have an empty tag, i.e. `<script src="js.js"></script>`, Maruku
transforms this into `<script src="js.js" />`. This causes problems in
Firefox and possibly other browsers and is [discouraged in
XHTML.](http://www.w3.org/TR/xhtml1/#C_3) An easy fix is to put a space
between the opening and closing tags.

### RedCloth

Versions 4.1.1 and higher do not obey the notextile tag. [This is a known
bug](http://aaronqian.com/articles/2009/04/07/redcloth-ate-my-notextile.html)
and will hopefully be fixed for 4.2. You can still use 4.1.9, but the
test suite requires that 4.1.0 be installed. If you use a version of
RedCloth that does not have the notextile tag, you may notice that
syntax highlighted blocks from Pygments are not formatted correctly,
among other things. If you’re seeing this just install 4.1.0.

### Liquid

The latest version, version 2.0, seems to break the use of `{{ "{{" }}` in
templates. Unlike previous versions, using `{{ "{{" }}` in 2.0 triggers the
following error:

{% highlight bash %}
'{{ "{{" }}' was not properly terminated with regexp: /\}\}/  (Liquid::SyntaxError)
{% endhighlight %}

<div class="note">
  <h5>Please report issues you encounter!</h5>
  <p>If you come across a bug, please <a href="https://github.com/mojombo/jekyll/issues/new">create an issue</a> on GitHub describing the problem and any work-arounds you find so we can document it here for others.</p>
</div>
