---
title: Troubleshooting
permalink: /docs/troubleshooting/
---

If you ever run into problems installing or using Jekyll, here are a few tips
that might be of help. If the problem you’re experiencing isn’t covered below,
**please [check out our other help resources](/help/)** as well.

- [Installation Problems](#installation-problems)
- [Problems running Jekyll](#problems-running-jekyll)
- [Base-URL Problems](#base-url-problems)
- [Configuration problems](#configuration-problems)
- [Markup Problems](#markup-problems)
- [Production Problems](#production-problems)

## Installation Problems

If you encounter errors during gem installation, you may need to install
the header files for compiling extension modules for Ruby 2.x This
can be done on Ubuntu or Debian by running:

```sh
sudo apt-get install ruby2.6-dev
```

On Red Hat, CentOS, and Fedora systems you can do this by running:

```sh
sudo yum install ruby-devel
```

If you installed the above - specifically on Fedora 23 - but the extensions would still not compile, you are probably running a Fedora image that misses the `redhat-rpm-config` package. To solve this, run:

```sh
sudo dnf install redhat-rpm-config
```

On Arch Linux you need to run:

```sh
sudo pacman -S ruby-ffi
```

On Ubuntu if you get stuck after `bundle exec jekyll serve` and see error
messages like `Could not locate Gemfile` or `.bundle/ directory`, it's likely
because all requirements have not been fully met. Recent stock Ubuntu
distributions require the installation of both the `ruby` and `ruby-all-dev`
packages:

```sh
sudo apt-get install ruby ruby-all-dev
```

On [NearlyFreeSpeech](https://www.nearlyfreespeech.net/) you need to run the
following commands before installing Jekyll:

```sh
export GEM_HOME=/home/private/gems
export GEM_PATH=/home/private/gems:/usr/local/lib/ruby/gems/1.8/
export PATH=$PATH:/home/private/gems/bin
export RB_USER_INSTALL='true'
```

To install RubyGems on Gentoo:

```sh
sudo emerge -av dev-ruby/rubygems
```

On Windows, you may need to install [RubyInstaller
DevKit](https://wiki.github.com/oneclick/rubyinstaller/development-kit).

On Android (with Termux) you can install all requirements by running:

```sh
apt update && apt install libffi-dev clang ruby-dev make
```

On macOS, you may need to update RubyGems (using `sudo` only if necessary):

```sh
gem update --system
```

If you still have issues, you can download and install new Command Line
Tools (such as `gcc`) using the following command:

```sh
xcode-select --install
```

which may allow you to install native gems using this command (again, using
`sudo` only if necessary):

```sh
gem install jekyll
```

Note that upgrading macOS does not automatically upgrade Xcode itself
(that can be done separately via the App Store), and having an out-of-date
Xcode.app can interfere with the command line tools downloaded above. If
you run into this issue, upgrade Xcode and install the upgraded Command
Line Tools.

### Running Jekyll as Non-Superuser (no sudo!)
{: #no-sudo}

On most flavors of Linux, macOS, and Bash on Ubuntu on Windows, it is
possible to run Jekyll as a non-superuser and without having to install
gems to system-wide locations by adding the following lines to the end
of your `.bashrc` file:

```
# Ruby exports

export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
```

This tells `gem` to place its gems within the user's home folder,
not in a system-wide location, and adds the local `jekyll` command to the
user's `PATH` ahead of any system-wide paths.

This is also useful for many shared webhosting services, where user accounts
have only limited privileges. Adding these exports to `.bashrc` before running
`gem install jekyll bundler` allows a complete non-`sudo` install of Jekyll.

To activate the new exports, either close and restart Bash, logout and
log back into your shell account, or run `. .bashrc` in the
currently-running shell.

If you see the following error when running the `jekyll new` command,
you can solve it by using the above-described procedure:

```sh
jekyll new test

Running bundle install in /home/user/test...

Your user account is not allowed to install to the system RubyGems.
You can cancel this installation and run:

    bundle install --path vendor/bundle

to install the gems into ./vendor/bundle/, or you can enter your password
and install the bundled gems to RubyGems using sudo.

Password:
```

Once this is done, the `jekyll new` command should work properly for
your user account.

### Jekyll &amp; macOS

With the introduction of System Integrity Protection in v10.11, several directories
that were previously writable are now considered system locations and are no
longer available. Given these changes, there are a couple of simple ways to get
up and running. One option is to change the location where the gem will be
installed (again, using `sudo` only if necessary):

```sh
gem install -n /usr/local/bin jekyll
```

Alternatively, Homebrew can be installed and used to set up Ruby. This can be
done as follows:

```sh
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Once Homebrew is installed, the second step is to run:

```sh
brew install ruby
```

Advanced users (with more complex needs) may find it helpful to choose one of a
number of Ruby version managers ([RVM][], [rbenv][], [chruby][], [etc][].) in
which to install Jekyll.

[RVM]: https://rvm.io
[rbenv]: http://rbenv.org
[chruby]: https://github.com/postmodern/chruby
[etc]: https://github.com/rvm/rvm/blob/master/docs/alt.md

If you elect to use one of the above methods to install Ruby, it might be
necessary to modify your `$PATH` variable using the following command:

```sh
export PATH=/usr/local/bin:$PATH
```

GUI apps can modify the `$PATH` as follows:

```sh
launchctl setenv PATH "/usr/local/bin:$PATH"
```

Either of these approaches are useful because `/usr/local` is considered a
"safe" location on systems which have SIP enabled, they avoid potential
conflicts with the version of Ruby included by Apple, and it keeps Jekyll and
its dependencies in a sandboxed environment. This also has the added
benefit of not requiring `sudo` when you want to add or remove a gem.

### Could not find a JavaScript runtime. (ExecJS::RuntimeUnavailable)

This error can occur during the installation of `jekyll-coffeescript` when
you don't have a proper JavaScript runtime. To solve this, either install
`execjs` and `therubyracer` gems, or install `nodejs`. Check out
[issue #2327](https://github.com/jekyll/jekyll/issues/2327) for more info.

## Problems running Jekyll

On Debian or Ubuntu, you may need to add `/var/lib/gems/1.8/bin/` to your path
in order to have the `jekyll` executable be available in your Terminal.

## Base-URL Problems

If you are using base-url option like:

```sh
jekyll serve --baseurl '/blog'
```

… then make sure that you access the site at:

```
http://localhost:4000/blog/index.html
```

It won’t work to just access:

```
http://localhost:4000/blog
```

## Configuration problems

The order of precedence for conflicting [configuration settings](/docs/configuration/)
is as follows:

1. Command-line flags
2. Configuration file settings
3. Defaults

That is: defaults are overridden by options specified in `_config.yml`,
and flags specified at the command-line will override all other settings
specified elsewhere.

**Note: From v3.3.0 onward, Jekyll does not process `node_modules` and certain subdirectories within `vendor`, by default. But, by having an `exclude:` array defined explicitly in the config file overrides this default setting, which results in some users to encounter an error in building the site, with the following error message:**

```sh
    ERROR: YOUR SITE COULD NOT BE BUILT:
    ------------------------------------
    Invalid date '<%= Time.now.strftime('%Y-%m-%d %H:%M:%S %z') %>':
    Document 'vendor/bundle/gems/jekyll-3.4.3/lib/site_template/_posts/0000-00-00-welcome-to-jekyll.markdown.erb'
    does not have a valid date in front matter.
```

Adding `vendor/bundle` to the `exclude:` list will solve this problem but will lead to having other sub-directories under `/vendor/` (and also `/node_modules/`, if present) be processed to the destination folder `_site`.


The proper solution is to incorporate the default setting for `exclude:` rather than override it completely:

For versions up to `v3.4.3`, the `exclude:` setting must look like following:

```yaml
exclude:
  - Gemfile
  - Gemfile.lock
  - node_modules
  - vendor/bundle/
  - vendor/cache/
  - vendor/gems/
  - vendor/ruby/
  - any_additional_item # any user-specific listing goes at the end
```

From `v3.5` onward, `Gemfile` and `Gemfile.lock` are also excluded by default. So, in most cases there is no need to define another `exclude:` array in the config file. So an existing definition can either be modified as above, or removed completely, or commented out to enable easy edits in future.


## Markup Problems

The various markup engines that Jekyll uses may have some issues. This
page will document them to help others who may run into the same
problems.

### Liquid

Liquid version 2.0 seems to break the use of `{{ "{{" }}` in templates.
Unlike previous versions, using `{{ "{{" }}` in 2.0 triggers the following error:

```sh
'{{ "{{" }}' was not properly terminated with regexp: /\}\}/  (Liquid::SyntaxError)
```

### Excerpts

Since v1.0.0, Jekyll has had automatically-generated post excerpts. Since
v1.1.0, Jekyll also passes these excerpts through Liquid, which can cause
strange errors where references don't exist or a tag hasn't been closed. If you
run into these errors, try setting `excerpt_separator: ""` in your
`_config.yml`, or set it to some nonsense string.

## Production Problems

If you run into an issue that a static file can't be found in your
production environment during build since v3.2.0 you should set your
[environment to `production`](/docs/configuration/environments/).
The issue is caused by trying to copy a non-existing symlink.

<div class="note">
  <h5>Please report issues you encounter!</h5>
  <p>
  If you come across a bug, please <a href="{{ site.repository }}/issues/new">create an issue</a>
  on GitHub describing the problem and any work-arounds you find so we can
  document it here for others.
  </p>
</div>
