---
layout: docs
title: Troubleshooting
permalink: /docs/troubleshooting/
---

If you ever run into problems installing or using Jekyll, here are a few tips
that might be of help. If the problem you’re experiencing isn’t covered below,
**please [check out our other help resources](/help/)** as well.

- [Installation Problems](#installation-problems)
- [Problems running Jekyll](#problems-running-jekyll)
- [Base-URL Problems](#base-url-problems)
- [Configuration problems](#configuration-problems)
- [Markup Problems](#markup-problems)

## Installation Problems

If you encounter errors during gem installation, you may need to install
the header files for compiling extension modules for Ruby 2.0.0. This
can be done on Ubuntu or Debian by running:

{% highlight bash %}
sudo apt-get install ruby2.0.0-dev
{% endhighlight %}

On Red Hat, CentOS, and Fedora systems you can do this by running:

{% highlight bash %}
sudo yum install ruby-devel
{% endhighlight %}

On [NearlyFreeSpeech](https://www.nearlyfreespeech.net/) you need to run the
following commands before installing Jekyll:

{% highlight bash %}
export GEM_HOME=/home/private/gems
export GEM_PATH=/home/private/gems:/usr/local/lib/ruby/gems/1.8/
export PATH=$PATH:/home/private/gems/bin
export RB_USER_INSTALL='true'
{% endhighlight %}

On Mac OS X, you may need to update RubyGems:

{% highlight bash %}
sudo gem update --system
{% endhighlight %}

If you still have issues, you may need to [use Xcode to install Command Line
Tools](http://www.zlu.me/ruby/os%20x/gem/mountain%20lion/2012/02/21/install-native-ruby-gem-in-mountain-lion-preview.html)
that will allow you to install native gems using the following command:

{% highlight bash %}
sudo gem install jekyll
{% endhighlight %}

To install RubyGems on Gentoo:

{% highlight bash %}
sudo emerge -av dev-ruby/rubygems
{% endhighlight %}

On Windows, you may need to install [RubyInstaller
DevKit](https://wiki.github.com/oneclick/rubyinstaller/development-kit).

### Could not find a JavaScript runtime. (ExecJS::RuntimeUnavailable)

This error can occur during the installation of `jekyll-coffeescript` when
you don't have a proper JavaScript runtime. To solve this, either install
`execjs` and `therubyracer` gems, or install `nodejs`. Check out
[issue #2327](https://github.com/jekyll/jekyll/issues/2327) for more info.

## Problems running Jekyll

On Debian or Ubuntu, you may need to add `/var/lib/gems/1.8/bin/` to your path
in order to have the `jekyll` executable be available in your Terminal.

## Base-URL Problems

If you are using base-url option like:

{% highlight bash %}
jekyll serve --baseurl '/blog'
{% endhighlight %}

… then make sure that you access the site at:

{% highlight bash %}
http://localhost:4000/blog/index.html
{% endhighlight %}

It won’t work to just access:

{% highlight bash %}
http://localhost:4000/blog
{% endhighlight %}

## Configuration problems

The order of precedence for conflicting [configuration settings](../configuration/)
is as follows:

1. Command-line flags
2. Configuration file settings
3. Defaults

That is: defaults are overridden by options specified in `_config.yml`,
and flags specified at the command-line will override all other settings
specified elsewhere.

## Markup Problems

The various markup engines that Jekyll uses may have some issues. This
page will document them to help others who may run into the same
problems.

### Liquid

The latest version, version 2.0, seems to break the use of `{{ "{{" }}` in
templates. Unlike previous versions, using `{{ "{{" }}` in 2.0 triggers the
following error:

{% highlight bash %}
'{{ "{{" }}' was not properly terminated with regexp: /\}\}/  (Liquid::SyntaxError)
{% endhighlight %}

### Excerpts

Since v1.0.0, Jekyll has had automatically-generated post excerpts. Since
v1.1.0, Jekyll also passes these excerpts through Liquid, which can cause
strange errors where references don't exist or a tag hasn't been closed. If you
run into these errors, try setting `excerpt_separator: ""` in your
`_config.yml`, or set it to some nonsense string.

<div class="note">
  <h5>Please report issues you encounter!</h5>
  <p>
  If you come across a bug, please <a href="{{ site.help_url }}/issues/new">create an issue</a>
  on GitHub describing the problem and any work-arounds you find so we can
  document it here for others.
  </p>
</div>
