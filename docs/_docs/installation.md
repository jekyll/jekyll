---
title: Installation
description: Official guide to install Jekyll on macOS, GNU/Linux or Windows.
permalink: /docs/installation/
---

- [Requirements](#requirements)
- [Install on macOS](#macOS)
- [Install on Windows](../windows/)
- [Upgrade Jekyll](#upgrade-jekyll)

Installing Jekyll should be straight-forward if your system meets the requirements.

## Requirements

Before you start, make sure your system has the following:

- [Ruby](https://www.ruby-lang.org/en/downloads/) version 2.2.5 or above, including all development headers (ruby installation can be checked by running `ruby -v`)
- [RubyGems](https://rubygems.org/pages/download) (which you can check by running `gem -v`)
- [GCC](https://gcc.gnu.org/install/) and [Make](https://www.gnu.org/software/make/) (in case your system doesn't have them installed, which you can check by running `gcc -v`,`g++ -v`  and `make -v` in your system's command line interface)

## Install on macOS {#macOS}

We only cover latest macOS High Sierra 10.13 here, which comes with Ruby 2.3.3, older systems will need to [install a more recent Ruby version via Homebrew](#homebrew).

First, you need to [install Xcode from the App Store](https://itunes.apple.com/app/xcode/id497799835?mt=12) or [from Apple Developer website](https://developer.apple.com/xcode/). Then to install the command-line tools, open a terminal and run:

```sh
xcode-select --install
```

Check your Ruby version, and upgrade [RubyGems](https://rubygems.org/pages/download):

```sh
ruby -v
2.3.3

gem update --system
```

Great, let's install Jekyll. We also need [bundler](https://bundler.io/) to help us handle [plugins](../plugins) and [themes](../themes):

```sh
gem install bundler jekyll
```

You're ready to go, either by installing our default jekyll blog theme with `jekyll new jekyll-website` or by starting from scratch:

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

From there you can either use a [theme](../themes/) or create your own layouts.

### Install via Homebrew {#homebrew}

You can install the latest version of Ruby via [Homebrew](https://brew.sh) a handy package manager for macOS.

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install ruby
```

### Install Rbenv

Developers often use [rbenv](https://github.com/rbenv/rbenv) to manage multiple Ruby versions.

```sh
# Install rbenv and ruby-build
brew install rbenv

# Setup rbenv integration to your shell
rbenv init

# Check your install
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
```

Restart your terminal for changes to take effect.
Now we can install the Ruby version of our choice, let's go with Ruby 2.5.0 here:

```sh
rbenv install 2.5.0
rbenv global 2.5.0
ruby -v
```

<div class="note info" markdown="1">

##### Problems installing Jekyll?

Check out the [troubleshooting](../troubleshooting/) page or
[ask for help on our forum](https://talk.jekyllrb.com).

</div>

## Upgrade Jekyll

Before you start developing with Jekyll, you may want to check that you're up to date with the latest version. To find the currently installed version of Jekyll, run one of these commands:

```sh
jekyll --version
gem list jekyll
```

You can use RubyGems to find [the current versioning of Jekyll](https://rubygems.org/gems/jekyll). Another way to check if you have the latest version is to run the command `gem outdated`. This will provide a list of all the gems on your system that need to be updated. If you aren't running the latest version, run this command:

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
