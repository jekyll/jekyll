---
layout: docs
title: Jekyll on Ubuntu
permalink: /docs/linux/ubuntu
---

While linux installs are generally well documented through the web, some are patchy. 
For LTS releases such as Ubuntu 14.04, it seems things will change less, and it is a 
common platform. This guide is written for 14.04 specifically, but should be valid 
for 15.04, 14.10 and other derrivatives.

## Pre-requisites

Before attempting to follow this guide you should have installed Ubuntu 14.04, be in 
posession of a sudo-capable user account (to install dependencies), and be reasonably 
well versed in the art-of-shell.

> N.b. If Ruby 2.2 and other dependencies via apt-get are installed, sudo is not required as you can modify the calls to `gem install`, to `gem --user-install`. 

Firstly for a decent hassle-free ruby version you'll need to add a third-party repository.

{% highlight bash %}
sudo add-apt-repository ppa:brightbox/ruby-ng
{% endhighlight %}

Followed by `<ENTER>` key to continue.

{% highlight bash %}
sudo apt-get update && apt-get upgrade -y
sudo apt-get install ruby2.2 ruby2.2-dev build-essential libxml2-dev libxslt1-dev libyaml-dev -y
{% endhighlight %}

## Installation

For stable run

{% highlight bash %}
sudo apt-get install nodejs
sudo gem install jekyll
{% endhighlight %}

For in-development *(currently 3.x-beta)*

{% highlight bash %}
sudo gem install therubyracer
sudo gem install jekyll --pre
{% endhighlight %}
