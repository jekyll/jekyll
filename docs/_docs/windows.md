---
title: Jekyll on Windows
permalink: /docs/windows/
---

While Windows is not an officially-supported platform, it can be used to run Jekyll with the proper tweaks. This page aims to collect some of the general knowledge and lessons that have been unearthed by Windows users.


## Installing Jekyll

If you are using Windows 10 Anniversary Update, the easiest way to run Jekyll is by [installing][WSL-Guide] the new Bash on Ubuntu on Windows.


### Installation via Bash on Windows 10

*Note:* You must have [Bash on Ubuntu on Windows][BASH-WSL] enabled.

First let's make sure all our packages / repositories are up to date. Open a new Command Prompt instance, and type the following:

```sh
bash
```
Your Command Prompt instance should now be a Bash instance. Now we must update our repo lists and packages.

```sh
sudo apt-get update -y && sudo apt-get upgrade -y
```
Now we can install Ruby. To do this we will use a repository from [BrightBox](https://www.brightbox.com/docs/ruby/ubuntu/), which hosts optimized versions of Ruby for Ubuntu.

```sh
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.3 ruby2.3-dev build-essential
```

Next let's update our Ruby gems:

```sh
sudo gem update
```

Now all that is left to do is install Jekyll.

```sh
sudo gem install jekyll bundler
```

Check if Jekyll installed properly by running:

```sh
jekyll -v
```

**And that's it!**

To start a new project named `my_blog`, just run:

```sh
jekyll new my_blog
```

You can make sure time management is working properly by inspecting your `_posts` folder. You should see a markdown file with the current date in the filename.

**Note:** Bash on Ubuntu on Windows is still under development, so you may run into issues.


[WSL-Guide]: https://msdn.microsoft.com/en-us/commandline/wsl/install_guide
[BASH-WSL]: https://msdn.microsoft.com/en-us/commandline/wsl/about


### Installation via RubyInstaller

[RubyInstaller][] is a self-contained Windows-based installer that includes the Ruby language, an execution environment, important documentation, and more.

1. Download and Install a package manager version from [RubyInstaller Downloads][RubyInstaller-downloads].
2. Install Jekyll and Bundler via a command prompt window: `gem install jekyll bundler`
3. Check if Jekyll installed properly: `jekyll -v`

[RubyInstaller]: https://rubyinstaller.org/
[RubyInstaller-downloads]: https://rubyinstaller.org/downloads/


### Installation via Chocolatey

A quick way to install Jekyll using Chocolatey is to follow the [installation instructions by David Burela](https://davidburela.wordpress.com/2015/11/28/easily-install-jekyll-on-windows-with-3-command-prompt-entries-and-chocolatey/):

 1. Install a package manager for Windows called [Chocolatey][]
 2. Install Ruby via Chocolatey: `choco install ruby -y`
 3. Reopen a command prompt and install Jekyll: `gem install jekyll`

Updates in the infrastructure of Ruby may cause SSL errors when attempting to use `gem install` with versions of the RubyGems package older than 2.6. (The RubyGems package installed via the Chocolatey tool is version 2.3) If you have installed an older version, you can update the RubyGems package using the directions [here][ssl-certificate-update].

[ssl-certificate-update]: http://guides.rubygems.org/ssl-certificate-update/#installing-using-update-packages


### Installing *github-pages* via Chocolatey

This section is part of an article written by [Jens Willmer][jwillmerPost]. To follow the instructions you need to have [Chocolatey][] installed on your system. If you already have a version of Ruby installed you need to uninstall it before you can continue.


#### Install Ruby and Ruby development kit

Open a command prompt and execute the following commands:

 * `choco install ruby -version 2.2.4`
 * `choco install ruby2.devkit` - _needed for compilation of json gem_


#### Configure Ruby development kit

The development kit did not set the environment path for Ruby so we need to do it.

 * Open command prompt in `C:\tools\DevKit2`
 * Execute `ruby dk.rb init` to create a file called `config.yml`
 * Edit the `config.yml` file and include the path to Ruby `- C:/tools/ruby22`
 * Execute the following command to set the path: `ruby dk.rb install`


#### Nokogiri gem installation

This gem is also needed in the github-pages and to get it running on Windows x64 we have to install a few things.

**Note:** In the current [pre release][nokogiriFails] it works out of the box with Windows x64 but this version is not referenced in the github-pages.

```sh
choco install libxml2 -Source "https://www.nuget.org/api/v2/"

choco install libxslt -Source "https://www.nuget.org/api/v2/"

choco install libiconv -Source "https://www.nuget.org/api/v2/

gem install nokogiri --^
   --with-xml2-include=C:\Chocolatey\lib\libxml2.2.7.8.7\build\native\include^
   --with-xml2-lib=C:\Chocolatey\lib\libxml2.redist.2.7.8.7\build\native\bin\v110\x64\Release\dynamic\cdecl^
   --with-iconv-include=C:\Chocolatey\lib\libiconv.1.14.0.11\build\native\include^
   --with-iconv-lib=C:\Chocolatey\lib\libiconv.redist.1.14.0.11\build\native\bin\v110\x64\Release\dynamic\cdecl^
   --with-xslt-include=C:\Chocolatey\lib\libxslt.1.1.28.0\build\native\include^
   --with-xslt-lib=C:\Chocolatey\lib\libxslt.redist.1.1.28.0\build\native\bin\v110\x64\Release\dynamic
```

#### Install github-pages

  * Open command prompt and install [Bundler][]: `gem install bundler`
  * Create a file called `Gemfile` without any extension in your root directory of your blog
  * Copy & paste the two lines into the file:


```ruby
source 'https://rubygems.org'
gem 'github-pages', group: :jekyll_plugins
```

 * **Note:** We use an unsecure connection because SSL throws exceptions in the version of Ruby
 * Open a command prompt, target your local blog repository root, and install github-pages: `bundle install`


After this process you should have github-pages installed on your system and you can host your blog again with `jekyll s`.
There will be a warning on startup that you should include `gem 'wdm', '>= 0.1.0' if Gem.win_platform?` to your `Gemfile` but I could not get `jekyll s` working if I include that line so for the moment I ignore that warning.

In the future the installation process of the github-pages should be as simple as the setup of the blog. But as long as the new version of the Nokogiri ([v1.6.8][nokogiriReleases]) is not stable and referenced, it is work to get it up and running on Windows.

[jwillmerPost]: https://jwillmer.de/blog/tutorial/how-to-install-jekyll-and-pages-gem-on-windows-10-x46 "Installation instructions by Jens Willmer"
[Chocolatey]: https://chocolatey.org/install "Package manager for Windows"
[nokogiriFails]: https://github.com/sparklemotion/nokogiri/issues/1456#issuecomment-206481794 "Nokogiri fails to install on Ruby 2.3 for Windows"
[Bundler]: http://bundler.io/ "Ruby Dependencie Manager"
[nokogiriReleases]: https://github.com/sparklemotion/nokogiri/releases "Nokogiri Releases"

For a more conventional way of installing Jekyll you can follow this [complete guide to install Jekyll 3 on Windows by Sverrir Sigmundarson][windows-installjekyll3].

Optionally you can use [Autoinstall Jekyll for Windows][fastjekyll-autoinstall].

[windows-installjekyll3]: https://labs.sverrirs.com/jekyll/
[fastjekyll-autoinstall]: https://github.com/KeJunMao/fastjekyll#autoinstall-jekyll-for-windows


## Encoding

If you use UTF-8 encoding, make sure that no `BOM` header characters exist in your files or very, very bad things will happen to
Jekyll. This is especially relevant when you're running Jekyll on Windows.

Additionally, you might need to change the code page of the console window to UTF-8 in case you get a "Liquid Exception: Incompatible character encoding" error during the site generation process. It can be done with the following command:

```sh
chcp 65001
```


## Time-Zone Management

Since Windows doesn't have a native source of zoneinfo data, the Ruby Interpreter would not understand IANA Timezones and hence using them had the `TZ` environment variable default to UTC/GMT 00:00.
Though Windows users could alternatively define their blog's timezone by setting the key to use POSIX format of defining timezones, it wasn't as user-friendly when it came to having the clock altered to changing DST-rules.

Jekyll now uses a rubygem to internally configure Timezone based on established [IANA Timezone Database][IANA-database].
While 'new' blogs created with Jekyll v3.4 and greater, will have the following added to their 'Gemfile' by default, existing sites *will* have to update their 'Gemfile' (and installed) to enable development on Windows:

```ruby
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
```

[IANA-database]: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones


## Auto Regeneration

Jekyll uses the `listen` gem to watch for changes when the `--watch` switch is specified during a build or serve. While `listen` has built-in support for UNIX systems, it may require an extra gem for compatibility with Windows.

Add the following to the Gemfile for your site if you have issues with auto-regeneration on Windows alone:

```ruby
gem 'wdm', '~> 0.1.1' if Gem.win_platform?
```

You may first have to download and install the [Ruby DevKit](https://rubyinstaller.org/downloads/) by following [the instructions here](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit).
