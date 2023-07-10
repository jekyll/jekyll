---
title: Jekyll on macOS
permalink: /docs/installation/macos/
---

## Supported macOS versions

- Ventura (macOS 13)
- Monterey (macOS 12)
- Big Sur (macOS 11)

Older macOS versions might work, but we don't officially support them.

## Install Ruby

To install Jekyll on macOS, you need a proper Ruby development environment. 
While macOS comes preinstalled with Ruby, we don't recommend using that version 
to install Jekyll. This external article goes over the various reasons 
[why you shouldn't use the system Ruby](https://www.moncefbelyamani.com/why-you-shouldn-t-use-the-system-ruby-to-install-gems-on-a-mac/).

Instead, you'll need to install a separate and newer version of Ruby using a 
version manager such as [asdf], [chruby], [rbenv], or [rvm]. Version managers 
allow you to easily install multiple versions of Ruby, and switch between them.

We recommend `chruby` because it's the simplest and least likely to cause issues. 

The instructions below are an excerpt from this detailed external guide to 
[install Ruby on Mac]. They work best if you're setting up development tools 
for the first time on your Mac. If you've already tried to install Ruby or 
Jekyll on your Mac, or if you run into any issues, read that guide. 

[asdf]: https://asdf-vm.com/
[chruby]: https://github.com/postmodern/chruby
[rbenv]: https://github.com/rbenv/rbenv
[rvm]: https://rvm.io/
[install Ruby on Mac]: https://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/

### Step 1: Install Homebrew

[Homebrew](https://brew.sh/) makes it easy to install development tools on a Mac.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Step 2: Install chruby and the latest Ruby with ruby-install

Install `chruby` and `ruby-install` with Homebrew:

```sh
brew install chruby ruby-install xz
```

Install the latest stable version of Ruby (supported by Jekyll):

```sh
ruby-install ruby {{ site.data.ruby.current_version }}
```

This will take a few minutes, and once it's done, configure your shell to 
automatically use `chruby`:

```sh
echo "source $(brew --prefix)/opt/chruby/share/chruby/chruby.sh" >> ~/.zshrc
echo "source $(brew --prefix)/opt/chruby/share/chruby/auto.sh" >> ~/.zshrc
echo "chruby ruby-{{ site.data.ruby.current_version }}" >> ~/.zshrc # run 'chruby' to see actual version
```

If you're using Bash, replace `.zshrc` with `.bash_profile`. If you're not sure, 
read this external guide to 
[find out which shell you're using](https://www.moncefbelyamani.com/which-shell-am-i-using-how-can-i-switch/).

Quit and relaunch Terminal, then check that everything is working:

```sh
ruby -v
```

It should show {{ site.data.ruby.current_version_output }} or a newer version.

Next, read that same external guide for important notes about 
[setting and switching between Ruby versions with chruby](https://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/#how-to-install-different-versions-of-ruby-and-switch-between-them).

## Install Jekyll

After installing Ruby with chruby, install the latest Jekyll gem:

```sh
gem install jekyll
```

## Troubleshooting

See [Troubleshooting]({{ '/docs/troubleshooting/' | relative_url }}) or [ask for help on our forum](https://talk.jekyllrb.com).
