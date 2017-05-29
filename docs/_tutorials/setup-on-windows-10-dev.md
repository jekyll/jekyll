---
layout: tutorials
permalink: /tutorials/setup-on-windows-10-dev.md/
title: Set up jekyll on Windows 10 Creators Update
---


## Getting Started

To use jekyll on Windows 10 Creators Update, we must first enable the Developer tools. This can be done by following the [Guide on Microsoft.com](https://msdn.microsoft.com/en-us/commandline/wsl/install_guide).


## Update Ubuntu and Install Ruby
---
Open a new Command Prompt instance. Run the "bash" command to turn your command prompt into a Bash on Ubuntu on Windows instance.

```
sudo apt-get update -y && sudo apt-get upgrade -y
```

This downloads the most recent package lists from your currently installed repositories so you can be ensured you don't accidentally get an out-of-date package, and then installs the newest versions of the packages.

Now we can install Ruby. First we need to add the repository list from BrightBox.

```
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.3 ruby2.3-dev
```

*Please note:* You can also install Ruby 1.9.3 via

```
sudo apt-get install build-essentials ruby-full

```

And now lets update our Ruby gems:

```
sudo gem update

```

Now all that is left to do is install Jekyll.

```
sudo gem install jekyll bundler

```
**And thats it!**

*Please note:* Ubuntu on Windows is still in development, so there may still be bugs/issues. Please report any you encounter on our GitHub.
