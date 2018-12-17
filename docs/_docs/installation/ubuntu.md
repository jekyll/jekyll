---
title: Jekyll on Ubuntu
permalink: /docs/installation/ubuntu/
---
Before we install Jekyll, we need to make sure we have all the required
dependencies.

```sh
sudo apt-get install ruby-full build-essential zlib1g-dev
```

It is best to avoid installing Ruby Gems as the root user. Therefore, we need to
set up a gem installation directory for your user account. The following
commands will add environment variables to your `~/.bashrc` file to configure
the gem installation path. Run them now:

```sh
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Finally, install Jekyll:

```sh
gem install jekyll bundler
```

That's it! You're ready to start using Jekyll.
