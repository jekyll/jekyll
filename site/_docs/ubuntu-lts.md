---
layout: docs
title: Jekyll on Ubuntu LTS
permalink: /docs/linux/ubuntu
---

While linux installs are generally well documented through the web, some are patchy. 
For LTS releases such as Ubuntu 14.04, it seems things will change less, and it is a 
common platform.

## Pre-requisites

Before attempting to follow this guide you should have installed Ubuntu 14.04, be in 
posession of a sudo-capable user account, and be reasonably well versed in the 
art-of-shell.

{% highlight bash %}
sudo apt-get update && apt-get upgrade -y
sudo apt-get install ruby ruby-dev make gcc nodejs -y
{% endhighlight %}

## Installation

{% highlight bash %}
sudo gem install jekyll
{% endhighlight %}

