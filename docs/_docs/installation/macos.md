---
title: Jekyll on macOS
permalink: /docs/installation/macos/
---

## Install Command Line Tools
To install the command line tools to compile native extensions, open a terminal and run:

```sh
xcode-select --install
```

## Install Ruby

Jekyll requires **Ruby v{{ site.data.ruby.min_version }}** or higher.
macOS Catalina 10.15 ships with Ruby 2.6.3. Check your Ruby version using `ruby -v`.

If you're running a previous version of macOS, you'll have to install a newer version of Ruby.

### With Homebrew {#brew}
To run the latest Ruby version you need to install it through [Homebrew](https://brew.sh).

```sh
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Ruby
brew install ruby
```

Add the brew ruby path to your shell configuration:

```bash
# If you're using Zsh
echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.zshrc

# If you're using Bash
echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.bash_profile

# Unsure which shell you are using? Type
echo $SHELL
```

Relaunch your terminal and check your Ruby setup:

```sh
which ruby
# /usr/local/opt/ruby/bin/ruby

ruby -v
{{ site.data.ruby.current_version_output }}
```

You're now running the current stable version of Ruby!

### With rbenv {#rbenv}

People often use [rbenv](https://github.com/rbenv/rbenv) to manage multiple
Ruby versions. This is very useful when you need to be able to run a given Ruby version on a project.

```sh
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install rbenv and ruby-build
brew install rbenv

# Set up rbenv integration with your shell
rbenv init

# Check your installation
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
```

Restart your terminal to apply your changes.
Next, you can install the Ruby version you want. Let's install the latest stable version:

```sh
rbenv install {{ site.data.ruby.current_version }}
rbenv global {{ site.data.ruby.current_version }}
ruby -v
{{ site.data.ruby.current_version_output }}
```

That's it! Head over to [rbenv command references](https://github.com/rbenv/rbenv#command-reference) to learn how to use different versions of Ruby in your projects.

## Install Jekyll

After installing Ruby, install Jekyll and Bundler.

### Local Install

Install the bundler and jekyll gems:

```sh
gem install --user-install bundler jekyll
```

Get your Ruby version:

```sh
ruby -v
{{ site.data.ruby.current_version_output }}
```

Append your path file with the following, replacing the `X.X` with the first two digits of your Ruby version:

```bash
# If you're using Zsh
echo 'export PATH="$HOME/.gem/ruby/X.X.0/bin:$PATH"' >> ~/.zshrc

# If you're using Bash
echo 'export PATH="$HOME/.gem/ruby/X.X.0/bin:$PATH"' >> ~/.bash_profile

# Unsure which shell you are using? Type
echo $SHELL
```

Check that `GEM PATHS:` points to your home directory:

```sh
gem env
```

{: .note .info}
Every time you update Ruby to a version in which the first two digits change, update your path to match.

### Global Install

{: .note .warning}
We recommend not installing Ruby gems globally to avoid file permissions problems and using `sudo`.

#### On Mojave (10.14)

Because of SIP Protections in Mojave, run:

```sh
sudo gem install bundler
sudo gem install -n /usr/local/bin/ jekyll
```

#### Before Mojave (<10.14)

Run:

```sh
sudo gem install bundler jekyll
```

## Troubleshooting

See [Troubleshooting]({{ '/docs/troubleshooting/' | relative_url }}) or [ask for help on our forum](https://talk.jekyllrb.com).
