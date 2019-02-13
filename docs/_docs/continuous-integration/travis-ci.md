---
title: "Travis CI"
---

You can test your website build against one or more versions of Ruby.
The following guide will show you how to set up a free build environment on
[Travis][travis], with [GitHub][github] integration for pull requests.

[travis]: https://travis-ci.org/
[github]: https://github.com/

## 1. Enabling Travis and GitHub

To enable Travis builds for your GitHub repository:

1. Go to your profile on travis-ci.org: https://travis-ci.org/profile/username
2. Find the repository for which you're interested in enabling builds.
3. Flick the repository switch on so that it turns blue.
4. Optionally configure the build by clicking on the gear icon. Further
   configuration happens via your `.travis.yml` file. More details below.

## 2. The Test Script

The simplest test script runs `jekyll build` and ensures that Jekyll
doesn't fail to build the site. It doesn't check the resulting site, but it
does ensure things are built properly.

When testing Jekyll output, there is no better tool than [html-proofer][html-proofer].
This tool checks your resulting site to ensure all links and images exist.
Utilize it either with the convenient `htmlproofer` command-line executable,
or write a Ruby script which utilizes the gem.

Save the commands you want to run and succeed in a file: `./script/cibuild`

### The HTML Proofer Executable

```sh
#!/usr/bin/env bash
set -e # halt script on error

bundle exec jekyll build
bundle exec htmlproofer ./_site
```

Some options can be specified via command-line switches. Check out the
`html-proofer` README for more information about these switches, or run
`htmlproofer --help` locally.

For example to avoid testing external sites, use this command:

```sh
bundle exec htmlproofer ./_site --disable-external
```

### The HTML Proofer Library

You can also invoke `html-proofer` in Ruby scripts (e.g. in a Rakefile):

```ruby
#!/usr/bin/env ruby

require 'html-proofer'
HTMLProofer.check_directory("./_site").run
```

Options are given as a second argument to `.new`, and are encoded in a
symbol-keyed Ruby Hash. For more information about the configuration options,
check out `html-proofer`'s README file.

[html-proofer]: https://github.com/gjtorikian/html-proofer

## 3. Configuring Your Travis Builds

This file is used to configure your Travis builds. Because Jekyll is built
with Ruby and requires RubyGems to install, we use the Ruby language build
environment. Below is a sample `.travis.yml` file, followed by
an explanation of each line.

**Note:** You will need a Gemfile as well, [Travis will automatically install](https://docs.travis-ci.com/user/languages/ruby/#Dependency-Management) the dependencies based on the referenced gems. Here is an example `Gemfile` with two referenced gems, "jekyll" and "html-proofer":

```ruby
source "https://rubygems.org"

gem "jekyll"
gem "html-proofer"
```

Your `.travis.yml` file should look like this:

```yaml
language: ruby
rvm:
  - 2.4.1

before_script:
 - chmod +x ./script/cibuild # or do this locally and commit

# Assume bundler is being used, therefore
# the `install` step will run `bundle install` by default.
script: ./script/cibuild

# branch whitelist, only for GitHub Pages
branches:
  only:
  - gh-pages     # test the gh-pages branch
  - /pages-(.*)/ # test every branch which starts with "pages-"

env:
  global:
  - NOKOGIRI_USE_SYSTEM_LIBRARIES=true # speeds up installation of html-proofer

addons:
  apt:
    packages:
    - libcurl4-openssl-dev

sudo: false # route your build to the container-based infrastructure for a faster build

cache: bundler # caching bundler gem packages will speed up build

# Optional: disable email notifications about the outcome of your builds
notifications:
  email: false
```

Ok, now for an explanation of each line:

```yaml
language: ruby
```

This line tells Travis to use a Ruby build container. It gives your script
access to Bundler, RubyGems, and a Ruby runtime.

```yaml
rvm:
  - 2.4.1
```

RVM is a popular Ruby Version Manager (like rbenv, chruby, etc). This
directive tells Travis the Ruby version to use when running your test
script. Use a [version which is pre-installed on the Travis build docker][5]
image to speed up the build.

```yaml
before_script:
 - chmod +x ./script/cibuild
```

The build script file needs to have the *executable* attribute set or
Travis will fail with a permission denied error. You can also run this
locally and commit the permissions directly, thus rendering this step
irrelevant.

```yaml
script: ./script/cibuild
```

Travis allows you to run any arbitrary shell script to test your site. One
convention is to put all scripts for your project in the `script`
directory, and to call your test script `cibuild`. This line is completely
customizable. If your script won't change much, you can write your test
incantation here directly:

```yaml
install: gem install jekyll html-proofer
script: jekyll build && htmlproofer ./_site
```

The `script` directive can be absolutely any valid shell command.

```yaml
# branch whitelist, only for GitHub Pages
branches:
  only:
  - gh-pages     # test the gh-pages branch
  - /pages-(.*)/ # test every branch which starts with "pages-"
```

You want to ensure the Travis builds for your site are being run only on
the branch or branches which contain your site. One means of ensuring this
isolation is including a branch whitelist in your Travis configuration
file. By specifying the `gh-pages` branch, you will ensure the associated
test script (discussed above) is only executed on site branches. If you use
a pull request flow for proposing changes, you may wish to enforce a
convention for your builds such that all branches containing edits are
prefixed, exemplified above with the `/pages-(.*)/` regular expression.

The `branches` directive is completely optional. Travis will build from every
push to any branch of your repo if leave it out.

```yaml
env:
  global:
  - NOKOGIRI_USE_SYSTEM_LIBRARIES=true # speeds up installation of html-proofer
```

Using `html-proofer`? You'll want this environment variable. Nokogiri, used
to parse HTML files in your compiled site, comes bundled with libraries
which it must compile each time it is installed. Luckily, you can
dramatically decrease the install time of Nokogiri by setting the
environment variable `NOKOGIRI_USE_SYSTEM_LIBRARIES` to `true`.

<div class="note warning">
  <h5>Be sure to exclude <code>vendor</code> from your
   <code>_config.yml</code></h5>
  <p>Travis bundles all gems in the <code>vendor</code> directory on its build
   servers, which Jekyll will mistakenly read and explode on.</p>
</div>

```yaml
exclude: [vendor]
```

By default you should supply the `sudo: false` command to Travis. This command
explicitly tells Travis to run your build on Travis's [container-based
 infrastructure](https://docs.travis-ci.com/user/workers/container-based-infrastructure/#Routing-your-build-to-container-based-infrastructure). Running on the container-based infrastructure can often times
speed up your build. If you have any trouble with your build, or if your build
does need `sudo` access, modify the line to `sudo: required`.

```yaml
sudo: false
```

To speed up the build, you should cache the gem packages created by `bundler`.
Travis has a pre-defined [cache strategy for this tool][6] which should have
all the default configs to do exactly that.

```yaml
cache: bundler
```

Optionally, if you are not interested in the build email notifications you
can disable them with this configuration. Travis supports a wide array of
notification services, you may find [another one more useful (e.g. slack)][7].

```yaml
notifications:
  email: false
```

### Troubleshooting

**Travis error:** *"You are trying to install in deployment mode after changing
your Gemfile. Run bundle install elsewhere and add the updated Gemfile.lock
to version control."*

**Workaround:** Either run `bundle install` locally and commit your changes to
`Gemfile.lock`, or remove the `Gemfile.lock` file from your repository and add
an entry in the `.gitignore` file to avoid it from being checked in again.

### Questions?

This entire guide is open-source. Go ahead and [edit it][3] if you have a
fix or [ask for help][4] if you run into trouble and need some help.

[3]: https://github.com/jekyll/jekyll/edit/master/docs/_docs/continuous-integration/travis-ci.md
[4]: https://jekyllrb.com/help/
[5]: https://docs.travis-ci.com/user/languages/ruby/#Specifying-Ruby-versions-and-implementations
[6]: https://docs.travis-ci.com/user/caching/#Caching-directories-(Bundler%2C-dependencies)
[7]: https://docs.travis-ci.com/user/notifications/
