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

