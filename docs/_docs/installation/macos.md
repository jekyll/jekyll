---
title: Jekyll on macOS
permalink: /docs/installation/macos/
---

First, you need to install the command-line tools to be able to compile native extensions, open a terminal and run:

```sh
xcode-select --install
```

## Set up Ruby

Jekyll requires Ruby > {{ site.min_ruby_version }}.
As macOS Mojave 10.14 comes only with ruby 2.3.x, you'll have to install Ruby through Homebrew.

### Install latest stable Ruby with Homebrew {#brew}

To run the latest Ruby version you need to install it through [Homebrew](https://brew.sh).

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
ruby 2.6.2p47 (2019-03-13 revision 67232) [x86_64-darwin18]
```

Yay, we are now running current stable Ruby!

We can install bundler and jekyll:

```sh
gem install bundler jekyll
```

That's it, you're ready to roll!

{: .note }
We strongly recommend that you install Ruby gems in your home directory to avoid file permissions problems and using `sudo`.

You can do this with the `--user-install` option, for instance by running:

```sh
gem install --user-install bundler jekyll
```

Or you can change the default gem path, by adding those lines to your shell config file, .e.g. `~/.bash_profile` or `~/.bashrc` if your shell is bash:

```
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
```

Relaunch your terminal and run `gem env` to check that default gem paths point to your home directory by default.

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
rbenv install 2.6.2
rbenv global 2.6.2
ruby -v
ruby 2.6.2p47 (2019-03-13 revision 67232) [x86_64-darwin18]
```

That's it! Head over [rbenv command references](https://github.com/rbenv/rbenv#command-reference) to learn how to use different versions of Ruby in your projects.

### Problems?

Check out the [troubleshooting](/docs/troubleshooting/) page or [ask for help on our forum](https://talk.jekyllrb.com).
