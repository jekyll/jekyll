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

Jekyll requires the gems `directory_watcher`, `liquid`, `open4`, `maruku` and `classifier`. These are automatically installed by the `gem install` command, so chances are you won’t have to worry about them at all.

If you have problems installing Jekyll, check out the [troubleshooting](../troubleshooting) page or [report an issue](../issues) so the Jekyll community can improve the experience for everyone.

## Optional Extras

There are a number of (optional) extra features that Jekyll supports that you may want to install, depending on how you plan to use Jekyll.

### Pygments

If you want syntax highlighting via the `{{ "{% highlight " }}%}` tag in your
posts, you’ll need to install [Pygments](http://pygments.org/).

#### Installing Pygments on OSX

Mac OS X (Leopard onwards) come preinstalled with Python, so on just about any OS X machine you can install Pygments simply by running:

{% highlight bash %}
sudo easy_install Pygments
{% endhighlight %}

##### Installing Pygments using Homebrew

Alternatively, you can install Pygments with [Homebrew](http://mxcl.github.com/homebrew/), an excellent package manager for OS X:
{% highlight bash %}
brew install python
# export PATH="/usr/local/share/python:${PATH}"
easy_install pip
pip install --upgrade distribute
pip install pygments
{% endhighlight %}

**ProTip™**: Homebrew doesn’t symlink the executables for you. For the Homebrew default Cellar location and Python 2.7, be sure to add `/usr/local/share/python` to your `PATH`. For more information, check out [the Homebrew wiki](https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python).

##### Installing Pygments using MacPorts

If you use MacPorts, you can install Pygments by running:

{% highlight bash %}
sudo port install python25 py25-pygments
{% endhighlight %}

Seriously though, you should check out [Homebrew](http://mxcl.github.com/homebrew/)—it’s awesome.


#### Installing Pygments on Arch Linux

You can install Pygments using the pacman package manager as follows:

{% highlight bash %}
sudo pacman -S python-pygments
{% endhighlight %}

Or to use python2 for Pygments:
{% highlight bash %}
sudo pacman -S python2-pygments
{% endhighlight %}

#### Installing Pygments on Ubuntu and Debian

{% highlight bash %}
sudo apt-get install python-pygments
{% endhighlight %}

#### Installing Pygments on RedHat, Fedora, and CentOS

{% highlight bash %}
sudo yum install python-pygments
{% endhighlight %}

#### Installing Pygments on Gentoo

{% highlight bash %}
sudo emerge -av dev-python/pygments
{% endhighlight %}

### LaTeX Support

Maruku comes with optional support for LaTeX to PNG rendering via
blahtex (Version 0.6) which must be in your `$PATH` along with `dvips`. If you need Maruku to not assume a fixed location for `dvips`, check out [Remi’s Maruku fork](http://github.com/remi/maruku).

### RDiscount

If you prefer to use [RDiscount](http://github.com/rtomayko/rdiscount) instead of [Maruku](http://maruku.rubyforge.org/) for markdown, just make sure you have it installed:

{% highlight bash %}
sudo gem install rdiscount
{% endhighlight %}

And then run Jekyll with the following option:

{% highlight bash %}
jekyll --rdiscount
{% endhighlight %}

Or, specify RDiscount as the markdown engine in your `_config.yml` file to have Jekyll run with that option by default (so you don’t have to specify the flag every time).

{% highlight bash %}
# In _config.yml
markdown: rdiscount
{% endhighlight %}

