---
title: Jekyll on macOS
permalink: /docs/installation/macos/
---

First, you need to install the command-line tools to be able to compile native extensions, open a terminal and run:

```sh
xcode-select --install
```

:warning: We strongly recommend that you install Ruby gems in your home directory in order to avoid file permissions and the use of `sudo`. To change the default gem path, add those line to your shell config file (e.g. `~/.bash_profile`):

```
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
```

Relaunch your terminal and run `gem env` to check that default gem paths point to you home directory.

## Set up Ruby included with the OS

Jekyll requires Ruby > 2.2.5 — we recommend that you run Ruby > 2.3 though, as more and more dependencies ask for that requirement. You're good to go on macOS Mojave 10.14:

```sh
ruby -v
ruby 2.3.7p456 (2018-03-28 revision 63024) [universal.x86_64-darwin18]
```

You can install Jekyll and [Bundler](/docs/ruby-101/#bundler):

```sh
gem install bundler jekyll
```

### Install latest stable Ruby with Homebrew {#brew}

To run latest Ruby version you need to install it through [Homebrew](https://brew.sh).

```sh
# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install ruby
```

Don't forget to add the brew ruby path to your shell config :

```
export PATH=/usr/local/opt/ruby/bin:$PATH
```

Then relaunch your terminal and check your updated Ruby setup:

```
which ruby
/usr/local/opt/ruby/bin/ruby

ruby -v
ruby 2.5.3p105 (2018-10-18 revision 65156) [x86_64-darwin18]
```

Yay, we are now running current stable Ruby!

We can install bundler and jekyll:

```sh
gem install bundler jekyll
```

That's it, you're ready to roll!

### Manage multiple Ruby environments with rbenv {#rbenv}

People often use [rbenv](https://github.com/rbenv/rbenv) to manage multiple
Ruby versions. This is very useful when you need to be able to run a given Ruby version on a project.

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
Now you can install the Ruby version of our choice, let's go with current latest stable Ruby:

```sh
rbenv install 2.5.3
rbenv global 2.5.3
ruby -v
ruby 2.5.3p105 (2018-10-18 revision 65156) [x86_64-darwin18]
```

That's it! Head over [rbenv command references](https://github.com/rbenv/rbenv#command-reference) to learn how to use different versions of Ruby in your projects.

### Problems?

Check out the [troubleshooting](/docs/troubleshooting/) page or [ask for help on our forum](https://talk.jekyllrb.com).
