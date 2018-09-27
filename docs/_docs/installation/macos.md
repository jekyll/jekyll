---
title: Jekyll on macOS
permalink: /docs/installation/macos/
---

First, you need to install the command-line tools to be able to compile native extensions, open a terminal and run:

```sh
xcode-select --install
```

## Set up Ruby included with the OS

Check your Ruby version meets our requirements. Jekyll requires Ruby 2.2.5 or above. If you're running an older version you'll need to [install a more recent Ruby version via Homebrew](#homebrew).

```sh
ruby -v
2.3.3
```

Now install Jekyll and [Bundler](/docs/ruby-101/#bundler).

```sh
gem install bundler jekyll
```

### Install a newer Ruby version via Homebrew {#homebrew}

If you wish to install the latest version of Ruby and get faster builds, we recommend doing it via [Homebrew](https://brew.sh) a handy package manager for macOS.

```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install ruby
ruby -v
ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin17]
```

### Install multiple Ruby versions with rbenv {#rbenv}

Developers often use [rbenv](https://github.com/rbenv/rbenv) to manage multiple
Ruby versions. This can be useful if you want to run the same Ruby version used
by your colleagues/collaborators.

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

### Problems?

Check out the [troubleshooting](/docs/troubleshooting/) page or [ask for help on our forum](https://talk.jekyllrb.com).
