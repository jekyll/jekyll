---
layout: docs
title: Installation
prev_section: home
next_section: structure
---

Installing Jekyll is easy and straight-forward, but there’s a few requirements you’ll need to make sure your system has before you start.

## Requirements

- Ruby
- RubyGems
- Linux, Unix, or Mac OS X


The best way to install Jekyll is via
[RubyGems](http://docs.rubygems.org/read/chapter/3):

`sudo gem install jekyll`

Jekyll requires the gems `directory_watcher`, `liquid`, `open4`,
`maruku` and `classifier`. These are automatically installed by the gem
install command.



If you encounter errors during gem installation, you may need to install
the header files for compiling extension modules for ruby 1.9.1. This
can be done on Debian systems by:

`sudo apt-get install ruby1.9.1-dev`

or on Red Hat / CentOS / Fedora systems by:

`sudo yum install ruby-devel`

On [NearlyFreeSpeech](http://nearlyfreespeech.net/) you need:

`RB_USER_INSTALL=true gem install jekyll`

If you encounter errors like `Failed to build gem native extension` on
Windows you may need to install [RubyInstaller
DevKit](http://wiki.github.com/oneclick/rubyinstaller/development-kit).

On OSX, you may need to update RubyGems:

`sudo gem update --system`

To install gem on Gentoo:

`sudo emerge -av dev-ruby/rubygems`

LaTeX to PNG
------------

Maruku comes with optional support for LaTeX to PNG rendering via
blahtex (Version 0.6) which must be in your \$PATH along with `dvips`.

(NOTE: [remi’s fork of
Maruku](http://github.com/remi/maruku/tree/master) does not assume a
fixed location for `dvips` if you need that fixed)

RDiscount
---------

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

Pygments
--------

If you want syntax highlighting via the `{{ "{% highlight " }}%}` tag in your
posts, you’ll need to install [Pygments](http://pygments.org/).

**On OS X Leopard, Snow Leopard:**\
It already comes preinstalled with Python 2.6\
`sudo easy_install Pygments`

**On OS X Lion:**\
OS X Lion comes preinstalled with Python 2.7\
`sudo easy_install Pygments`

**Alternatively on OS X with MacPorts:**\
`sudo port install python25 py25-pygments`

**Alternatively on OS X with Homebrew:**

    brew install python
    # export PATH="/usr/local/share/python:${PATH}"
    easy_install pip
    pip install --upgrade distribute
    pip install pygments

*Note: Homebrew doesn’t symlink the executables for you. For the
Homebrew default Cellar location and Python 2.7, be sure to add
`/usr/local/share/python` to your `PATH`:* For, more information, check
out [this](https://github.com/mxcl/homebrew/wiki/Homebrew-and-Python).

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
