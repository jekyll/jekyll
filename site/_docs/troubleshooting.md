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

{% highlight shell %}
sudo apt-get install ruby2.0.0-dev
{% endhighlight %}

On Red Hat, CentOS, and Fedora systems you can do this by running:

{% highlight shell %}
sudo yum install ruby-devel
{% endhighlight %}

If you installed the above - specifically on Fedora 23 - but the extensions would still not compile, you are probably running a Fedora image that misses the `redhat-rpm-config` package. To solve this, simply run:

{% highlight shell %}
sudo dnf install redhat-rpm-config
{% endhighlight %}


On [NearlyFreeSpeech](https://www.nearlyfreespeech.net/) you need to run the
following commands before installing Jekyll:

{% highlight shell %}
export GEM_HOME=/home/private/gems
export GEM_PATH=/home/private/gems:/usr/local/lib/ruby/gems/1.8/
export PATH=$PATH:/home/private/gems/bin
export RB_USER_INSTALL='true'
{% endhighlight %}

To install RubyGems on Gentoo:

{% highlight shell %}
sudo emerge -av dev-ruby/rubygems
{% endhighlight %}

On Windows, you may need to install [RubyInstaller
DevKit](https://wiki.github.com/oneclick/rubyinstaller/development-kit).

On Mac OS X, you may need to update RubyGems (using `sudo` only if necessary):

{% highlight shell %}
sudo gem update --system
{% endhighlight %}

If you still have issues, you can download and install new Command Line
Tools (such as `gcc`) using the command

{% highlight shell %}
xcode-select --install
{% endhighlight %}

which may allow you to install native gems using this command (again using
`sudo` only if necessary):

{% highlight shell %}
sudo gem install jekyll
{% endhighlight %}

Note that upgrading Mac OS X does not automatically upgrade Xcode itself
(that can be done separately via the App Store), and having an out-of-date
Xcode.app can interfere with the command line tools downloaded above. If
you run into this issue, upgrade Xcode and install the upgraded Command
Line Tools.

### Jekyll &amp; Mac OS X 10.11

With the introduction of System Integrity Protection, several directories
that were previously writable are now considered system locations and are no
longer available. Given these changes, there are a couple of simple ways to get
up and running. One option is to change the location where the gem will be
installed (again using `sudo` only if necessary):

{% highlight shell %}
sudo gem install -n /usr/local/bin jekyll
{% endhighlight %}

Alternatively, Homebrew can be installed and used to set up Ruby. This can be
done as follows:

{% highlight shell %}
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
{% endhighlight %}

Once Homebrew is installed, the second step is easy:

{% highlight shell %}
brew install ruby
{% endhighlight %}

Advanced users (with more complex needs) may find it helpful to choose one of a
number of Ruby version managers ([RVM][], [rbenv][], [chruby][], [etc][].) in
which to install Jekyll.

[RVM]: https://rvm.io
[rbenv]: http://rbenv.org
[chruby]: https://github.com/postmodern/chruby
[etc]: https://github.com/rvm/rvm/blob/master/docs/alt.md

If you elect to use one of the above methods to install Ruby, it might be
necessary to modify your `$PATH` variable using the following command:

{% highlight shell %}
export PATH=/usr/local/bin:$PATH
{% endhighlight %}

GUI apps can modify the `$PATH` as follows:

{% highlight shell %}
launchctl setenv PATH "/usr/local/bin:$PATH"
{% endhighlight %}

Either of these approaches are useful because `/usr/local` is considered a
"safe" location on systems which have SIP enabled, they avoid potential
conflicts with the version of Ruby included by Apple, and it keeps Jekyll and
its dependencies in a sandboxed environment. This also has the added
benefit of not requiring `sudo` when you want to add or remove a gem.

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

{% highlight shell %}
jekyll serve --baseurl '/blog'
{% endhighlight %}

… then make sure that you access the site at:

{% highlight shell %}
http://localhost:4000/blog/index.html
{% endhighlight %}

It won’t work to just access:

{% highlight shell %}
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

{% highlight shell %}
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
