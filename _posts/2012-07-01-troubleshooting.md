---
layout: docs
title: Troubleshooting
previous: issues
next: sites
---

If you ever run into problems installing or using Jekyll, here’s a few tips that might be of help. If the problem you’re experiencing isn’t covered below, please [report an issue](../issues) so the Jekyll community can make everyone’s experience better.

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

If you are using base-url option like `jekyll --server --base-url '/blog'` then make sure that you access the site at `http://localhost:4000/blog/index.html`. Just accessing `http://localhost:4000/blog` will not work.

## Configuration problems


The order of precedence for conflicting [configuration settings](../configuration) is as follows:

1.  Command-line flags
2.  Configuration file settings
3.  Defaults

That is: defaults are overridden by options specified in `_config.yml`, and flags specified at the command-line will override all other settings specified elsewhere.

