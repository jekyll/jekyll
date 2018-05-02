---
title: Installation
description: Official guide to install Jekyll on macOS, GNU/Linux or Windows.
permalink: /docs/installation/
---

Jekyll is a [Ruby Gem](http://guides.rubygems.org/rubygems-basics/), and can be
installed on most systems.

- [Requirements](#requirements)
- [Install Jekyll on macOS](#macOS)
- [Install Jekyll on Ubuntu Linux](#ubuntu)
- [Install Jekyll on Windows](../windows/)
- [Upgrade Jekyll](#upgrade-jekyll)

## Requirements

Before you start, make sure your system has the following:

- [Ruby](https://www.ruby-lang.org/en/downloads/) version 2.2.5 or above, including all development headers (ruby installation can be checked by running `ruby -v`)
- [RubyGems](https://rubygems.org/pages/download) (which you can check by running `gem -v`)
- [GCC](https://gcc.gnu.org/install/) and [Make](https://www.gnu.org/software/make/) (in case your system doesn't have them installed, which you can check by running `gcc -v`,`g++ -v`  and `make -v` in your system's command line interface)

## Install on macOS {#macOS}

We only cover macOS High Sierra 10.13 here, which comes with Ruby 2.3.3, older systems will need to [install a more recent Ruby version via Homebrew](#homebrew).

First, you need to install the command-line tools to be able to compile native extensions, open a terminal and run:

```sh
xcode-select --install
```

### Set up Ruby included with the OS

Check your Ruby version meet our requirements:

```sh
ruby -v
2.3.3
```

Great, let's install Jekyll. We also need [Bundler](https://bundler.io/) to help us handle [plugins](../plugins) and [themes](../themes):

```sh
gem install bundler jekyll
```

That's it, you're ready to go, either by installing our [default minimal blog theme](https://github.com/jekyll/minima) with `jekyll new jekyll-website` or by starting from scratch:

```sh
mkdir jekyll-website
cd jekyll-website

# Create a Gemfile
bundle init

# Add Jekyll
bundle add jekyll

# Install gems
bundle install
```

Great, from there you can now either use a [theme](../themes/) or [create your own layouts](../templates/).

### Install a newer Ruby version via Homebrew {#homebrew}

If you wish to install the latest version of Ruby and get faster builds, we recommend to do it via [Homebrew](https://brew.sh) a handy package manager for macOS.

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install ruby
ruby -v
ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin17]
```

Yay! Now you have a shiny Ruby on your system!

### Install multiple Ruby versions with rbenv {#rbenv}

Developers often use [rbenv](https://github.com/rbenv/rbenv) to manage multiple Ruby versions. This can be useful if you want to run the same Ruby version used by [GitHub Pages](https://pages.github.com/versions/) or [Netlify](https://www.netlify.com/docs/#ruby) for instance.

```sh
# Install rbenv and ruby-build
brew install rbenv

# Setup rbenv integration to your shell
rbenv init

# Check your install
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
```

Restart your terminal for changes to take effect.
Now we can install the Ruby version of our choice, let's go with Ruby 2.5.1 here:

```sh
rbenv install 2.5.1
rbenv global 2.5.1
ruby -v
ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin17]
```

That's it! Head over [rbenv command references](https://github.com/rbenv/rbenv#command-reference) to learn how to use different versions of Ruby in your projects.

<div class="note info" markdown="1">

##### Problems installing Jekyll?

Check out the [troubleshooting](../troubleshooting/) page or
[ask for help on our forum](https://talk.jekyllrb.com).

</div>

## Install on Ubuntu Linux {#ubuntu}

Before we install Jekyll, we need to make sure we have all the required
dependencies.

```sh
sudo apt-get install ruby ruby-dev build-essential
```

It is best to avoid installing Ruby Gems as the root user. Therefore, we need to
set up a gem installation directory for your user account. The following
commands will add environment variables to your `~/.bashrc` file to configure
the gem installation path. Run them now:

```sh
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME=$HOME/gems' >> ~/.bashrc
echo 'export PATH=$HOME/gems/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Finally, install Jekyll:

```sh
gem install jekyll bundler
```

That's it! You're ready to start using Jekyll.

## Upgrade Jekyll

Before you start developing with Jekyll, you may want to check that you're up to date with the latest version. To find the currently installed version of Jekyll, run one of these commands:

```sh
jekyll --version
gem list jekyll
```

You can use RubyGems to find [the current version of Jekyll](https://rubygems.org/gems/jekyll). Another way to check if you have the latest version is to run the command `gem outdated`. This will provide a list of all the gems on your system that need to be updated. If you aren't running the latest version, run this command:

```sh
bundle update jekyll
```

Alternatively, if you don't have Bundler installed run:

```sh
gem update jekyll
```

To upgrade to latest Rubygems, run:

```
gem update --system
```

Refer to our [upgrading section](../upgrading/) to upgrade from Jekyll 2.x or 1.x.

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

Now that you’ve got everything up-to-date and installed, let’s get to work!
