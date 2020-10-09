---
title: Jekyll on Ubuntu
permalink: /docs/installation/ubuntu/
---

## Install dependencies

Install Ruby and other [prerequisites]({{ '/docs/installation/#requirements' | relative_url }}):

```sh
sudo apt-get install ruby-full build-essential zlib1g-dev
```

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

Finally, install Jekyll and Bundler:

```sh
gem install jekyll bundler
```

That's it! You're ready to start using Jekyll.
