---
title: Installation
permalink: /docs/installation/
---

Getting Jekyll installed and ready-to-go should only take a few minutes.
If it ever becomes a pain, please [file an issue]({{ site.repository }}/issues/new)
(or submit a pull request) describing the issue you
encountered and how we might make the process easier.

### Requirements

Jekyll is a [RubyGem](https://rubygems.org), and there are several ways it can
be installed. We'll cover some of them below.
Before you start, make sure your system has the following:

- GNU/Linux, Unix, or macOS
- [Ruby](https://www.ruby-lang.org/en/downloads/) version 2.2.5 or above, including all development
  headers (ruby installation can be checked by running `ruby -v`, development headers can be checked on Ubuntu by running `apt list --installed  ruby-dev`)
- [RubyGems](https://rubygems.org/pages/download) (which you can check by running `gem -v`)
- [GCC](https://gcc.gnu.org/install/) and [Make](https://www.gnu.org/software/make/) (in case your system doesn't have them installed, which you can check by running `gcc -v`,`g++ -v`  and `make -v` in your system's command line interface)

<div class="note info">
  <h5>Problems installing Jekyll?</h5>
  <p>
    Check out the <a href="../troubleshooting/">troubleshooting</a> page or
    <a href="{{ site.repository }}/issues/new">report an issue</a> so the
    Jekyll community can improve the experience for everyone.
  </p>
</div>

<div class="note info">
  <h5>Using Ubuntu?</h5>
  <p>
    This command will install any missing requirements:
    <code>sudo apt-get install ruby ruby-dev build-essential</code>
  </p>
</div>

<div class="note info">
  <h5>Running Jekyll on Windows</h5>
  <p>
    While Windows is not officially supported, it is possible to get Jekyll running
    on Windows. Special instructions can be found on our
    <a href="../windows/#installation">Windows-specific docs page</a>.
  </p>
</div>

## Install & Use Jekyll with Bundler

To use Jekyll with [Bundler](https://bundler.io/), add it as a
dependency of your project. It can be installed in a sub-directory of the
project. This avoids permissions issues, and also allows you to use different
versions of Jekyll with different projects.

First, install Bundler (as a system-wide gem):
```sh
sudo gem install bundler
```

Then, add Jekyll to your project's dependencies:

```sh
cd my-jekyll-project
bundle init                          # Creates an empty Gemfile
bundle install --path vendor/bundle  # Set install path to ./vendor/bundle
bundle add jekyll                    # Add & install Jekyll gem
```

Now, run Jekyll commands inside `bundle exec`, like `bundle exec jekyll serve`.

## Install with RubyGems

Jekyll can also be installed like any other gem with
[RubyGems](https://rubygems.org/pages/download). Simply run the following
command in a terminal to install Jekyll:

```sh
gem install jekyll
```

All of Jekyll’s gem dependencies are automatically installed by the above
command, so you won’t have to worry about them at all.

<div class="note info">
  <h5>Permissions Issues?</h5>
  <p>
    The above command performs a system-wide install of jekyll (on most
    systems). If you get a permissions error, you can either run the command as root
    (<code>sudo gem install jekyll</code>) or use
    <a href="https://rvm.io/gemsets/basics">RVM</a> to manage your Gems.
  </p>
</div>

<div class="note info">
  <h5>Installing Xcode Command-Line Tools</h5>
  <p>
    If you run into issues installing Jekyll's dependencies which make use of
    native extensions and are using macOS, you will need to install Xcode
    and the Command-Line Tools it ships with. Download them in
    <code>Preferences &#8594; Downloads &#8594; Components</code>.
  </p>
</div>

## Pre-releases

In order to install a pre-release, make sure you have all the requirements
installed properly and run:

```sh
gem install jekyll --pre
```

This will install the latest pre-release. If you want a particular pre-release,
use the `-v` switch to indicate the version you'd like to install:

```sh
gem install jekyll -v '2.0.0.alpha.1'
```

If you'd like to install a development version of Jekyll, the process is a bit
more involved. This gives you the advantage of having the latest and greatest,
but may be unstable.

```sh
git clone git://github.com/jekyll/jekyll.git
cd jekyll
script/bootstrap
bundle exec rake build
ls pkg/*.gem | head -n 1 | xargs gem install -l
```

## Optional Extras

There are a number of (optional) extra features that Jekyll supports that you
may want to install, depending on how you plan to use Jekyll. These extras
include LaTeX support, and the use of alternative content rendering engines.
Check out [the extras page](../extras/) for more information.

<div class="note">
  <h5>ProTip™: Enable Syntax Highlighting</h5>
  <p>
    If you’re the kind of person who is using Jekyll, then chances are you’ll
    want to enable syntax highlighting using <a href="http://pygments.org/">Pygments</a>
    or <a href="https://github.com/jayferd/rouge">Rouge</a>. You should really
    <a href="../templates/#code-snippet-highlighting">check out how to
    do that</a> before you go any farther.
  </p>
</div>

## Already Have Jekyll?

Before you start developing with Jekyll, you may want to check that you're up to
date with the latest version. To find your version of Jekyll, run one of these
commands:

```sh
jekyll --version
gem list jekyll
```

You can also use [RubyGems](https://rubygems.org/gems/jekyll) to find the
current version of any gem. Or you can use the `gem` command line tool:

```sh
gem search jekyll --remote
```

You just search for the name `jekyll`, and the latest version will be shown
between the brackets. Another way to check if you have the latest version is to
run the command `gem outdated`. This will provide a list of all the gems on your
system that need to be updated. If you aren't running the latest version, you
should update.

If you're using Bundler to manage your Gemfile, run:

```sh
bundle update jekyll
```

Otherwise, if you installed Jekyll with the `gem` command, you should run:

```sh
gem update jekyll
```

Please refer to our [upgrading section](../upgrading/) for major updates
detailed instructions.

Now that you’ve got everything up-to-date and installed, let’s get to work!
