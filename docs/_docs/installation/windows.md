---
title: Jekyll on Windows
permalink: /docs/installation/windows/
redirect_from:
  - /docs/windows/
---

While Windows is not an officially-supported platform, it can be used to run Jekyll with the proper tweaks.

## Installing Ruby and Jekyll

### Installation via RubyInstaller

The easiest way to install Ruby and Jekyll is by using the [RubyInstaller](https://rubyinstaller.org/) for Windows.

RubyInstaller is a self-contained Windows-based installer that includes the Ruby language, an execution environment,
important documentation, and more.

We only cover RubyInstaller-2.4 and newer here. Older versions need to
[install the Devkit](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit) manually.

1. Download and install a **Ruby+Devkit** version from [RubyInstaller Downloads](https://rubyinstaller.org/downloads/).
   Use default options for installation.
2. Run the `ridk install` step on the last stage of the installation wizard. This is needed for installing gems with native
   extensions. You can find additional information regarding this in the
   [RubyInstaller Documentation](https://github.com/oneclick/rubyinstaller2#using-the-installer-on-a-target-system)
3. Open a new command prompt window from the start menu, so that changes to the `PATH` environment variable becomes effective.
   Install Jekyll and Bundler using `gem install jekyll bundler`
4. Check if Jekyll has been installed properly: `jekyll -v`

{: .note .info}
You may receive an error when checking if Jekyll has been installed properly. Reboot your system and run `jekyll -v` again.
If the error persists, please open a [RubyInstaller issue](https://github.com/oneclick/rubyinstaller2/issues/new).

That's it, you're ready to use Jekyll!

### Installation via Bash on Windows 10

If you are using Windows 10 version 1607 or later, another option to run Jekyll is by
[installing](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide) the Windows Subsystem for Linux.

{: .note .info}
You must have [Windows Subsystem for Linux](https://msdn.microsoft.com/en-us/commandline/wsl/about) enabled.

Make sure all your packages and repositories are up to date. Open a new Command Prompt or Powershell window and type `bash`.

Your terminal should now be a Bash instance. Next, update your repository lists and packages:

```sh
sudo apt-get update -y && sudo apt-get upgrade -y
```

Next, install Ruby. To do this, let's use a repository from [BrightBox](https://www.brightbox.com/docs/ruby/ubuntu/),
which hosts optimized versions of Ruby for Ubuntu.

```sh
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.5 ruby2.5-dev build-essential dh-autoreconf
```

Next, update your Ruby gems:

```sh
gem update
```

Install Jekyll:

```sh
gem install jekyll bundler
```

{: .note .info}
  No `sudo` here.

Check your Jekyll version:

```sh
jekyll -v
```

That's it! You're ready to start using Jekyll. 

You can make sure time management is working properly by inspecting your `_posts` folder. You should see a markdown file
with the current date in the filename.

<div class="note info">
  <h5>Non-superuser account issues</h5>
  <p>If the `jekyll new` command prints the error "Your user account isn't allowed to install to the system RubyGems", see
  the "Running Jekyll as Non-Superuser" instructions in
  <a href="{{ '/docs/troubleshooting/#no-sudo' | relative_url }}">Troubleshooting</a>.</p>
</div>

{: .note .info}
Bash on Ubuntu on Windows is still under development, so you may run into issues.

## Encoding

If you use UTF-8 encoding, Jekyll will break if a file starts with characters representing a [BOM](https://en.wikipedia.org/wiki/Byte_order_mark#UTF-8). Therefore, remove this sequence of bytes if it appears at the beginning of your file.

Additionally, you might need to change the code page of the console window to UTF-8 in case you get a
`Liquid Exception: Incompatible character encoding` error during the site generation process. Run the following:

```sh
chcp 65001
```

## Time Zone Management

Since Windows doesn't have a native source of zoneinfo data, the Ruby Interpreter doesn't understand IANA Timezones.
Using them had the `TZ` environment variable default to UTC/GMT 00:00.

Though Windows users could alternatively define their blog's timezone by setting the key to use the POSIX format of defining
timezones, it wasn't as user-friendly when it came to having the clock altered to changing DST-rules.

Jekyll now uses a rubygem to internally configure Timezone based on established
[IANA Timezone Database](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

While 'new' blogs created with Jekyll v3.4 and greater, will have the following added to their `Gemfile` by default, existing
sites *will* have to update their `Gemfile` (and installed gems) to enable development on Windows:

```ruby
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```

<div class="note warning">
  <h5>TZInfo 2.0 incompatibility</h5>
  <p>
    Version 2.0 of the TZInfo library has introduced a change in how timezone offsets are calculated.
    This will result in incorrect date and time for your posts when the site is built with Jekyll 3.x on Windows.
  </p>
  <p>
    We therefore recommend that you lock the Timezone library to version 1.2 and above by listing
    <code>gem 'tzinfo', '~> 1.2'</code> in your <code>Gemfile</code>.
  </p>
</div>

## Auto Regeneration

Jekyll uses the `listen` gem to watch for changes when the `--watch` switch is specified during a build or serve.
While `listen` has built-in support for UNIX systems, it may require an extra gem for compatibility with Windows.

Add the following to the `Gemfile` for your site if you have issues with auto-regeneration on Windows alone:

```ruby
gem 'wdm', '~> 0.1.1', :install_if => Gem.win_platform?
```

You have to use a [Ruby+Devkit](https://rubyinstaller.org/downloads/) version of the RubyInstaller and install
the MSYS2 build tools to successfully install the `wdm` gem.
