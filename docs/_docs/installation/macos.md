---
title: Jekyll on macOS
permalink: /docs/installation/macos/
---

First, you need to install the command-line tools to be able to compile native extensions, open a terminal and run:

```sh
xcode-select --install
```

## Set up Ruby included with the OS

Check your Ruby version meets our requirements. Jekyll requires Ruby 2.2.5 or above. If you're running an older version you'll need to [install a more recent Ruby version](#rbenv).

```sh
ruby -v
ruby 2.3.7p456 (2018-03-28 revision 63024) [universal.x86_64-darwin18]
```

Now install Jekyll and [Bundler](/docs/ruby-101/#bundler).

```sh
gem install bundler jekyll
```

### Install a more recent Ruby version with rbenv {#rbenv}

Developers often use [rbenv](https://github.com/rbenv/rbenv) to manage multiple
Ruby versions. This can be useful when the version included with the OS is
too old or when you want to run the same version as your colleagues/collaborators.

```sh
# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install rbenv and ruby-build
brew install rbenv

# Setup rbenv integration to your shell
rbenv init

# Check your install
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
```

Restart your terminal for changes to take effect.
Now we can install the Ruby version of our choice, let's go with Ruby 2.5.3 here:

```sh
rbenv install 2.5.3
rbenv global 2.5.3
ruby -v
ruby 2.5.3p105 (2018-10-18 revision 65156) [x86_64-darwin18]
```

That's it! Head over [rbenv command references](https://github.com/rbenv/rbenv#command-reference) to learn how to use different versions of Ruby in your projects.

### Problems?

Check out the [troubleshooting](/docs/troubleshooting/) page or [ask for help on our forum](https://talk.jekyllrb.com).
