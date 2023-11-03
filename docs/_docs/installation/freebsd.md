---
title: Jekyll on FreeBSD
permalink: /docs/installation/freebsd/
---

### Install Ruby

```sh
sudo pkg install ruby
```

### Install Ruby Gems

Find the latest version and install it. (Replace `ruby3x` with whatever the latest version is.)

```sh
pkg search gems
sudo pkg install ruby3x-gems
```

## Set Gems directory and add that to the Bash path

Avoid installing RubyGems packages (called gems) as the root user. Instead,
set up a gem installation directory for your user account. The following
commands will add environment variables to your `~/.bashrc` file to configure
the gem installation path:

```sh
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Install Jekyll Gems

```sh
gem install jekyll bundler jekyll-sitemap
```

## Verify install

Both of these commands should return some output showing version number, etc.

```sh
ruby -v
jekyll -v
```

That's it! You're ready to start using Jekyll.
