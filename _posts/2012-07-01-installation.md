---
layout: docs
title: Installation
prev_section: home
next_section: usage
---

Getting Jekyll installed and ready-to-go should only take a few minutes.

### Requirements

Installing Jekyll is easy and straight-forward, but there’s a few requirements you’ll need to make sure your system has before you start.

- Ruby
- RubyGems
- Linux, Unix, or Mac OS X

Note that it is possible to get [Jekyll running on Windows](http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html), however the official documentation does not support installation on Windows platforms.

## Install with RubyGems

The best way to install Jekyll is via
[RubyGems](http://docs.rubygems.org/read/chapter/3). At the terminal prompt, simply run the following command to install Jekyll:

{% highlight bash %}
gem install jekyll
{% endhighlight %}

Jekyll requires the gems `directory_watcher`, `liquid`, `open4`, `maruku` and `classifier`. These are automatically installed by the `gem install` command.

### Installation Problems

If you encounter errors during gem installation, you may need to install
the header files for compiling extension modules for ruby 1.9.1. This
can be done on Debian systems by running:

{% highlight bash %}
sudo apt-get install ruby1.9.1-dev
{% endhighlight %}

or on Red Hat, CentOS, and Fedora systems by running:

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

To install gem on Gentoo:

{% highlight bash %}
sudo emerge -av dev-ruby/rubygems
{% endhighlight %}

On Windows, you may need to install [RubyInstaller
DevKit](http://wiki.github.com/oneclick/rubyinstaller/development-kit).

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

##### Homebrew

Alternatively, you can install Pygments with [Homebrew](http://mxcl.github.com/homebrew/), an excellent package manager for OS X:
{% highlight bash %}
brew install python
# export PATH="/usr/local/share/python:${PATH}"
easy_install pip
pip install --upgrade distribute
pip install pygments
{% endhighlight %}

**ProTip™**: Homebrew doesn’t symlink the executables for you. For the Homebrew default Cellar location and Python 2.7, be sure to add `/usr/local/share/python` to your `PATH`. For more information, check out [the Homebrew wiki](https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python).

##### MacPorts

If you use MacPorts, you can install Pygments by running:

{% highlight bash %}
sudo port install python25 py25-pygments
{% endhighlight %}

Seriously though, you should check out [Homebrew](http://mxcl.github.com/homebrew/)—it’s awesome.


**On Archlinux:**

`sudo pacman -S python-pygments`\
Or to use python2 for pygments:\
`sudo pacman -S python2-pygments`\
**Note**: python2 pygments version creates a `pygmentize2` executable,
while jekyll tries to find `pygmentize`. \
Either create a symlink
`# ln -s /usr/bin/pygmentize2 /usr/bin/pygmentize` or use the python3
version. (This advice seems to be outdated — python2-pygments does
install pygmentize).

**On Ubuntu and Debian:**

`sudo apt-get install python-pygments`

**On Fedora:**

`sudo yum install python-pygments`

**On Gentoo:**

`sudo emerge -av dev-python/pygments`

### LaTeX to PNG

Maruku comes with optional support for LaTeX to PNG rendering via
blahtex (Version 0.6) which must be in your \$PATH along with `dvips`.

(NOTE: [remi’s fork of
Maruku](http://github.com/remi/maruku/tree/master) does not assume a
fixed location for `dvips` if you need that fixed)

### RDiscount

If you prefer to use
[RDiscount](http://github.com/rtomayko/rdiscount/tree/master) instead of
[Maruku](http://maruku.rubyforge.org/) for markdown, just make sure it’s
installed:

`sudo gem install rdiscount`

And run Jekyll with the following option:

`jekyll --rdiscount`

Or, in your `_config.yml` file put the following so you don’t have to
specify the flag:

`markdown: rdiscount`

