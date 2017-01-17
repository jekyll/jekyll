---
title: Installation
permalink: /docs/installation/
---

Getting Jekyll installed and ready-to-go should only take a few minutes.
If it ever becomes a pain, please [file an issue]({{ site.repository }}/issues/new)
(or submit a pull request) describing the issue you
encountered and how we might make the process easier.

### Requirements

Installing Jekyll is easy and straight-forward, but there are a few
requirements you’ll need to make sure your system has before you start.

- [Ruby](https://www.ruby-lang.org/en/downloads/) (including development
  headers, v1.9.3 or above for Jekyll 2 and v2 or above for Jekyll 3)
- [RubyGems](https://rubygems.org/pages/download)
- Linux, Unix, or macOS
- [NodeJS](https://nodejs.org/), or another JavaScript runtime (Jekyll 2 and
earlier, for CoffeeScript support).
- [Python 2.7](https://www.python.org/downloads/) (for Jekyll 2 and earlier)
- [GCC](https://gcc.gnu.org/install/) and [Make](https://www.gnu.org/software/make/) (in case your system doesn't have them installed, which you can check by running `gcc -v` and `make -v` in your system's command line interface)

<div class="note info">
  <h5>Running Jekyll on Windows</h5>
  <p>
    While Windows is not officially supported, it is possible to get it running
    on Windows. Special instructions can be found on our
    <a href="../windows/#installation">Windows-specific docs page</a>.
  </p>
</div>

## Install with RubyGems

The best way to install Jekyll is via
[RubyGems](https://rubygems.org/pages/download). At the terminal prompt,
simply run the following command to install Jekyll:

```sh
$ gem install jekyll
```

All of Jekyll’s gem dependencies are automatically installed by the above
command, so you won’t have to worry about them at all. If you have problems
installing Jekyll, check out the [troubleshooting](../troubleshooting/) page or
[report an issue]({{ site.repository }}/issues/new) so the Jekyll
community can improve the experience for everyone.

<div class="note info">
  <h5>Installing Xcode Command-Line Tools</h5>
  <p>
    If you run into issues installing Jekyll's dependencies which make use of
    native extensions and are using macOS, you will need to install Xcode
    and the Command-Line Tools it ships with. Download them in
    <code>Preferences &#8594; Downloads &#8594; Components</code>.
  </p>
</div>

## Pre-releases

In order to install a pre-release, make sure you have all the requirements
installed properly and run:

```sh
gem install jekyll --pre
```

This will install the latest pre-release. If you want a particular pre-release,
use the `-v` switch to indicate the version you'd like to install:

```sh
gem install jekyll -v '2.0.0.alpha.1'
```

If you'd like to install a development version of Jekyll, the process is a bit
more involved. This gives you the advantage of having the latest and greatest,
but may be unstable.

```sh
$ git clone git://github.com/jekyll/jekyll.git
$ cd jekyll
$ script/bootstrap
$ bundle exec rake build
$ ls pkg/*.gem | head -n 1 | xargs gem install -l
```

## Optional Extras

There are a number of (optional) extra features that Jekyll supports that you
may want to install, depending on how you plan to use Jekyll. These extras
include LaTeX support, and the use of alternative content rendering engines.
Check out [the extras page](../extras/) for more information.

<div class="note">
  <h5>ProTip™: Enable Syntax Highlighting</h5>
  <p>
    If you’re the kind of person who is using Jekyll, then chances are you’ll
    want to enable syntax highlighting using <a href="http://pygments.org/">Pygments</a>
    or <a href="https://github.com/jayferd/rouge">Rouge</a>. You should really
    <a href="../templates/#code-snippet-highlighting">check out how to
    do that</a> before you go any farther.
  </p>
</div>

## Already Have Jekyll?

Before you start developing with Jekyll, you may want to check that you're up to date with the latest version. To find your version of Jekyll, run one of these commands:

```sh
$ jekyll --version
$ gem list jekyll
```

You can also use [RubyGems](https://rubygems.org/gems/jekyll) to find the current versioning of any gem. But you can also use the `gem` command line tool:

```sh
$ gem search jekyll --remote
```

and you'll search for just the name `jekyll`, and in brackets will be latest version. Another way to check if you have the latest version is to run the command `gem outdated`. This will provide a list of all the gems on your system that need to be updated. If you aren't running the latest version, run this command:

```sh
$ gem update jekyll
```

Now that you’ve got everything up-to-date and installed, let’s get to work!
