---
title: Jekyll on macOS
permalink: /docs/installation/macos/
---

## Supported macOS versions

- Monterey (macOS 12)
- Big Sur (macOS 11)
- Catalina (macOS 10.15)

Older macOS versions might work, but we don't officially support them.

## Install Ruby

To install Jekyll on macOS, you need a proper Ruby development environment. While macOS comes preinstalled with Ruby, we don't recommend using that version to install Jekyll. This external article goes over the various reasons [why you shouldn't use the system Ruby](https://www.moncefbelyamani.com/why-you-shouldn-t-use-the-system-ruby-to-install-gems-on-a-mac/).

Instead, you'll need to install a separate and newer version of Ruby using a version manager such as [asdf](https://asdf-vm.com/), [chruby](https://github.com/postmodern/chruby), [rbenv](https://github.com/rbenv/rbenv), or [rvm](https://rvm.io/). Version managers allow you to easily install multiple versions of Ruby, and switch between them.

We recommend `chruby` because it's the most reliable and easiest to use. Follow this external guide for [installing Jekyll on a Mac](https://www.moncefbelyamani.com/how-to-install-jekyll-on-a-mac-the-easy-way/) and setting up a proper Ruby environment with `chruby`.

## Install Jekyll

After installing Ruby with chruby, install Jekyll and Bundler:

```sh
gem install bundler jekyll
```

## Troubleshooting

See [Troubleshooting]({{ '/docs/troubleshooting/' | relative_url }}) or [ask for help on our forum](https://talk.jekyllrb.com).
